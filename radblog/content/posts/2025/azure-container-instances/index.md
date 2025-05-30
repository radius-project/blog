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

{{< image src="images/azure-portal-env.png" alt="screenshot of the Azure portal showing the ACI environment created by Radius" width=800 >}}

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

{{< image src="images/azure-portal-env.png" alt="screenshot of the Azure portal showing the ACI environment created by Radius" width=800 >}}

The entire process leverages Radius's application-centric approach, allowing you to focus on defining what your application needs rather than the underlying infrastructure details specific to ACI.

## Implementation Details

This integration leverages the Azure Container Instances API to provision and manage containers directly from Radius. The implementation maintains Radius's application-centric model while transparently handling the details of ACI resource creation and management.

At Ignite 2024, the ACI Ngroups functionality was announced, which provides a single Ngroups API call to create and maintain N number of container instances using a common template. 
This type of orchestration capability made it possible to build integration necessary to enable deployment of application containers and Ngroups resources to ACI using Radius.
The ACI platform itself also offers advanced capabilities, such as confidential containers, spot instances, rolling upgrades, auto-scaling, and more.
Deploying with Radius helps you create the required underlying infrastructure to deploy and host your application, for example the container instances themselves, container group profiles, Ngroups, and network infrastructure, e.g. application gateway, virtual network, load balancer.
Coming soon is the functionality to punch-through the Radius abstraction to leverage platform-specific capabilities, for example, deploy applications to confidential containers when the deployment target is ACI.
Stay tuned for the announcements of the availability of these Radius and ACI features!

## What's Next?

This initial release provides the foundation for ACI support within Radius. We're continuing to enhance this integration with additional features like:

- Support for container groups with multiple containers
- Additional volume types and networking options
- Improved diagnostics and monitoring

We welcome your feedback on this new feature and encourage you to try deploying your Radius applications to Azure Container Instances today!

## Learn more and contribute

All feedback and contributions are welcome! The community is encouraged to engage with the Radius project in the following ways: 

- Provide feedback to influence roadmap decisions by commenting on and upvoting [existing items](https://aka.ms/radius-roadmap)
- Submit new [feature requests](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E) to propose new functionality or other [issue reports](https://github.com/radius-project/radius/issues/new/choose)
- Review in-progress [designs](https://github.com/radius-project/design-notes/pulls) and [code](https://github.com/radius-project/radius/pulls)
- Contribute directly to fix [open issues](https://github.com/radius-project/radius/issues) and [documentation](https://github.com/radius-project/docs/issues)
- Engage with the Radius community via the [monthly community calls](https://github.com/radius-project/community?tab=readme-ov-file#community-meetings) and [Discord](https://aka.ms/radius/discord)