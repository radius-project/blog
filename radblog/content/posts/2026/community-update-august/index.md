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

This is the latest minor release of Radius. Here are the highlights and what they mean for you.

#### Preview release of fully extensible Resource Types

Radius v0.60 introduces preview versions of a new set of Resource Types under the `Radius.*` namespace, such as `Radius.Core/applications`, `Radius.Compute/containers`, and `Radius.Data/redisCaches`. Unlike the `Applications.*` types they replace, these types are completely Recipe driven and fully customizable, so a platform engineer decides what infrastructure backs each type instead of accepting a fixed implementation.

Add `--preview` to common rad CLI commands such as `rad init`, `rad env create`, and `rad deploy` to work with the new types, or set `RADIUS_PREVIEW=true` once so every command in that shell session uses them. Documentation for the new model has been rewritten and is published at [edge.docs.radapp.io](https://edge.docs.radapp.io/).

#### Direct IaC module support

Until now, a Bicep or Terraform module used as a Recipe had to be wrapped to accept a `context` input and return a structured `result` output, which meant you could not point Radius straight at an Azure Verified Module or a Terraform Registry module. You can now reference a standard module as a Recipe: Radius resolves `{{context.*}}` parameters, runs the module through the existing driver, and maps its outputs back onto Resource Type properties. Existing wrapped Recipes keep working unchanged. See [referencing an existing module](https://edge.docs.radapp.io/management/existing-recipes/#reference-an-existing-module) for details.

#### Modernized internal hashing (SHA-1 to SHA-256)

Radius now uses SHA-256 instead of SHA-1 to generate internal resource identifiers, Terraform Recipe state keys, ETags, and change-detection tokens. These hashes are used only for uniqueness and change detection, never for security. The upgrade is transparent and requires no action: existing Applications, Environments, resources, and Terraform state are recognized through a built-in compatibility layer, so nothing is redeployed and no pods are restarted. A future release will complete the transition and remove the compatibility layer.

There are no breaking changes in this release. For full details, see the [v0.60.0 release notes](https://github.com/radius-project/radius/releases/tag/v0.60.0).

### Radius v0.60.1 (August 26)

This patch release backports fixes for `rad resource list --preview`, live deployment graph support, custom Recipe pack reconciliation on repeat deploys, architecture-aware Container image builds, Azure OIDC token refresh and RBAC-propagation verification, and control-plane readiness during install and upgrade. It also reverts default Resource Group and Environment creation from `rad install kubernetes`. See the [v0.60.1 release notes](https://github.com/radius-project/radius/releases/tag/v0.60.1) for the full changelog.

You can upgrade by updating your rad CLI and running `rad upgrade kubernetes`. Only incremental version upgrades are supported, so consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/) before you start.

## Radius Canvas

Radius Canvas was announced this month in [Introducing Radius Canvas](https://techcommunity.microsoft.com/blog/azuredevcommunityblog/introducing-radius-canvas-visualize-review-and-deploy-applications-in-the-github/4549760) on the Azure Developer Community Blog, with a [walkthrough video](https://youtu.be/TU1cEIMMIAA) if you would rather watch than read.

Canvas ships in the `radius` plugin for the [GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app) and turns the source code in your repository into a modeled Radius Application without leaving Copilot. It is organized into three areas: **Applications**, which renders your Application as a live graph with modeled, planned, deployed, and diff views; **Environments**, where you create and verify the landing zone your Application deploys to; and **Deployments**, which provisions the infrastructure your Application needs and runs the deployment through a generated GitHub Actions workflow. Canvas is in preview, and the team wants your feedback in the [ai-extensions repository](https://github.com/radius-project/ai-extensions/issues/new/choose).

Most of the work behind the announcement landed during August. On the Radius side, `rad deploy` now publishes deploy status and live resource-state snapshots as workflow artifacts, so the deployed graph updates while a deployment is still running. ([#12628](https://github.com/radius-project/radius/pull/12628), [#12727](https://github.com/radius-project/radius/pull/12727))

## Upcoming features

The following work merged to `main` in August after the v0.60 release and is not part of it. It offers a preview of what is coming next.

- **Deploy a template straight from a URL.** `rad deploy` accepts an `http(s)` URL in addition to a local path, so you can deploy a Bicep or ARM JSON template — a Recipe pack in `resource-types-contrib`, for example — without downloading it first. Downloads are size-bounded, and a `bicepconfig.json` is written next to the template so `extension radius` still resolves. ([#12676](https://github.com/radius-project/radius/pull/12676))
- **Managed Secrets projected through connections.** A single connection to a Recipe-backed producer can now carry both ordinary values and references to a managed `Radius.Security/secrets` resource. Consuming Recipes read them as `context.resource.connections.<name>.secrets.<key>`, and secret values are never decrypted or copied onto the producer. ([#12709](https://github.com/radius-project/radius/pull/12709), with the matching Container Recipe in [resource-types-contrib#300](https://github.com/radius-project/resource-types-contrib/pull/300))
- **`rad env delete --preview` cascades.** Deleting a `Radius.Core` Environment previously removed only the Environment resource and silently orphaned everything deployed into it, while the prompt always claimed the Environment was empty. The command now enumerates the Applications and resources it will remove, states the real count in the confirmation prompt, deletes them in order, and accepts `--force` for resources stuck in a non-terminal state. ([#12822](https://github.com/radius-project/radius/pull/12822))
- **Deprecation warning for `Applications.*` types.** Deploying a template that uses a legacy `Applications.*` type at API version `2023-10-01-preview` now prints a warning naming each deprecated type and the `Radius.*` type that replaces it. The warning is printed once, on the authoring path only, and the deployment proceeds normally. ([#12824](https://github.com/radius-project/radius/pull/12824))
- **Recipe packs from another Resource Group.** `rad env create --preview` and `rad env update --preview` accept `--recipe-pack-group`, so a bare Recipe pack name passed to `--recipe-packs` resolves against that group instead of the Environment's own Resource Group. ([#12634](https://github.com/radius-project/radius/pull/12634))
- **Unique Kubernetes namespaces for Environments.** `Radius.Core/environments` now enforce namespace uniqueness, so two Environments can no longer quietly deploy into the same namespace. ([#12718](https://github.com/radius-project/radius/pull/12718))
- **More in the default Kubernetes Recipe pack.** RabbitMQ and PostgreSQL joined the default Kubernetes Recipe pack, so an Environment with no cloud provider configured can satisfy those Resource Types out of the box. ([#12752](https://github.com/radius-project/radius/pull/12752), [#12755](https://github.com/radius-project/radius/pull/12755))
- **Fixes.** `rad deploy` resolves a `Radius.Core` Environment ID in the correct Resource Group ([#12599](https://github.com/radius-project/radius/pull/12599)), `rad env update --recipe-packs` no longer hides its error beneath a warning ([#12669](https://github.com/radius-project/radius/pull/12669)), URL redaction applies to every remote template path the CLI displays ([#12698](https://github.com/radius-project/radius/pull/12698)), and unfolding a Recipe delete error no longer panics ([#12653](https://github.com/radius-project/radius/pull/12653)).

## Community

**Recipes and Resource Types.** The [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) catalog kept growing: Recipes for Azure Container Instances ([#215](https://github.com/radius-project/resource-types-contrib/pull/215)), a real RabbitMQ broker for `Radius.Messaging/rabbitMQ` on Azure ([#287](https://github.com/radius-project/resource-types-contrib/pull/287)), generated secret connection environment variables ([#300](https://github.com/radius-project/resource-types-contrib/pull/300)), a `port` property for the Azure MySQL, PostgreSQL, and SQL Server databases ([#319](https://github.com/radius-project/resource-types-contrib/pull/319)), and a Redis access key exposed separately from the connection URL ([#320](https://github.com/radius-project/resource-types-contrib/pull/320)). A Recipe is self-contained Bicep or Terraform, which makes this one of the easiest places to start contributing — browse the [good first issues](https://aka.ms/radius-first-issues).

**Samples.** The `demo` sample moved to the `Radius.*` Resource Types and gained two variants that connect the demo Container to a managed cache and a managed database, so you can see `connections` in action against `Radius.Data/redisCaches` and `Radius.Data/postgreSqlDatabases`. ([samples#2645](https://github.com/radius-project/samples/pull/2645))

**Welcome to our new contributors.** Two people merged their first contribution to the Radius repository this month:

- [@ryanwaite](https://github.com/ryanwaite) surfaced GitHub OIDC enterprise-claim failures in the Azure verify workflow ([#12577](https://github.com/radius-project/radius/pull/12577)) and went on to fix Azure verification during RBAC propagation ([#12764](https://github.com/radius-project/radius/pull/12764))
- [@pujitha24](https://github.com/pujitha24) added the `--recipe-pack-group` flag described above ([#12634](https://github.com/radius-project/radius/pull/12634)) and fixed `rad deploy` resolving a `Radius.Core` Environment ID in the wrong Resource Group ([#12599](https://github.com/radius-project/radius/pull/12599))

## Get involved

Whether you are a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we would love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stay updated:** Join our monthly community meeting (sign up via the [Radius Google Group](https://groups.google.com/g/radapp_io)) or subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
