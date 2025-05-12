---
date: "2025-05-10T08:00:00-08:00"
title: "Integrating Radius into your GitOps Flux workflow"
linkTitle: "Radius + GitOps with Flux"
author: "[Will Smith](https://www.github.com/willdavsmith)"
type: blog
---

GitOps is an approach to managing infrastructure and applications using Git as the single source of truth. This approach provides several benefits - including declarative management of infrastructure definitions and auditable change logs. Radius fits nicely into this workflow, allowing you to define your applications and infrastructure with Radius and then use GitOps to deploy and manage them across your deployment platforms.

Radius has built first-class support for [Flux](https://fluxcd.io/), a GitOps tool designed to work with Kubernetes and provides a powerful set of features for managing applications and infrastructure through Git.

In this post, we'll explore how to deploy and manage Radius applications using Flux, how to integrate Radius into your GitOps workflow, and technical specifics on how this integration works. For a step-by-step integration guide for Radius and Flux, check out see [How-To: Set up Radius with Flux](https://docs.radapp.io/guides/deploy-apps/gitops/howto-flux/) in the Radius documentation.

## Overview of Radius + Flux

In a typical GitOps workflow using Flux, you would have one or more Git repositories that contain your application and infrastructure definitions. These definitions are Kubernetes manifests, Helm charts, or other formats that Flux can understand. When you make changes to these definitions in Git, Flux automatically detects the changes and applies them to your Kubernetes cluster.

Since Radius aims to be deployment platform agnostic, its application and infrastructure definitions are written in Bicep and Terraform, which is not natively supported by Flux. However, the first-class integration we have built brings the needed support in Flux to allow for defining applications and infrastructure with Radius, and then using Flux to deploy and manage them.

## Using Radius with Flux

Note: This section is a high-level overview of the integration. For a step-by-step guide, see [How-To: Set up Radius with Flux](https://docs.radapp.io/guides/deploy-apps/gitops/howto-flux/) in the Radius documentation.

As with any GitOps workflow, you will need to set up a Git repository that contains your application and infrastructure definitions. To enable Radius in this workflow, you will also need to include a `radius-gitops-config.yaml` file in the root of your repository. Radius applications and infrastructure are defined using a root Bicep file, so the `radius-gitops-config.yaml` file will contain a list of Bicep files that define your applications and infrastructure:

### radius-gitops-config.yaml
```yaml
config:
  - name: todolist.bicep # The name of the Bicep file that defines your application
    params: todolist.bicepparam # Optional: Parameter file for the Bicep file
    resourceGroup: default # Optional: The Radius resource group to deploy the resources to
    namespace: todolist-app # Optional: The Kubernetes namespace to deploy the resources to
  - name: anotherbicepfile.bicep # Can optionally specify multiple Bicep files to deploy and manage.
```

### Configuring Flux

Aside from the `radius-gitops-config.yaml` file, everything else can stay the same as a typical Flux setup. You will need to set up a Git repository and configure Flux to watch that repository. You can do this using the Flux CLI or by applying the necessary Kubernetes manifests.

Note: When installing Flux using the `flux bootstrap` or `flux install` commands, ensure that the `--network-policy false` flag is specified for testing, or that the network policy is configured to allow access from `radius-system` namespace to the source controller. For more information on the network policy, see the [Flux documentation](https://fluxcd.io/flux/installation/configuration/optional-components/#network-policies).

### Configuring Radius

The Flux integration with Radius is built into the Radius control plane. Everything is configured automatically when you create a `GitRepository` resource in your cluster. The Radius Flux controller will watch for changes to the `GitRepository` resources and trigger the necessary actions in Radius. Any changes to the files in the repository will be detected by Flux, and then Radius will create, update, or delete the necessary resources in the cluster. Now you can use Radius to define your applications and infrastructure, and then use Flux to deploy and manage them on Kubernetes.

{{< image src="images/radius-flux-highlevel.png" alt="Data flow diagram showing how Radius and Flux work together to deploy apps to the Kubernetes cluster" width="800">}}

## How does this work?

To enable this integration, we have built new Kubernetes controllers that work together to watch for changes in the Git repository and trigger the necessary actions in Radius. These new controllers are built into Radius — you do not have to configure anything other than placing the `radius-gitops-config.yaml` file in your repository root.

### Radius Flux Controller
The **Radius Flux Controller** [[Code](https://github.com/radius-project/radius/blob/main/pkg/controller/reconciler/flux_controller.go)] [[Design](https://github.com/radius-project/design-notes/blob/main/tools/2025-01-gitops-technical-design.md)] watches Flux `GitRepository` resources on the cluster. When a new `GitRepository` resource is created, the controller will read the contents of the repository. If it contains a `radius-gitops-config.yaml` file, the controller will parse the file and create a new `DeploymentTemplate` resource for each application defined in the `radius-gitops-config.yaml` file. `DeploymentTemplate` resources are a new resource type that we have created to represent the deployment of a Radius application.

### DeploymentTemplate Controller
The **DeploymentTemplate Controller** [[Code](https://github.com/radius-project/radius/blob/main/pkg/controller/reconciler/deploymenttemplate_reconciler.go)] [[Design](https://github.com/radius-project/design-notes/blob/main/architecture/2024-10-deploymenttemplate-controller.md)] watches for changes to `DeploymentTemplate` resources. When a `DeploymentTemplate` resource is created, updated, or deleted, the controller will submit the necessary operations and data to the Radius control plane to create, update, or delete the application and its resources.

## Extensibility

The design of this feature in Radius is intentionally pluggable to allow for future extensibility. We have built the first-class support for Flux first, but the design allows for other GitOps tools to be integrated in the future.

### ArgoCD

Similar to Flux, [ArgoCD]() is another popular GitOps tool for Kubernetes. The design of the Radius GitOps integration allows for ArgoCD to be integrated in the future. We have a [GitHub issue](https://github.com/radius-project/radius/issues/6942) open to track the progress of this integration, so if you are interested in this work or would like to contribute, please feel free to comment on the issue.

Using the existing design, ArgoCD could integrate with Radius in a similar way to Flux. ArgoCD would watch for changes to the remote Git repository, and some replacement for the `radius-flux-controller` would be responsible for creating and updating the `DeploymentTemplate` resources in the cluster. As long as this `DeploymentTemplate` resources is created and updated when the Git repository changes, Radius will handle the rest of the deployment process.

One idea is to use ArgoCD's [Config Management Plugins](https://argo-cd.readthedocs.io/en/stable/operator-manual/config-management-plugins/) to watch for `radius-gitops-config.yaml` files in the Git repository. When a new `radius-gitops-config.yaml` file is detected, ArgoCD would create a new `DeploymentTemplate` resource in the cluster. This would allow for a similar integration to the one we have built for Flux. We would love to hear your thoughts on this idea, so please feel free to comment on the [GitHub issue]([GitHub issue](https://github.com/radius-project/radius/issues/6942)), and come join us and contribute if it interests you!

## Conclusion

Integrating Radius into your GitOps workflow brings out the best of both worlds: the power of Radius for defining and managing applications and infrastructure, and the benefits of GitOps for managing those definitions in a declarative and auditable way. This integration allows you to use Radius to define your applications and infrastructure, and then use Flux to deploy and manage them on Kubernetes.

For more detailed information and step-by-step guides, refer to [How-To: Set up Radius with Flux](https://docs.radapp.io/guides/deploy-apps/gitops/howto-flux/) in the Radius documentation.

## Learn More and Contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We're looking for people to join us! To get started with Radius today, please see:

- Start using Radius with the [getting started guide](https://docs.radapp.io/getting-started/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).
