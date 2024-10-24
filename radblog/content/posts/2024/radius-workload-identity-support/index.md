---
date: "2024-10-30T08:00:00-08:00"
title: "How workload identity federation for cloud providers work in Radius"
linkTitle: "How workload identity federation for cloud providers work in Radius"
author: "[Nithya Subramanian](https://www.github.com/nithyatsu)"
type: blog
---

## Introduction 

Radius enables infrastructure operators and application developers to define, deploy, and collaborate on cloud-native applications across public clouds. To deploy cloud resources, Radius needs an identity to authenticate, access, and communicate with cloud providers. These identities are stored as Radius credentials. From the get-go, Radius supports Azure service principal identity and AWS IAM User as Radius credentials to deploy Azure and AWS resources. 
 
While this approach is straightforward, it relies on users to secure the credentials by following good security practices like periodic credential rotation and update. With the 0.37 release, Radius supports Workload/Federated Identity to deploy cloud resources in AWS and Azure. Workload identity helps avoid the maintenance challenge of manually managing the credentials and eliminates the risk of exposing secrets or having certificates expire.
 
This blog will delve into the details on how Radius enabled workload (federated) identity to deploy resources in AWS and Azure. We will explore the mechanisms and configurations involved in using AWS IAM Roles for Service Accounts (IRSA) and Azure Workload Identities to securely manage and access cloud resources, and understand how Radius leverages them.

## How Radius Utilizes AWS IAM Roles for Service Accounts (IRSA) 

### Radius and AWS IRSA

Radius allows management of AWS resources as part of your application. In order to achieve this, Radius stores 2 essential pieces of information -

1. Cloud Provider Scope: This is the account id and region to which the AWS resources are deployed to. Cloud Provider Scope is stored as part of Radius environment. 
2. AWS Credential:  This is the AWS IAM role identity that defines what actions are allowed and denied for an entity. The roles can be assumed by entities such as AWS services or Kubernetes service-accounts. The Role ARN of the IAM Role would be assumed by Radius to deploy the AWS resources which is stored as Radius AWS Credential.

There are two Radius services that communicate with AWS to deploy the resources - UCP and Applications RP.

{{< image src="images/radius-irsa.png" alt="using IRSA to deploy an AWS resource" width="1200">}}

The above image shows how Radius UCP leverages AWS IRSA to deploy and manage AWS resources. The flow is identical for Applications RP. 
Below are the key points in the flow:

1. In Kubernetes world, service accounts are used to provide an identity for applications running in pods. Kubernetes provides a service-account token in the form of a JWT (JSON Web Token). This token contains claims about the cluster, namespace and service-account. When Radius is installed with IRSA enabled, this token is mounted to the pod as a project volume.
   
2. When UCP and Applications RP need to communicate with AWS for deploying / managing a resource, it first sends an Assume Role request to AWS STS. AWS Security Token Service (STS) is a web service that enables you to request temporary, limited-privilege credentials for AWS Identity and Access Management (IAM) users. The AssumeRole operation enables an entity to assume an IAM role and receive temporary security credentials associated with it.   
   
3. STS uses the claim from this JWT to verify that it is indeed the `k8s_cluster:radius-system:ucp` that is making the request and verifies this by communicating with the cluster's configured OIDC provider. 
   
4. Once the identity of service is confirmed, STS checks the trust policy of the IAM role available in the request to make sure IAM role trusts the service-account to assume it.
   
5. At this point, the service account associated with the workload (UCP or Applications RP) making the request is both authenticated and authorized. STS therefore issues a temporary credential back.
   
6. UCP or Applications RP uses this temporary credentials to make suitable API requests to manage the AWS resources. 

### Pod Spec when IRSA is enabled

Below is the pod spec definition when Radius is installed with AWS IRSA enabled. Note that `aws-iam-token` is added as a projected volume and mounted to UCP pod.

```
nithya@MacBook-Pro ~ % kubectl describe pod -n radius-system ucp        
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

Checkout the guide on how to [setup Radius with AWS IRSA](https://docs.radapp.io/guides/operations/providers/aws-provider/howto-aws-provider-irsa/). This contains information on configuring the trust for the IAM Roles in AWS.

### Challenges and Solutions


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

## How Radius Utilizes Azure Workload Identity

### Radius and Azure Workload Identity

Radius allows management of Azure resources as part of your application. In order to achieve this, Radius stores 2 essential pieces of information -

1. Cloud Provider Scope: This is the subscription id and resource group to which the Azure resources are deployed. Cloud Provider Scope is stored as part of Radius Environment. 
2. Azure Credential: This is the client id and tenant id of the Azure AD application that Radius uses to deploy the Azure resources.

There are three Radius services that communicates with AWS to achieve this: UCP, Applications RP and Deployment Engine.

{{< image src="images/radius-az-wi.png" alt="using Az Workload Identity to deploy an Az resource" width="1200">}}

The above image shows how Radius UCP leverages Azure Workload Identity to deploy and manage Azure resources. The flow is identical for Applications RP and Deployment Engine.

Below are the key points in the flow. Notice the flow is very similar to AWS IRSA:

1. In Kubernetes world, service accounts are used to provide an identity for applications running in pods. Kubernetes provides a service-account token in the form of a JWT (JSON Web Token). This token contains claims about the cluster, namespace and service-account. When Radius is installed with Azure Workload Identity enabled in a cluster which has AzWI mutating admission webhook installed,  the webhook  mounts the service-account token to the pod as a project volume.
   
2. When UCP, Applications RP or  Deployment Engine has to communicate with Azure for managing a resource, it first sends request to Entra ID with its Application ID and service account token (JWT). 
Microsoft Entra ID is a suite of identity and access management solutions that includes Azure AD along with other services designed to secure access to resources and manage identities across various environments. Application ID is an application that is registered in Azure Active Directory (Azure AD) and is used to authenticate with Azure resources.
   
3. Entra uses the claim from this JWT to verify that it is indeed `k8s_cluster:radius-system:ucp` that is making the request. It verifies by communicating with the cluster's configured OIDC provider. 
   
4. Once the identity of service is confirmed, Entra checks the trust policy of the App registeration to make sure the service account is trusted to perform the operation.
   
5. At this point, the service account associated with the workload making the request is both authenticated and authorized. Entra therefore issues a temporary credential back.
   
6. UCP, Applications RP or  Deployment Engine uses this temporary credentials to make suitable API requests to manage the Azure resources. 

### Pod spec when Azure Workload Identity is enabled

Below is the relevant information from pod spec when Radius is installed with Workload Identity enabled. Radius annotates the pods with  ```azure.workload.identity/use=true``` label.
service-account token is injected by the AzWI mutating admission webhook because of the label.

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

Checkout the guide on how to [Radius Setup Az Workload Identity](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-wi/#setup-the-azure-workload-identity-for-radius). This contains information on configuring the trust for for the workloads in Azure.

## Comparison between providers

AWS and Azure provide very similar solutions for adopting workload identities. They also provide mutating webhooks that allow configuring workloads to use Workload Identity easily. However, while we adopted Azure's mutating webhook for enabling Azure Workload Identity in Radius, it was not easy to take a similar approach with AWS. This was because Azure's webhook utilized two annotations as part of workload identity configuration. We could choose to utilize ```azure.workload.identity/use: "true"``` to mount the service-token which is the key requirement for enabling workload identity.

```
azure.workload.identity/use: "true"
azure.workload.identity/client-id: "<your-client-id>"
```

However, AWS's webhook utilizes just one annotation, coupling a specific IAM role ARN with the intent to enable
IRSA. While this is simpler compared to Azure's multiple config knobs, it is not suitable for Radius due to the need to support multi-tenancy.

```
eks.amazonaws.com/role-arn: arn:aws:iam::<account-number>:role/<role-name> 
```

## Learn More and Contribute 

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

