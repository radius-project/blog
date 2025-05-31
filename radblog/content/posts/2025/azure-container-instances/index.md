---
date: "2026-06-02T08:00:00-08:00"
title: "Deploy your Radius applications to Azure Container Instances"
linkTitle: "Azure Container Instances"
author: "[Will Tsai](https://www.github.com/willtsai)"
type: blog
---

An important part of the Radius vision is to be platform agnostic, and that includes the underlying compute such that Radius can deploy the same application across different compute platforms. Thus, it's always been a goal to support additional container runtimes beyond just Kubernetes. That's why we're excited to share that Radius now supports deploying your applications to additional container platforms, beginning with [Azure Container Instances](https://docs.radapp.io/guides/author-apps/azure/azure-container-instances/). This integration provides Radius users with a serverless container runtime option that eliminates the need to maintain underlying compute infrastructure while still benefiting from the Radius application-centric approach and separation of concerns.

> To see a demo of this feature, check out the recording of Mark Russinovich's [Inside Azure Innovations](https://youtu.be/lHBo_lDWFcI?si=U8KG05S2z-_MFkDh&t=2487) session from the Microsoft Build 2025 event

In this post, we'll walk through at a high-level how to deploy your Radius applications to Azure Container Instances, as well as explore specific details behind the integration. For a more detailed guide, check out the [How-To: Deploy an Application to Azure Container Instances](https://docs.radapp.io/guides/author-apps/azure/azure-container-instances/) guide in the Radius documentation.

## What is Azure Container Instances?

Azure Container Instances (ACI) is a serverless container platform in Microsoft Azure that allows users to run containerized applications without managing underlying infrastructure, such as virtual machines or complex orchestration systems. It provides a lightweight, unopinionated compute environment where containers can be deployed quickly, starting in seconds, with configurable CPU and memory resources. ACI is well-suited for cloud-native applications, task automation, build jobs, or any scenario where a lightweight, fast-starting container is beneficial without the overhead of managing a full orchestration system. To learn more about ACI, check out the [official documentation](https://learn.microsoft.com/en-us/azure/container-instances/) from Azure.

## Why ACI with Radius?

We chose to integrate ACI first because the Radius maintainers wanted the first expansion beyond Kubernetes to be into a serverless compute platform. Because ACI offers basic, unopinionated building blocks of compute, it provides us with more flexibility in building the integration in an extensible way that covers all the compute primitives available in Kubernetes today. Hopefully, this allows us to better learn how to model the extensibility of Radius core to pave the way for expansion into other container platforms like AWS Elastic Container Service and beyond, including into more opinionated or specialized compute offerings like Azure Functions or AWS Lambda.

## Deploying to ACI using Radius

> Note: This section provides a high-level overview of the deployment process. For a step-by-step guide, see the [How-To: Deploy an Application to Azure Container Instances](https://docs.radapp.io/guides/author-apps/azure/azure-container-instances/) guide in the Radius documentation.

To deploy your Radius applications to ACI, you'll first need to ensure you have an Azure provider configured and registered with your Radius control plane. If you haven't set up Radius yet, you can install it using the rad CLI and connect it to your Azure subscription. For detailed instructions, refer to the [Radius installation](https://docs.radapp.io/guides/operations/kubernetes/install/) and [Azure provider](https://docs.radapp.io/guides/operations/providers/azure-provider/) guides.

### Create an ACI environment

Once your Azure provider is set up, you can create a Radius Environment that is configured to ACI for its underlying compute. This environment will be the deployment target for your applications bound for ACI. Creating the ACI environment is the same as creating any other environment in Radius, except that you'll specify ACI as the compute platform along with other needed configurations in the environment definition file, for example:

```bicep
resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'aci-demo'
  properties: {
    compute: {
      kind: 'aci'
      // Replace value with your resource group ID
      resourceGroup: '/subscriptions/<>/resourceGroups/<>'
      identity: {
        kind:'userAssigned'
        // Replace value with your managed identity resource ID
        managedIdentity: ['/subscriptions/<>/resourceGroups/<>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<>']
      }
    }
    providers: {
      azure: {
        // Replace value with your resource group ID
        scope: '/subscriptions/<>/resourceGroups/<>'
      }
    }
  }
}
```

> Note that a [managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/) is required for ACI deployments. If you choose to utilize a [user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp), then you need to ensure it is assigned to the `Contributor` and `Azure Container Instances Contributor` roles on the subscription and resource group where the ACI containers will be deployed.

Then, just like any other Radius environment, you deploy this ACI environment using the `rad deploy` command. When Radius creates and deploys the environment, it will provision the relevant Azure resources required to host your applications in ACI, including the virtual network, internal load balancer, and network security group.

{{< image src="images/azure-portal-env.png" alt="screenshot of the Azure portal showing the ACI environment created by Radius" width=600 >}}

### Define and deploy your application

With your environment ready, you can proceed to deploy your application to ACI without changing how you define your applications in Radius. Your Radius application definition includes your container specifications, environment variables, and any required connections to other resources. The beauty of Radius is that the application definitions remain consistent regardless of whether you're targeting Kubernetes or ACI.

Once your application is defined, you can deploy it using the `rad deploy` command, specifying ACI as your target platform.

For example, if you have an application defined in a Bicep file named `app.bicep`, you can deploy it to your ACI environment like this:

```bash
rad deploy ./app.bicep --environment aci-demo
```

Alternatively, if you have a workspace set up for ACI, you can deploy your application using the workspace flag:

```bash
rad deploy ./app.bicep --workspace aci-workspace
```

Behind the scenes, Radius handles the translation of your application model into the appropriate Azure resources, including container groups and networking components, and provisions them accordingly on your behalf:

{{< image src="images/azure-portal-env.png" alt="screenshot of the Azure portal showing the ACI environment created by Radius" width=600 >}}
<br>

The entire process leverages Radius's application-centric approach, allowing you to focus on defining what your application needs rather than the underlying infrastructure details specific to ACI.

## How it works

Currently, ACI support is hardcoded as imperative Go code in the Radius core codebase, including the resource provider (RP), Recipes, data model, and other components. The Environment and Container resource schemas were updated to include ACI-specific properties. If you're interested in diving deeper into the implementation details, you can refer to the code changes in [PR #9436](https://github.com/radius-project/radius/pull/9436).

### ACI NGroups
The Radius integration leverages the [ACI NGroups functionality](https://learn.microsoft.com/en-us/azure/container-instances/container-instance-ngroups/container-instances-about-ngroups), which provides a single NGroups API call to create and maintain N number of container instances using a common template. This type of orchestration capability made it possible to build the integration necessary to enable deployment of application containers and NGroups resources to ACI using Radius.

### Azure resources provisioned by Radius

When you deploy an application to ACI using Radius, it provisions the necessary Azure resources automatically, including:
- **Load balancer**: ACI requires an internal load balancer to manage traffic to the container instances. Radius provisions a load balancer that routes traffic to your application containers.
- **Virtual Network**: ACI requires a virtual network for networking and security. Radius provisions a virtual network and subnet for your ACI deployments.
- **Network Security Group**: ACI deployments require a network security group to control inbound and outbound traffic. Radius creates a security group with appropriate rules based on your application requirements.
- **Container Group Profiles**: ACI supports container group profiles, which allow you to define common settings for multiple container groups. Radius sets up these profiles based on your application definitions, enabling consistent configurations across deployments.
- **Container NGroups**: Radius creates container NGroups to manage multiple instances of your application containers.
- **Container Instances**: The actual container instances are created based on your application definitions, including the container images, environment variables, and resource requirements.

## What's Next?

This initial release of ACI support in Radius is just the beginning. The vision is to implement a compute platform extensibility model that allows Radius to support additional container runtimes in a more lightweight, flexible, and declarative way in lieu of the current imperative code.

To learn more about or provide feedback on this new compute platform extensibility model, check out the [Compute Platform Extensibility design document](https://github.com/radius-project/design-notes/pull/91) currently in progress.

### Redesigned compute platform extensibility model

With the way ACI integration is currently implemented through imperative code, it is not readily extensible for other platforms. Expansion into each new platform requires intimate knowledge of the Radius codebase in order to make the necessary changes to support the new platform. To address this, we plan to refactor the ACI integration to make use of Radius extensibility features that leverage Radius [Recipes](https://docs.radapp.io/guides/recipes/overview/) to implement the ACI (and other platforms going forward) integration in a more declarative and extensible way.

This new design will enable:
- Architectural separation of Radius core logic from platform provisioning code
- Community-provided extensions to support new compute platforms without Radius code changes
- Consistent platform engineering experience across all resource types

### Support for platform-specific capabilities

As a part of the new extensibility model, we plan to enable support for Radius users to access platform-specific capabilities in their applications. This means that while Radius will continue to provide a consistent application model across different platforms, users will also be able to leverage unique features of each platform when targeting deployments to applicable environments. For example, using a given application definition file, Radius users should be able to deploy to confidential containers when targeting the deployment to an ACI environment.

## Learn more and contribute

We would love for you to join us to help build Radius:

* Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
* Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
* Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
* Review and provide feedback on the [Compute Platform Extensibility design document](https://github.com/radius-project/design-notes/pull/91)
* Let us know what compute platforms you would like to see supported in Radius by commenting on the [Compute Platform Extensibility roadmap item](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=113169343&issue=radius-project%7Croadmap%7C73)