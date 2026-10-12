---
date: "2026-10-12T07:00:00-07:00"
title: "Radius Community Update: September 2026"
linkTitle: "Community Update September 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the September 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams keep control over how resources are provisioned.

September brought Radius v0.61.0 with a wider set of `Radius.Core` capabilities, the removal of the legacy Kubernetes onboarding controllers, and the first three releases of the Radius plugin for the GitHub Copilot app. Read on for what landed and how to get involved.

## Releases

### Radius v0.60.2 (September 3)

This patch fixes `install.sh` escalating to `sudo` for a user-writable `$HOME/.local/bin`, returns a relative paginated `nextLink` so clients can reach the next page through the Kubernetes and UCP proxies, and supports windowless background CLI execution on Windows. See the [v0.60.2 release notes](https://github.com/radius-project/radius/releases/tag/v0.60.2) for the full changelog.

### Radius v0.61.0 (September 25)

- **More `Radius.Core` capabilities.** `rad resource list --preview` lists preview Environments and Applications, `rad env create --preview` and `rad env update --preview` can reference a Recipe pack in another Resource Group, and each `Radius.Core` Environment must now use a unique Kubernetes namespace. Deleting a preview Environment also deletes its Applications and resources instead of leaving them behind. `rad deploy` warns when a template uses the older `Applications.*` Resource Types and suggests the `Radius.*` replacement, so you can migrate before support is removed in a later release.
- **Deploy templates directly from HTTPS URLs.** `rad deploy` accepts a Bicep or ARM JSON template hosted at an HTTPS URL. Radius validates the URL, resolves relative Bicep module references from the remote template's location, and redacts URL credentials from command output.
- **Share Secrets between connected resources.** Connections to Recipe-backed resources carry both ordinary values and references to producer-managed Secrets. Radius stores Recipe secret outputs in managed `Radius.Security/secrets` resources and makes the references available to consuming Recipes without decrypting or exposing the values.
- **More services in the default Kubernetes Recipe pack.** The pack now includes PostgreSQL, RabbitMQ, and Redis, so you can deploy those backing services without configuring a custom Recipe pack. You can [download the pack](https://github.com/radius-project/resource-types-contrib/tree/main/recipe-packs/kubernetes) and attach it to an Environment today.
- **Fewer resource-name collisions.** Recipe-created cloud resources are now named using their Application and Environment, so two Applications or Environments no longer share the same underlying resource.

This release also contains a breaking change: the legacy Kubernetes `Recipe` custom resource and the `radapp.io/enabled` annotation-based Deployment onboarding have been removed. If you rely on either, migrate those workloads to Bicep, ARM, or Flux GitOps deployments before upgrading. Review the [v0.61.0 release notes](https://github.com/radius-project/radius/releases/tag/v0.61.0) and the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/) before you start, and remember that only incremental version upgrades are supported.

### Radius v0.61.1 (September 30)

This patch makes the deployment engine honor Bicep conditions for Kubernetes resources and other resources handled through extensibility providers. Resources whose conditions evaluate to `false` are skipped without invoking their providers, so untracked resources such as HorizontalPodAutoscalers are no longer created and left behind after `rad app delete`. See the [v0.61.1 release notes](https://github.com/radius-project/radius/releases/tag/v0.61.1).

### Radius plugin for the GitHub Copilot app

The [ai-extensions](https://github.com/radius-project/ai-extensions) repository shipped its first releases of the `radius` plugin that powers Radius Canvas. [radius@0.1.0](https://github.com/radius-project/ai-extensions/releases/tag/radius%400.1.0) on September 3 covers the preview experience: exploring an Application across modeled, planned, deployed, and branch-diff views, generating a validated `.radius/app.bicep` from repository source, creating and verifying deploy Environments, and deleting deployments and Environments through tracked, confirmed workflows. [radius@0.1.1](https://github.com/radius-project/ai-extensions/releases/tag/radius%400.1.1) followed the same day with fixes for Secret-backed connection modeling, and [radius@0.2.0](https://github.com/radius-project/ai-extensions/releases/tag/radius%400.2.0) on September 25 added a **Create Environment anyway** action for recoverable credential-verification failures, recognizable provider service names in Application graphs, and deployments that use the latest released Resource Types and Recipe packs.

Radius Canvas is in preview. Try it from the [how-to guide](https://edge.docs.radapp.io/integrations/github-copilot-app/canvas-extension/) and tell us what you think by [opening an issue](https://github.com/radius-project/ai-extensions/issues/new/choose).

## Recipes and Resource Types

The [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) catalog kept growing alongside the release. The Azure Container Instances Recipe pack landed in [#292](https://github.com/radius-project/resource-types-contrib/pull/292), MySQL and PostgreSQL gained a `tls` transport policy property that is enforced on Azure in [#307](https://github.com/radius-project/resource-types-contrib/pull/307) and [#332](https://github.com/radius-project/resource-types-contrib/pull/332), catalog guidance moved to Secret-backed connections in [#303](https://github.com/radius-project/resource-types-contrib/pull/303), and Recipe packs became Environment-independent in [#334](https://github.com/radius-project/resource-types-contrib/pull/334), so a pack defines only Recipes and is attached to an Environment separately.

## On the blog

[Day One in an Unknown Repo](https://blog.radapp.io/posts/2026/09/30/day-one-unknown-repo/) by [Nithya Subramanian](https://github.com/nithyatsu) opens a series on the Application graph. It walks through what you face when you clone an unfamiliar repository, and how the graph pulls Dockerfiles, Kubernetes manifests, Helm charts, configuration, and source code into one view of the Application.

Documentation caught up with Radius Canvas too: the [GitHub Copilot app extension docs](https://github.com/radius-project/docs/pull/1989) and guidance for [PostgreSQL Secret connections](https://github.com/radius-project/docs/pull/2021) both merged this month.

## Community

September was a busy month across the organization, with more than 300 pull requests merged in the public `radius-project` repositories. A large share of that work was test, release, and continuous integration hardening: Cloud end-to-end coverage for the Environment and deployment lifecycles in ai-extensions, Conventional Commit and release-parity tooling in the Radius repository, and functional tests for `rad upgrade kubernetes`.

A Recipe is self-contained Bicep or Terraform, which makes [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) one of the easiest places to start contributing. If you want to add support for infrastructure you use, browse the [good first issues](https://aka.ms/radius-first-issues).

## Get involved

Whether you are a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we would love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
