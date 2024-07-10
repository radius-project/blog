---
date: "2024-07-11T08:00:00-08:00"
title: "Building Cloud Agnostic Applications with Radius and Dapr"
linkTitle: "Radius plus Dapr"
author: "[Jonathan Smith](https://www.github.com/jonvsm)"
type: blog
---

# Multi-Cloud Usage Models

Most enterprises today use public clouds from multiple vendors like Amazon AWS and Microsoft Azure, or they plan to do so in the near future. Reasons vary from company to company and industry to industry. Financial services providers face regulatory constraints that may only be addressed via multiple cloud providers in different geographic regions. Many enterprises have varied teams, each with specific skills, preferences and technical requirements that, in aggregate, require multiple clouds. Other enterprises simply hope to avoid lock-in to a particular vendor. While the specific scenarios and requirements vary, there is growing trend toward using clouds from multiple vendors. In discussing Radius with scores of enterprises, we found three primary models among enterprises using clouds from more than one vendor:

1. Multi-cloud enterprise: these enterprises deploy some applications to one cloud provider and other applications to another cloud provider.
2. Cloud-agnostic applications: these enterprises deploy the same application to different cloud providers. 
3. Multi-cloud applications: these enterprises have a single application that is distributed across multiple clouds.

The third case, a single application that is running across multiple clouds, was incredibly rare. Enterprises that had experimented with multi-cloud applications cited almost insurmountable challenges with operations, security, and performance management. While Radius can help with this third type of application, supporting these kinds of applications was not a design goal for Radius.  Radius is designed to meet the first two types of multi-cloud use. And, if a given application is designed to be fully cloud agnostic it meets the requirements of both case one and two above. This post focuses on how to use Radius together with Dapr to deliver fully cloud-agnostic applications.

# How Radius and Dapr Help


Delivering cloud-agnostic applications is challenging and requires solving two basic problems: 1) Your runtime application code itself must be cloud-agnostic, i.e. Your application can’t call APIs specific to a given proprietary cloud. Dapr, the Distributed Application Runtime was designed to solve this problem; and 2) Your application and infrastructure deployment must be cloud agnostic, i.e. your deployment can’t assume infrastructure and configuration that is specific to a given cloud.  Radius was designed to solve this problem. Because Radius natively supports Dapr, you can use the two together to build truly cloud-agnostic applications. This post will show you how simple it is to use Dapr and Radius together. (A later post will focus on using Radius with open-source technologies like Redis, the combination of which also enables fully cloud agnostic applications.)


Dapr's value is in providing cloud-agnostic API building blocks that also reduce the complexity of building distributed, cloud-native applications. These API building blocks abstract away services that provide state management, secrets management, or publish and subscribe systems. Developers can code an application using the Dapr SDK and platform engineering teams can use Radius to provide the underlying infrastructure for these Dapr based applications. For example, a Dapr application that persists state could use Azure Blob Storage or Amazon DynamoDB as the underlying state store depending on which cloud provider was used to host the application. Here is a summary of the Dapr stack.


{{< image src="images/DaprOverview.png" alt="Dapr Overview Diagram" width="600" >}}

The rest of this article assumes you have used Dapr and you are familiar with the basics of Radius, by at least completing the [Radius Getting Started Guide](https://docs.radapp.io/getting-started). If you want to brush up on Radius or Dapr please check out the [Radius documentation](https://radapp.io/) and [Dapr Documentation](https://dapr.io/).

# How it Works

Both Dapr and Radius are valuable standalone solutions but are ‘better together’ as described above. Below we will look at the experience of a developer already using Dapr who wants to use the Radius Dapr integration to make a truly cloud agnostic application. Assume you are a developer who has adopted Dapr in hopes of making your application cloud agnostic. You have built and containerized your application which uses the Dapr State Store and have it up and running locally on your dev box. Now you want to test deploying it to the cloud on both AWS and Azure. Unfortunately, you still have a significant amount of challenging work ahead of you, to ramp on the details of both clouds and set up unique infrastructure and configuration to enable deployment to each of them. In other words, your application runtime is cloud-agnostic via Dapr, but the infrastructure on which it depends is not.

This is where the close integration between Radius and Dapr comes in handy. Radius supports the three most popular Dapr resource types - State Stores, Secret Stores, Pub/Sub Brokers.  So, you can easily define your application as-is in Radius and reference the Dapr State Store building block. Once you have described your application in Radius you can deploy it across your private cloud and your public cloud of choice without further modification to the Radius application definition and without learning all the intricacies of how both public clouds work.

It only takes three steps to describe your Dapr application in Radius: 1) add a  Dapr sidecar; 2) declare the building block your app uses; 3) declare a connection from your application container to the building block. Here’s how it works. We’ll start with this simple Radius application, which includes a container wherein you will enable Dapr. 

```
import radius as radius

@description('The ID of your Radius Application. Automatically injected by the rad CLI.')
param application string

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
    }
  }
}
```

 1)To add the sidecar to this container, you add an extension of kind ‘daprSidecar.’  This enables Dapr within this container.
 
 ```
 resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'demo'
        appPort: 3000
      }
    ]
  }
}
 ```

 2)With Dapr enabled in your container, you declare a reference to the State Store building block your app uses.
 ```
 resource stateStore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: application
  }
}
 ```

3)Lastly, you’ll declare a connection between the container where Dapr is enabled and the State Store building block.

```
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'demo'
        appPort: 3000
      }
    ]
    connections: {
      statestore: {
        source: stateStore.id
      }
    }
  }
}
```

At this point, you can use the command *rad run* or *rad deploy* to deploy the application to AWS and to Azure. As part of the deployment, Radius will automatically run a Radius [Recipe](https://docs.radapp.io/guides/recipes/overview/) which will create a lightweight Redis container (the default backing store for Dapr State Store) plus a Dapr component configuration. So, you don’t even have to setup and configure Dapr or the State Store on either cloud. Radius takes care of that for you. 

# Alternative Approaches

Hopefully, the information and examples above make clear the power and simplicity of using Radius and Dapr for building cloud agnostic applications. To further reinforce that point, let’s think through the experience using other technologies for enabling cloud agnostic applications. For example, many developers would package and deploy a Dapr application to Kubernetes using a Helm chart and use Terraform to deploy the application's dependent cloud infrastructure. In many cases, deployment of even simple applications may also require Bash scripts for command execution.

Using Helm charts and Terraform involves several manual steps that Radius automates. With Helm, you would typically first create multiple Helm charts to deploy the application container with a Dapr sidecar, Dapr state store, and securely managed cloud provider credentials. Then you would use Terraform to provision and manage infrastructure resources on AWS or Azure, requiring managing yet more configuration and tooling. Next, to automate execution of commands across Helm, Dapr, and Terraform, you would then create Bash scripts, adding more complexity with additional files to manage. In contrast, Radius simplifies this entire process as a part of an application deployment using ‘rad deploy’ as demonstrated above.

# Learn More and Contribute 

There are several resources for learning more about using Dapr and Radius together.  

## Videos

These Open at Microsoft videos have great introductory content 

[Introduction to Dapr](https://learn.microsoft.com/en-us/shows/open-at-microsoft/introduction-to-dapr)

[Introduction to Radius](https://www.youtube.com/watch?v=mT_NWFnYn0A)

[Create Truly Portable Applications with Dapr and Radius](https://learn.microsoft.com/en-us/shows/open-at-microsoft/create-truly-portable-applications-with-dapr-and-radius)


## Tutorials and How-To Guides

This [tutorial](https://docs.radapp.io/tutorials/dapr/) provides a hands on end-end experience of adding a Dapr state store to a Radius application then deploying and testing that application.

These How-To Guides walk you through targeted, common steps you will complete whenever using Dapr with Radius. 
[Dapr Overview](https://docs.radapp.io/guides/author-apps/dapr/overview/) 

[Add a Dapr sidecar to a container in your Radius application](https://docs.radapp.io/guides/author-apps/dapr/how-to-dapr-sidecar/).

[Add a Dapr Building Block to your Radius application](https://docs.radapp.io/guides/author-apps/dapr/overview/) 

## Other Community Resources

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.
We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord)
