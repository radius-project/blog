---
date: "2024-0-12T08:00:00-08:00"
title: ""
linkTitle: ""
author: ""
type: blog
---
# Radius & Dapr: Building Portable Cloud Apps that Follow Best Practices by Default

# Summary
Enterprise application teams face daunting challenges as they work to continually deliver business value, learn and adopt new cloud technologies, and address an ever expanding matrix of of compliance requirements and security threats. Dapr and Radius make it easier for applications teams to address these competing interests by simplifying the task of building cloud native applications that are portable, scaleable and follow best practices at the source code level (via Dapr) and the deployment level (via Radius). Dapr and Radius are complimentary technologies which are valuable standalone but are more powerful when used together.  Dapr enables developers to easily write application code that is portable across clouds and on-premise and which follows industry best practices for common cloud patterns like pub/sub and secrets management by default. Radius, on the otherhand, makes it easy for applications teams to describe and deploy applications in a consistent way across private and public clouds while enforcing IT defined best practices for things like cost, security and operations.  Radius natively supports Dapr so using them together is seamless. This post summarizes the two technologies, how they compliment each other and provides references to additional resources for getting started with Dapr plus Radius. 

# Who Built Dapr and Radius
The Azure Incubations team within the Office of the Azure CTO, Mark Russinovich. We deliver technologies that make it easier for the industry at large (not just Microsoft customers and Azure customers), to accelerate their journey to cloud.  We deliver technologies that are both open-source and cloud-agnostic.  Examples of our projects (all of which are available via GitHub and the Cloud Native Compute Foundarion (CNCF)) include: KEDA, which enables auto-scaling Kubernetes clusters; Copacetic, which makes it faster and easier to patch containerized code; as well as Dapr and Radius, the focus of this post.

# Why we built Dapr and Radius
The evolution of cloud computing has increased the speed of innovation for many companies, whether they are building two and three-tier applications or complex microservice-based applications. In the process of adopting cloud, enterprise application teams are asked to address a growing set of daunting and often competing demands to:  Ensure application portability so applications can run in private cloud or a preferred hyper-scaler, for flexibility and to avoid vendor lockin; Enforce compliance, security and other requirements and best practices across both applications and infrastructure;   Meet stringet service level agreements including no planned application downtime; Stay current on the latest technologies across cloud vendors to ensure the best ROI; Continually deliver business value, be agile and do more with less.
It is not feasible for every enterprise application team to nail all of these demands so the Azure Incubations team designed Dapr and Radius to help mitigate these challenges.   

# How Dapr and Radius Help
 The combination of Dapr and Radius enables application teams to deliver applications that are portable both at the application runtime code level (via Dapr) and application deployment level (via Radius). The technologies ensure compliance and security requirements are addressed by default. They make it easier to write cloud native applications that scale and follow best practices. Dapr and Radius abstract away the complexity of underlying cloud technologies where possible. They are open-source and are cloud-agnostic from the ground up, to ensure they can be used by any application team regardless of their cloud provider or cloud strategy. Dapr and Radius are valuable when used separately and standalone but are more powerful when used together. And, since Radius natively supports Dapr, using them together is seamless.

## Dapr Summary
Dapr is developer focused. It is a portable, event-driven runtime that makes it easy for developers to build resilient, stateless and stateful applications that run on the cloud and edge and embraces the diversity of languages and developer frameworks. Leveraging the benefits of a sidecar architecture, Dapr helps developers tackle the challenges that come with building microservices and keeps application code platform-agnostic. Dapr provides a set of building blocks that encapsulate best practices for common cloud application patterns like state management, pub/sub messaging, service-to-service, invocation, and more.
#### include image of the dapr stack and building blocks from dapr.io
For more information about Dapr, please see https://docs.dapr.io/.

## Radius Summary
Radius is focused equally on developers and operators, helping these roles work better together. Whereas Dapr is focused on application code, Radius is focused on making it easier to define, deploy and manage applications in a cloud-agnostic way. It is a cloud-native application platform that enables developers and platform engineers who support them to collaborate on delivering and managing cloud-native applications that follow corporate best practices for cost, operations, and security by default. Radius supports deploying applications across private cloud, Microsoft Azure, and Amazon Web Services (with more cloud providers to come).  Whereas Dapr makes your applicatoin runtime code portable across on-premise and clouds, Radius makes your application deployment portable across on-premise and public clouds.  

#### Include image of radius tech stack... and value prop

For more details on Radius, please see https://docs.radapp.io/. If you have not yet experimented with Radius, you can get started at https://docs.radapp.io/getting-started/

# How to use Dapr Building Blocks in Radius applications
Radius includes native support for three of the Dapr building blocks illustrated above: Publish and Subscribe, Secrets and State Management. Application developers add Dapr building blocks as Radius application resources to ensure their application implementation of pub/sub messaging, secret management and state management are portable across on-premise and public clouds. See below for Tutorials and How-To Guides that walk you through adding Dapr building blocks to your Radius application.

## Tutorial
This Tutorial gives you a hands on end-end experience of adding a Dapr state store to your Radius application then deploying and testing that application - https://docs.radapp.io/tutorials/dapr/. The tutorial helps make all these concepts much more concrete.

## How-To Guides
These How-To Guides walk you through targeted, discrete steps you will complete whenever using Dapr with Radius. 
Overview - https://docs.radapp.io/guides/author-apps/dapr/overview/
Add a Dapr sidecar to a container in your Radius application - https://docs.radapp.io/guides/author-apps/dapr/how-to-dapr-sidecar/
Add a Dapr Building Block to your Radius application - https://docs.radapp.io/guides/author-apps/dapr/overview/ 

# Learn more and Contribute 
The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).
