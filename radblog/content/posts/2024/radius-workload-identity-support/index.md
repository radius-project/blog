---
date: "2024-09-T08:00:00-08:00"
title: "Workload Identity Support in Radius"
linkTitle: "Managing cloud provider credentials in Radius"
author: "[]()"
type: blog
---

## Configuring Workload Identity for Cloud Providers in Radius

Radius enables developers and the operators to define, deploy, and collaborate on cloud-native applications across public clouds and private infrastructure. In order to deploy cloud resources, Radius has to be configured with cloud provider's credentials. 

Radius can be configured with static credentials to interact with Azure and AWS:
 
```
rad credential register azure sp --client-id <client id> --client-secret <client secret> --tenant-id <tenant id>
``` 

```
rad credential register aws --access-key-id <access-key-id> --secret-access-key <secret-access-key>
```
 
These credentials should be rotated regularly to reduce the chance of unauthorized access. A more secure option than using these credentials is to use Workload identity. Workload identity is a concept that allows applications (workloads) running on cloud platforms to securely access and interact with cloud resources using managed identities, rather than relying on static credentials. This enhances security by reducing the need to manage secrets and credentials manually.

In Azure, this is implemented through Azure Workload Identity, which uses Azure Active Directory (AAD) to provide pods with their own first-class identity. In AWS, the equivalent technology is Amazon IRSA ( IAM Role for Service Accounts), which allows Kubernetes service-accounts to assume an IAM Role configured with fine-grained permissions.

Radius can be configured with workload identity for deploying AWS and Azure resources:

```
rad credential register azure wi --client-id <client id> --tenant-id <tenant id>
```

```
rad credential register aws irsa --iam-role <roleARN>
```

## Radius and Workload Identity 

A software workload such as a container-based application, service or script needs an identity to authenticate, access, and communicate with services that are distributed across different platforms and/or cloud providers. Workload identity is a security concept that allows applications (workloads) running on cloud platforms to securely access and interact with cloud resources using managed identities, rather than relying on static credentials. This approach enhances security by reducing the need to manage secrets and credentials manually.As mentioned above, Azure workload identity and AWS IRSA (IAM Role for Service Accounts) are the implmentations of this concept on Azure and AWS respectively. Some benefits of using workload identities are:

* Reduced Credential Management: No need to manage and rotate static credentials manually.
* Enhanced Security: Minimizes the risk of credential leakage and unauthorized access.
* Simplified Access Control: Permissions are managed centrally through cloud provider IAM policies.

The following sections explain how Radius uses Workload Identity to securely deploy and manage cloud resources.

### How Radius works with Azure Workload Identity

- component diagram / sequence diagram higlighting the flow between
one of the radius pods , OIDC provider, Azure

- explanation of the diagram

- Adapting to Radius (explain decisions to not use pod identitity plugins)


### How Radius works with AWS IRSA

-  component diagram / sequence diagram higlighting the flow between
one of the radius pods , OIDC provider, AWS

what tools can I use?

- explanation of the diagram



#### Token Injection: 

When Radius is installed with IRSA enabled, the deployment spec associated with UCP and Applications-RP includes a projected volume with serviceAccountToken as source. This OIDC token contains claims that identify the Kubernetes service account and the cluster.

```
{{- if eq .Values.global.aws.irsa.enabled true }}
        - name: aws-iam-token
          mountPath: /var/run/secrets/eks.amazonaws.com/serviceaccount 
{{- end }}
:
:
{{- if eq .Values.global.aws.irsa.enabled true }}
        - name: aws-iam-token
          projected:
            sources:
            - serviceAccountToken:
                path: token
                expirationSeconds: 86400
                audience: "sts.amazonaws.com"
```

#### Application Reads Token: 

UCP and Applications-RP pods then read the OIDC token from the mounted volume. This token is used to authenticate with AWS.

#### AssumeRoleWithWebIdentity API Call: 

UCP and Applications-RP uses the AWS SDK to call the sts:AssumeRoleWithWebIdentity API. This API call includes the OIDC token and the ARN of the IAM role associated with the Kubernetes service account.

#### STS Validates Token: 

AWS Security Token Service (STS) validates the OIDC token. It checks the token's claims, such as the subject (sub) and audience (aud), against the trust policy of the IAM role.

#### Temporary Credentials Issued:

If the token is valid and the trust policy conditions are met, STS issues temporary security credentials (access key ID, secret access key, and session token) to the application.

#### Deploy to AWS: 

The application uses these temporary credentials to make authenticated requests to AWS services, such as deploying resources. The temporary credentials have a limited lifetime and are automatically refreshed as needed.

#### Adapting IRSA Solution for Radius

Talk about webhook, service-account annotation, decision to move away due to the vision for multicloud and multitenancy which requires multi credential, undesirable service restarts upon service-account annotation.

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
