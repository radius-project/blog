---
date: "2026-09-10T07:00:00-07:00"
title: "Radius Community Update: August 2026"
linkTitle: "Community Update August 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the August 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams keep control over how resources are provisioned.

August was a big month. Radius v0.60.0 shipped the first preview of the fully extensible `Radius.*` Resource Types, along with support for using standard Bicep and Terraform modules directly as Recipes. Radius Canvas, a way to model, review, and deploy an Application from inside the GitHub Copilot app, was also announced. Read on for what landed, what is coming next, and how to get involved.

## Releases

### Radius v0.60.0 (August 19)


#### Preview release of fully extensible Resource Types

Radius v0.60 introduces preview versions of a new set of Resource Types under the Radius.* namespace. Radius.* Resource Types are completely recipe driven and fully customizable. These new Resource Types are available by using the --preview flag on common Radius CLI commands such as `rad init. For more details, visit the newly rewritten documentation at https://edge.docs.radapp.io/.


#### Direct IaC module support

Until now, a Bicep or Terraform module used as a Recipe had to be wrapped to accept a `context` input and return a structured `result` output, which meant you could not point Radius straight at an Azure Verified Module or a Terraform Registry module. You can now reference a standard module as a Recipe: Radius resolves `{{context.*}}` parameters, runs the module through the existing driver, and maps its outputs back onto Resource Type properties. Existing wrapped Recipes keep working unchanged. See [referencing an existing module](https://edge.docs.radapp.io/management/existing-recipes/#reference-an-existing-module) for details.

#### Modernized internal hashing (SHA-1 to SHA-256)

Radius now uses SHA-256 instead of SHA-1 to generate internal resource identifiers, Terraform Recipe state keys, ETags, and change-detection tokens. These hashes are used only for uniqueness and change detection, never for security. The upgrade is transparent and requires no action: existing Applications, Environments, resources, and Terraform state are recognized through a built-in compatibility layer, so nothing is redeployed and no pods are restarted. A future release will complete the transition and remove the compatibility layer.

There are no breaking changes in this release. For full details, see the [v0.60.0 release notes](https://github.com/radius-project/radius/releases/tag/v0.60.0).

### Radius v0.60.1 (August 26)

This patch release backports fixes for `rad resource list --preview`, live deployment graph support, custom Recipe pack reconciliation on repeat deploys, architecture-aware Container image builds, Azure OIDC token refresh and RBAC-propagation verification, and control-plane readiness during install and upgrade. It also reverts default Resource Group and Environment creation from `rad install kubernetes`. See the [v0.60.1 release notes](https://github.com/radius-project/radius/releases/tag/v0.60.1) for the full changelog.

You can upgrade by updating your rad CLI and running `rad upgrade kubernetes`. Only incremental version upgrades are supported, so consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/) before you start.

### Recipes and samples

The [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) catalog grew alongside the release. Azure Container Instances Recipes were added, `Radius.Messaging/rabbitMQ` now provisions a real broker on Azure, and the Azure database Recipes report the details applications actually need, including a `port` property for MySQL, PostgreSQL, and SQL Server, and a Redis access key exposed separately from the connection URL.

The [`demo` sample](https://github.com/radius-project/samples/tree/edge/samples/demo) moved to the `Radius.*` Resource Types and gained two variants that connect the demo Container to a managed cache and a managed database, so you can see `connections` in action against `Radius.Data/redisCaches` and `Radius.Data/postgreSqlDatabases`.

## Radius Canvas

Radius Canvas was announced this month in [Introducing Radius Canvas](https://techcommunity.microsoft.com/blog/azuredevcommunityblog/introducing-radius-canvas-visualize-review-and-deploy-applications-in-the-github/4549760) on the Azure Developer Community Blog, with a [walkthrough video](https://youtu.be/TU1cEIMMIAA) if you would rather watch than read.

Canvas ships in the `radius` plugin for the [GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app) and turns the source code in your repository into a modeled Radius Application without leaving Copilot. It is organized into three areas: **Applications**, which renders your Application as a live graph with modeled, planned, deployed, and diff views; **Environments**, where you create and verify the landing zone your Application deploys to; and **Deployments**, which provisions the infrastructure your Application needs and runs the deployment through a generated GitHub Actions workflow. Canvas is in preview, and the team wants your feedback in the [ai-extensions repository](https://github.com/radius-project/ai-extensions/issues/new/choose).

Most of the work behind the announcement landed during August. On the Radius side, `rad deploy` now publishes deploy status and live resource-state snapshots as workflow artifacts, so the deployed graph updates while a deployment is still running.

## Upcoming features

The following work merged to `main` in August after the v0.60 release and is not part of it. It offers a preview of what is coming next.

- **Deploy a template straight from a URL.** `rad deploy` accepts an `http(s)` URL in addition to a local path, so you can deploy a Bicep or ARM JSON template without downloading it first.
- **Managed Secrets projected through connections.** A single connection to a Recipe-backed producer can now carry both ordinary values and references to a managed `Radius.Security/secrets` resource, so consuming Recipes read secrets without values ever being copied onto the producer.
- **`rad env delete --preview` cascades.** Deleting a `Radius.Core` Environment now removes the Applications and resources deployed into it instead of orphaning them, and the confirmation prompt states what will be deleted.
- **Deprecation warning for `Applications.*` types.** `rad deploy` warns when a template uses a legacy `Applications.*` type, naming the `Radius.*` type that replaces it.
- **Recipe packs from another Resource Group.** `rad env create --preview` and `rad env update --preview` accept `--recipe-pack-group`, so a Recipe pack no longer has to live in the Environment's own Resource Group.
- **Unique Kubernetes namespaces for Environments.** `Radius.Core/environments` now enforce namespace uniqueness, so two Environments can no longer quietly deploy into the same namespace.
- **More in the default Kubernetes Recipe pack.** RabbitMQ and PostgreSQL joined the default Kubernetes Recipe pack, so an Environment with no cloud provider configured can satisfy those Resource Types out of the box.

## Community

**Welcome to our new contributors.** Two people merged their first contribution to the Radius repository this month:

- [@ryanwaite](https://github.com/ryanwaite) improved how the Azure verify workflow reports GitHub OIDC failures, then fixed verification during Azure RBAC propagation
- [@pujitha24](https://github.com/pujitha24) added the `--recipe-pack-group` flag described above and fixed `rad deploy` resolving a `Radius.Core` Environment ID in the wrong Resource Group

A Recipe is self-contained Bicep or Terraform, which makes [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) one of the easiest places to start contributing. If you want to add support for infrastructure you use, browse the [good first issues](https://aka.ms/radius-first-issues).

## Get involved

Whether you are a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we would love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
