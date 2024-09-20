---
date: "2024-09-T08:00:00-08:00"
title: "Workload Identity Support in Radius"
linkTitle: "Managing cloud provider credentials in Radius"
author: "[]()"
type: blog
---

## What is Workload Identity 

A software workload such as a container-based application, service or script needs an identity to authenticate, access, and communicate with services that are distributed across different platforms and/or cloud providers. Workload identity is a security concept that allows applications (workloads) running on cloud platforms to securely access and interact with cloud resources using managed identities, rather than relying on static credentials. Some benefits of using workload identities are:

* Reduced Credential Management: No need to manage and rotate static credentials manually.
* Enhanced Security: Minimizes the risk of credential leakage and unauthorized access.
* Simplified Access Control: Permissions are managed centrally through cloud provider IAM policies.

## Radius and Cloud Providers

Radius makes it easy for developers and operators to define, deploy, and collaborate on cloud-native applications across public clouds and private infrastructure. To deploy cloud resources, Radius needs to be set up with cloud provider credentials. From the get-go, Radius has supported static credentials to communicate with both Azure and AWS. You can store credentials like Azure client-secret and AWS access-key in Radius Credential. Details about the scope of resource deployment, such as subscription-key and resource-group for Azure, and account-id and region for AWS, can be stored as Radius provider in a Radius Environment. Check out [Radius Cloud Providers](https://docs.radapp.io/guides/operations/providers/overview/)  for more info. While this approach is straightforward, it relies on users to secure the credentials by following good security practices like credential rotation.

Now, we support Workload Identity to leverage the security benefits mentioned in Workload Identity.

### How Radius works with Azure Workload Identity

- component diagram / sequence diagram higlighting the flow between
one of the radius pods , OIDC provider, Azure

- explanation of the diagram

- Adapting to Radius (explain decisions to not use pod identitity plugins)


### How Radius works with AWS IRSA

{{< image src="images/radius-irsa.png" alt="using IRSA to deploy an AWS resource" width="750">}}

## How to configure Radius with Workload Identities

Could we point them to https://docs.radapp.io/guides/operations/providers/aws-provider/howto-aws-provider-irsa/ etc ?

## Comparison between providers

- common positives 
  - Good documentation
  - Providers make WI configuration easy assuming the audience to be a simple workload that deploys to the provider. 
- shortcomings among the providers. 
  - Much of the documented solution poses challenges for  multicloud and  multi tenancy scenarios .  
  - We can/ did stick to the requisites of the solution and evolve credential management in a way that suits to our application

## Contributors 

### Learn More and Contribute 
The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community. We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://docs.radapp.io/guides/operations/providers/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord)
