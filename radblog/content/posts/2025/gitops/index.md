---
date: "2025-05-10T08:00:00-08:00"
title: "Integrating Radius into your GitOps Flux workflow"
linkTitle: "Radius + GitOps with Flux"
author: "[Will Smith](https://www.github.com/willdavsmith)"
type: blog
---

GitOps is a popular approach to managing infrastructure and applications using Git as the single source of truth. This approach provides lots of benefits - including declarative management of infrastructure definitions and auditable changelogs. Radius fits nicely into this workflow, allowing you to define your applications and infrastructure with Radius and then use GitOps to deploy and manage them across your deployment platforms.

Radius has built first-class support for [Flux](https://fluxcd.io/), a GitOps tool designed to work with Kubernetes and provides a powerful set of features for managing applications and infrastructure through Git.

In this post, we'll explore how to deploy and manage Radius applications using Flux, how to integrate Radius into your GitOps workflow, and technical specifics on how this integration works. For a step-by-step integration guide for Radius + Flux, check out the [Radius Docs](https://docs.radapp.io/guides/deploy-apps/gitops/howto-flux/).

## Overview of Radius + Flux

In a typical GitOps workflow using Flux, you would have one or more Git repositories that contain your application and infrastructure definitions. These definitions are Kubernetes manifests, Helm charts, or other formats that Flux can understand. When you make changes to these definitions in Git, Flux automatically detects the changes and applies them to your Kubernetes cluster.

Radius aims to be deployment platform agnostic, so Radius applications and infrastructure definitions are written in Bicep and Terraform, which is not natively supported by Flux. However, the first-class integration that we have built allows seamless integration with Flux, allowing you to use Radius to define your applications and infrastructure, and then use Flux to deploy and manage them.

TODO: Diagram here showing black box flows of Git, Flux, Radius, Kubernetes
How do I create a "Microsofty" diagram like in our docs?

## Setting up Radius with Flux

### Pre-requisites
- A Kubernetes cluster
- Flux installed and configured
- Radius installed and configured
- A Git repository for your application and infrastructure definitions

Flux uses a Git repository as the source of truth for application and infrastructure definitions.

### Prepare Radius Application

To prepare a Radius application for deployment with Flux, you need to create a Bicep file that defines your application. This file should include all the necessary resources and configurations for your application.

#### app.bicep
```bicep
// Import the set of Radius resources (Applications.*) into Bicep
extension radius

@description('The Radius environment name to deploy the application and resources to.')
param environment string = 'default'

resource env 'Applications.Core/environments@2023-10-01-preview' existing = {
  name: environment
}

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'app'
  properties: {
    environment: env.id
  }
}

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}
```

The `radius-gitops-config.yaml` file is used to configure the Radius application for deployment with Flux. This file should be placed in the root of your Git repository.

#### radius-gitops-config.yaml
```yaml
config:
  - name: app.bicep
    resourceGroup: default
```

This is all that's needed to configure the Radius application for deployment with Flux. All that's left is to add these files to a remote Git repository and configure Flux to watch this repository:

```bash
git add app.bicep radius-gitops-config.yaml
git commit -m "Add Radius application and configuration for Flux"
git push origin main

flux create source git radius-flux-app \
  --url=<your-repo-url> \
  --branch=main
```

You can now manage your Radius applications using Git as the single source of truth. When you make changes to your application or infrastructure definitions in Git, Flux will automatically detect the changes and trigger Radius to apply them to your Kubernetes cluster.

TODO: Diagram here showing Flux control plane, radius flux controller, deploymenttemplate controller flow

## How does this work?

To enable this integration, we have built new Kubernetes controllers that work together to watch for changes in the Git repository and trigger the necessary actions in Radius.

### Radius Flux Controller
The **Radius Flux Controller** [[Code](https://github.com/radius-project/radius/blob/main/pkg/controller/reconciler/flux_controller.go)] [[Design](https://github.com/radius-project/design-notes/blob/main/tools/2025-01-gitops-technical-design.md)] watches Flux `GitRepository` resources on the cluster. When a new `GitRepository` resource is created, the controller will read the contents of the repository. If it contains a `radius-gitops-config.yaml` file, the controller will parse the file and create a new `DeploymentTemplate` resource for each application defined in the `radius-gitops-config.yaml` file. `DeploymentTemplate` resources are a new resource type that we have created to represent the deployment of a Radius application.

### DeploymentTemplate Controller
The **DeploymentTemplate Controller** [[Code](https://github.com/radius-project/radius/blob/main/pkg/controller/reconciler/deploymenttemplate_reconciler.go)] [[Design](https://github.com/radius-project/design-notes/blob/main/architecture/2024-10-deploymenttemplate-controller.md)] watches for changes to `DeploymentTemplate` resources. When a `DeploymentTemplate` resource is created, updated, or deleted, the controller will submit the necessary operations and data to the Radius control plane to create, update, or delete the application and its resources.

## Conclusion

Integrating Radius into your GitOps workflow brings out the best of both worlds: the power of Radius for defining and managing applications and infrastructure, and the benefits of GitOps for managing those definitions in a declarative and auditable way. This integration allows you to use Radius to define your applications and infrastructure, and then use Flux to deploy and manage them on Kubernetes.

For more detailed information and step-by-step guides, refer to the official [Radius documentation for Radius + GitOps](https://docs.radapp.io/guides/deploy-apps/gitops/overview/).

## Learn More and Contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We're looking for people to join us!  To get started with Radius today, please see:

- Start using Radius with the [getting started guide](https://docs.radapp.io/getting-started/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).
