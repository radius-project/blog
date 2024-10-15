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

Radius makes it easy for developers and operators to define, deploy, and collaborate on cloud-native applications across public clouds. To deploy cloud resources, Radius needs to be set up with cloud provider credentials. From the get-go, Radius has supported static credentials to communicate with both Azure and AWS. You can store credentials like Azure client-secret and AWS access-key in Radius Credential. Details about the scope of resource deployment, such as subscription-key and resource-group for Azure, and account-id and region for AWS, can be stored as Radius provider in a Radius Environment. Check out [Radius Cloud Providers](https://docs.radapp.io/guides/operations/providers/overview/) for more info. While this approach is straightforward, it relies on users to secure the credentials by following good security practices like credential rotation.

Now, we support Workload Identity to leverage the security benefits mentioned in [What is Workload Identity](#what-is-workload-identity)



### How Radius leverages AWS IRSA 

#### Key Concepts

##### AWS IAM roles 

An AWS IAM (Identity and Access Management) role is a set of permissions that define what actions are allowed and denied for an AWS service or resource. 
The roles are can be assumed by entities such as AWS services, or Kubernetes service-accounts.

##### STS AssumeRole 

The sts:AssumeRole operation is a key feature of AWS Security Token Service (STS) that allows obtaintaining temporary security credentials for 
managing AWS resources. In a nutshell, this is how it works:

1. Configure Trust Policy: The IAM role to be assumed must have a trust policy entity that specifies which entities (users, groups, services) are allowed to assume this role.
2. AssumeRoleWithWebIdentity API Call: An entity makes an AssumeRoleWithWebIdentity API call to STS, specifying the ARN of the role to assume.

#### AWS IAM Role for Service Accounts

AWS IRSA (IAM Role for Service Accounts) is the AWS feature that allows kubernetes service-account to assume an AWS Role. 
When configured for IRSA, service-account token that serves as ID for cluster: namespace: service-account is mounted as projected volume in the pod. 

The pod sends this token to STS to receive temporary short-lived credentials. These credentials can be used to manage AWS resources. 

#### Radius with AWS IRSA setup

{{< image src="images/radius-irsa.png" alt="using IRSA to deploy an AWS resource" width="750">}}

Radius allows management of AWS resources as part of your application. There are two 
Radius services that communicates with AWS to achieve this:

UCP (Universal Control Plane) uses AWS cloud control APIs to create and manage AWS resources. 

Applications RP supports terraform recipes for managing AWS resources. Terraform provider (subcomponent of Applications RP) communicates directly with AWS.

The above image shows how Radius UCP leverages AWS IRSA to deploy and mange AWS resources. The flow is identical for Applications RP. In a nutshell, 

1. Kubernetes provides a service-account token in the form of a JWT (JSON Web Token). This token contains claims about the cluster, namespace and service-account. This token should be mounted to the pod as a poject volume to enable workload identity( AWS IRSA). 
2. 

#### More details

Add 
- relevant snippet of pod spec and explain details
- relevent trust policy and explain details

Refer https://docs.radapp.io/guides/operations/providers/aws-provider/howto-aws-provider-irsa/ for how to guide.

#### Challenges and solutions

Add details on challenge with annotating service-account as outlined in AWS document

## Comparison between providers

common positives 
  - Good documentation
  - Providers make WI configuration easy assuming the audience to be a simple workload that deploys to the provider. 
shortcomings among the providers. 
  - Much of the documented solution poses challenges for  multicloud and  multi tenancy scenarios. explain the disadvantage of provided webhook for Radius.

## Contributors 

### Learn More and Contribute 

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community. We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://docs.radapp.io/guides/operations/providers/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord)
