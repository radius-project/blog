---
date: "2024-11-25T08:00:00-08:00"
title: "How Workload Identity Federation for Cloud Providers Work in Radius"
linkTitle: "Cloud identity federation in Radius"
author: "[Nithya Subramanian](https://www.github.com/nithyatsu)"
type: blog
---

## Introduction 

Radius enables infrastructure operators and application developers to define, deploy, and collaborate on cloud-native applications across multiple cloud providers and on-premises environments. To deploy cloud resources, Radius needs an identity to authenticate, access, and communicate with cloud providers. These identities are stored as Radius credentials. Since its initial release, Radius has supported Azure service principal identity and AWS IAM user as Radius credentials to deploy Azure and AWS resources. While these approaches are straightforward, they require users to secure credentials by consistently following security best practices like periodic credential rotation and update. As of the v0.37 release, Radius supports Workload/Federated Identity to deploy cloud resources in AWS and Azure. Workload identity mitigates the challenge of manually managing credentials and eliminates the risk of exposing secrets or having certificates expire.
 
This blog post will describe how federated identity is implemented within Radius. We will explore the mechanisms and configurations involved in using AWS IAM Roles for Service Accounts (IRSA) and Azure Workload Identities to securely manage and access cloud resources, and understand how Radius leverages them. If you are only interested in how to setup federated identity for your Radius installation, see the documentation for using Radius with [AWS IRSA](https://docs.radapp.io/guides/operations/providers/aws-provider/howto-aws-provider-irsa/) and [Azure Workload Identity](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-wi/).

## How Radius utilizes AWS IAM Roles for Service Accounts (IRSA) 

### Radius and AWS IRSA

Radius enables management of AWS resources as part of your application. In order to achieve this, Radius stores two essential pieces of information:

1. Cloud Provider Scope: This is the AWS account ID and region to which the AWS resources are deployed. Cloud Provider Scope is stored as part of Radius environment.
2. AWS Credential: This is the ARN for the AWS IAM role Radius will use. The role defines what actions are allowed within the AWS account. The IAM role is assumed by Radius to deploy the AWS resources.
   
In the Kubernetes world, service accounts are used to provide an identity for applications running in pods. Kubernetes provides a service-account token in the form of a JWT (JSON Web Token). This token contains claims about the cluster, namespace and service-account. There are two Radius services that communicate with AWS to deploy the resources: the Universal Control Plane (UCP) and the Applications Resource Provider (Applications RP). When Radius is installed with IRSA enabled, the service-account token is mounted to the UCP and Applications RP pods as a projected volume. 

{{< image src="images/radius-irsa.png" alt="using IRSA to deploy an AWS resource" width="800">}}

The above image shows how Radius UCP leverages AWS IRSA to deploy and manage AWS resources. The flow is identical for Applications RP. Below are the key points in the flow:
1. When the UCP or Applications RP service needs to communicate with AWS, it first sends an AssumeRole request to AWS Secure Token Service (STS). AWS STS is a web service that enables you to request temporary, limited-privilege credentials for AWS IAM users. The AssumeRole operation enables Radius to assume an IAM role and receive temporary, limited-privilege credentials
2. a. STS uses the claim from this JWT to verify that it is indeed the radius-system:ucp service account that is making the request and verifies this by communicating with the cluster's configured OIDC provider.
   b. Once the identity of service is confirmed, STS checks the trust policy of the IAM role to make sure that the IAM role trusts the service account.
3.  At this point, the service account associated with the UCP and Applications RP pod is both authenticated (2a) and authorized (2b). STS therefore issues a temporary credential.
4.  UCP and Applications RP uses this temporary credential to make API requests to manage the AWS resources.
   
### Pod spec when IRSA is enabled

Below is the UCP pod spec when Radius is installed with IRSA enabled. Note that `aws-iam-token` is added as a projected volume and mounted to pod.

```
% kubectl describe pod -n radius-system ucp        
Name:             ucp-cf657446-h6f7r
Namespace:        radius-system
Priority:         0
Service Account:  ucp
:
Containers:
  ucp:
    Container ID:   containerd://e16d41dde8248a623f1a46dea6632c5eaa72906f9f3ffc16c0d19cedd5f21a21
    :
    Mounts:
      /etc/config from config-volume (rw)
      /var/run/secrets/eks.amazonaws.com/serviceaccount from aws-iam-token (rw) 
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-jhmdl (ro)
      /var/tls/cert from cert (ro)
Conditions:
  :
Volumes:
  :
  aws-iam-token:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  86400
  :
```

See the how-to guide [setup Radius with AWS IRSA](https://docs.radapp.io/guides/operations/providers/aws-provider/howto-aws-provider-irsa/) for information on configuring the trust for the IAM Roles in AWS.

### Challenges and solutions

AWS provides a webhook which can configure the necessary settings for IRSA on pods that use the relevant service accounts. This is the [Amazon EKS Pod Identity Webhook](https://github.com/aws/amazon-eks-pod-identity-webhook#amazon-eks-pod-identity-webhook).
We could have used this webhook to configure Radius for IRSA. The webhook adds two additional configurations to the relevant pods on creation:
* Environment variables which the supporting AWS SDK read from automatically to detect IRSA role:
```
Environment:
  :
  AWS_ROLE_ARN:                 arn:aws:iam::817312594854:role/my-role
  AWS_WEB_IDENTITY_TOKEN_FILE:  /var/run/secrets/eks.amazonaws.com/serviceaccount/token
  :
```
* Mount the service-account token as projected volume:
```
Volumes:
  aws-iam-token:
    Type:                    Projected (a volume that contains injected data from multiple sources)
  TokenExpirationSeconds:  86400
```

We opted against this solution for the following reasons:

* The approach requires the role ARN to be injected at install time, which Radius treats as an AWS credential. This would necessitate a restart of Radius for credential registration, which is not ideal.
* Radius is designed to evolve and support multi-tenancy. The current webhook does not support handling multiple role ARNs, which is a limitation for our multi-tenant architecture.

Radius implements configurations in a way that avoids these drawbacks, ensuring seamless credential management and multi-tenancy support.

## How Radius utilizes Azure Workload Identity

### Radius and Azure Workload Identity

Radius allows management of Azure resources as part of your application. In order to achieve this, Radius stores two essential pieces of information:

1. Cloud Provider Scope: This is the subscription ID and resource group to which the Azure resources are deployed. Cloud Provider Scope is stored as part of Radius Environment. 
2. Azure Credential: This is the client id and tenant id of the Azure AD application that Radius uses to deploy the Azure resources.

There are three Radius services that communicates with Azure to achieve this: UCP, Applications RP and Deployment Engine.

{{< image src="images/radius-az-wi.png" alt="using Az Workload Identity to deploy an Az resource" width="1200">}}

The above image shows how Radius UCP leverages Azure Workload Identity to deploy and manage Azure resources. The flow is identical for Applications RP and Deployment Engine.

Below are the key points in the flow. Notice the flow is very similar to AWS IRSA. In this case, the pod service account requests a JWT from Microsoft Entra ID via a mutating admission webhook, which mounts the service account token to the pod as a volume.
   
1. When UCP, Applications RP or  Deployment Engine has to communicate with Azure for managing a resource, it first sends request to Entra ID with its Application ID and service account token (JWT). 
   
At this point, the flow completes similar to step 2a, 2b, 3, and 4 in the AWS example above.

### Pod spec when Azure Workload Identity is enabled

Below is pod spec for the UCP service when Radius is installed with Azure Workload Identity enabled. Radius annotates the pods with ```azure.workload.identity/use=true``` label.

```
nithya@MacBook-Pro ~ % kubectl describe pod -n radius-system ucp        
Name:             ucp-cf657446-h6f7r
Namespace:        radius-system
Priority:         0
Service Account:  ucp
Labels:           :
                  azure.workload.identity/use=true
                  :
Containers:
  ucp:
    Container ID:   containerd://e16d41dde8248a623f1a46dea6632c5eaa72906f9f3ffc16c0d19cedd5f21a21
    :
    Mounts:
      /etc/config from config-volume (rw)
      /var/run/secrets/azure/tokens from azure-identity-token (ro) 
      :
    Volumes:
      azure-identity-token:
      Type:                    Projected (a volume that contains injected data from multiple sources)
      TokenExpirationSeconds:  3600
      :
```

Check out the guide on how to [Setup Az Workload Identity](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-wi/#setup-the-azure-workload-identity-for-radius) in Radius. This contains information on configuring the trust for for the workloads in Azure.

## Comparison between providers

AWS and Azure provide very similar solutions for adopting workload or service identities. They also provide mutating admission webhooks that allow configuring workloads to use workload identity easily. However, while we adopted Azure's webhook for enabling Azure Workload Identity in Radius, it was not easy to take a similar approach with AWS. This was because Azure's webhook utilized two annotations as part of workload identity configuration. We could choose to utilize ```azure.workload.identity/use: "true"``` to mount the service-token which is the key requirement for enabling workload identity.

```
azure.workload.identity/use: "true"
azure.workload.identity/client-id: "<your-client-id>"
```

However, AWS's webhook utilizes just one annotation, coupling a specific IAM role ARN with the intent to enable
IRSA. While this is simpler compared to Azure's multiple configuration settings, it is not suitable for Radius due to the need to support multi-tenancy.
```
eks.amazonaws.com/role-arn: arn:aws:iam::<account-number>:role/<role-name> 
```
We solved this problem by mounting the service account token as part of pod spec when user chooses to enable IRSA for Radius, instead of utilizing AWS webhook.  

## Learn more and contribute 

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community. We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://docs.radapp.io/guides/operations/providers/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord)

Please refer to  [Radius Workload Identity Setup Guide](https://docs.radapp.io/guides/operations/providers/overview/) for setting up Radius with Workload Identities.

## References

https://azure.github.io/azure-workload-identity/docs/introduction.html

https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview?tabs=dotnet

https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

https://medium.com/@ankit.wal/the-how-of-iam-roles-for-service-accounts-irsa-on-aws-eks-3d76badb8942