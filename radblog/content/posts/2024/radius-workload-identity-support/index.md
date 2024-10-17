---
date: "2024-09-T08:00:00-08:00"
title: "Workload Identity Support in Radius"
linkTitle: "Managing cloud provider credentials in Radius"
author: "[]()"
type: blog
---

## What is Workload Identity 

A workload refers to any containerized application, service, or script that runs on a cloud platform. Much like users need usernames and passwords to access cloud resources, a software workload needs an identity to authenticate and access resources on cloud. 
This identity is known as workload identity. It allows workloads to interact with cloud resources using managed identities, rather than relying on static credentials. Some benefits of using workload identities are:

* Reduced Credential Management: No need to manage and rotate static credentials manually.
* Enhanced Security: Minimizes the risk of credential leakage and unauthorized access.
* Simplified Access Control: Permissions are managed centrally through cloud provider IAM (Identity Access and Management) policies.

## Radius and Cloud Providers

Radius makes it easy for developers and operators to define, deploy, and collaborate on cloud-native applications across public clouds. To deploy cloud resources, Radius should be set up with cloud provider credentials. From the get-go, Radius has supported static credentials to communicate with both Azure and AWS. You can store credentials like Azure client-secret and AWS access-key in Radius Credential. Details about the scope of resource deployment, such as subscription-key and resource-group for Azure, and account-id and region for AWS, can be stored as Radius Provider in a Radius Environment. Check out [Radius Cloud Providers](https://docs.radapp.io/guides/operations/providers/overview/) for more information on these concepts. While this approach is straightforward, it relies on users to secure the credentials by following good security practices like credential rotation.

Now, Radius supports Workload Identity to leverage the security benefits mentioned in [What is Workload Identity](#what-is-workload-identity)

## How Radius Utilizes AWS IAM Roles for Service Accounts (IRSA) 

### Key Concepts

<u>AWS IAM role </u>

An AWS IAM role is a set of permissions that define what actions are allowed and denied for an entity. 
The roles are can be assumed by entities such as AWS services or Kubernetes service-accounts.

<u>AWS STS </u>

AWS Security Token Service (STS) is a web service that enables you to request temporary, limited-privilege credentials for AWS Identity and Access Management (IAM) users.

<u> AWS STS AssumeRole </u>

The AssumeRole operation lets you assume an IAM role and receive temporary security credentials associated with it. 
STS provides the temperory credentials to the requesting entity after authenticating and authorizing it. More details in [Radius with AWS IRSA setup](#radius-with-aws-irsa-setup).

<u> AWS IAM Role for Service Accounts </u>

AWS IRSA (IAM Role for Service Accounts) is the AWS feature that allows kubernetes service-account to assume an AWS Role. 
When configured for IRSA, service-account token that serves as ID for cluster: namespace: service-account is mounted as projected volume in the pod. This token is sent to STS to receive temporary short-lived credentials. These credentials can be used to manage AWS resources. 

### Radius and AWS IRSA

{{< image src="images/radius-irsa.png" alt="using IRSA to deploy an AWS resource" width="750">}}

Radius allows management of AWS resources as part of your application. There are two Radius services that communicates with AWS to achieve this UCP and Applications RP.

The above image shows how Radius UCP leverages AWS IRSA to deploy and manage AWS resources. The flow is identical for Applications RP. 
Below are the key points in the flow:

1. In Kubernetes world, service accounts are used to provide an identity for applications running in pods. Kubernetes provides a service-account token in the form of a JWT (JSON Web Token). This token contains claims about the cluster, namespace and service-account. When Radius is installed with IRSA enabled, this token is mounted to the pod as a project volume.
   
2. When ucp/ applications-rp has to communicate with AWS for deloying / managing a resource, it first sends an assume role request to AWS STS. This request contains role ARN of the role to assume as well as the JWT from projected volume.
   
3. STS uses the claim from this JWT to verify that it is indeed k8s_cluster:radius-system:ucp that is making the request. It verifies by communicating with the cluster's configured OIDC provider. 
   
4. Once the identity of service is confirmed, STS checks the trust policy of the IAM role available in the request to make sure IAM role trusts the service-account to assume it.
   
5. At this point, the service-account associated with the workload (ucp or applications-rp) making the request is both authenticated and authorized. STS therefore issues a temporary credential back.
   
6. ucp (applications-rp) uses this temporary credentials to make sutiable API requests to make the AWS resources. 

### More details

Below is the relevant information from pod spec when Radius is installed with IRSA enabled. Note that aws-iam-token is added as a projected volume and mounted to ucp pod.

```
nithya@MacBook-Pro ~ % k describe pod -n radius-system ucp        
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

[Radius Setup AWS IRSA](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-wi/#setup-the-azure-workload-identity-for-radius) contains information on configuring the trust for the IAM Roles in AWS.

### Challenges and Solutions

AWS provides [Amazon EKS Pod Identity Webhook](https://github.com/aws/amazon-eks-pod-identity-webhook#amazon-eks-pod-identity-webhook). 
When installed on the cluster, the webhook configures the necessary settings for IRSA on pods that use the relevant service accounts.Specifically, the webhook adds two additional configurations to the relevant pods on creation:
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

We did not choose this solution because
* The approach requires roleARN to be injected at install time. Radius should not restart for credentials registration.
* Radius will evolve to support multi-tenancy. There is no support in the webhook to handle multiple role-arns.  

Radius found its solution by falling back to the basics of how workload identity works and adopting it as required. 

## How Radius Utilizes Azure Workload Identity

### Key Concepts

<u> Azure Active Directory</u>

Azure Active Directory (Azure AD) is Microsoft's cloud-based identity and access management service

<u> Entra ID</u>

Microsoft Entra ID is a suite of identity and access management solutions that includes Azure AD along with other services designed to secure access to resources and manage identities across various environments.

<u> Entra ID Application </u>

An application that is registered in Azure Active Directory (Azure AD) and is used to authenticate with Azure resources.

<u> Azure Workload Identity </u>

Azure Workload Identity is a security feature that allows applications running on Azure to securely access and interact with Azure resources using managed identities, rather than relying on static credentials.

### Radius and Azure Workload Identity

{{< image src="images/radius-az-wi.png" alt="using Az Workload Identity to deploy an Az resource" width="750">}}

Radius allows management of Azure resources as part of your application. There are three Radius services that communicates with AWS to achieve this: UCP, Applications RP and Deployment Engine.

The above image shows how Radius UCP leverages AWS IRSA to deploy and manage AWS resources. The flow is identical for Applications RP and Deployment Engine.

Below are the key points in the flow:

1. In Kubernetes world, service accounts are used to provide an identity for applications running in pods. Kubernetes provides a service-account token in the form of a JWT (JSON Web Token). This token contains claims about the cluster, namespace and service-account. When Radius is installed with Azure Workload Identity enabled in a cluster which has AzWI mutating admission webhook installed,  the webhook  mounts the service-account token to the pod as a project volume.
   
2. When ucp/ applications-rp has to communicate with Azure for deloying / managing a resource, it first sends request to Entra with its App ID and service-account token (JWT). 
   
3. Entra uses the claim from this JWT to verify that it is indeed k8s_cluster:radius-system:ucp that is making the request. It verifies by communicating with the cluster's configured OIDC provider. 
   
4. Once the identity of service is confirmed, Entra checks the trust policy of the App registeration to make sure service-account is trusted to perform the operation.
   
5. At this point, the service-account associated with the workload (ucp or applications-rp) making the request is both authenticated and authorized. Entra therefore issues a temporary credential back.
   
6. ucp (applications-rp) uses this temporary credentials to make suitable API requests to mange the Azure resources. 

### More details

Below is the relevant information from pod spec when Radius is installed with Workload Identity enabled. Radius annotates the pods with  ```azure.workload.identity/use=true``` label.
service-account token is injected by the AzWI mutating admission webhook because of the label.

```
nithya@MacBook-Pro ~ % k describe pod -n radius-system ucp        
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
      /var/run/secrets/azure/tokens from azure-identity-token (ro) (Injected by the webhook)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-jhmdl (ro)
      /var/tls/cert from cert (ro)
      :
    Volumes:
      azure-identity-token:
      Type:                    Projected (a volume that contains injected data from multiple sources)
      TokenExpirationSeconds:  3600
      :
```

[Radius Setup Az Workload Identity](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-wi/#setup-the-azure-workload-identity-for-radius) contains information on configuring the trust (federated credential) for the workloads in Azure.


## Comparison between providers

AWS and Azure provide very similar solutions for adopting workload identities. They also provide mutating webhooks that allow configuring workloads to use Workload Identity easily. However, Azure's mutating webhook supports its usage to just mount the service token account where as with AWS, it was not easy to do so.  This was because Azure's webhook utilized two annotations as part of workload identity configuration. We could choose to utilize ```azure.workload.identity/use: "true"``` to mount the service-token.

```
azure.workload.identity/use: "true"
azure.workload.identity/client-id: "<your-client-id>"
```

However, AWS's webhook utilized just one annotation, tightly coupling a specific IAM role ARN with the intent to enable
IRSA. While this is simpler compared to Azure in cases where we do not need multi-tenancy, it was not suitable for Radius.

```
eks.amazonaws.com/role-arn: arn:aws:iam::<account-number>:role/<role-name> 
```

## Learn More and Contribute 

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community. We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://docs.radapp.io/guides/operations/providers/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord)

Please refer to  [Radius Workload Identity Setup Guide](https://docs.radapp.io/guides/operations/providers/overview/) for setting up Radius with Workload Identities.
