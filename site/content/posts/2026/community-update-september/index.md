---
date: "2026-10-14T07:00:00-07:00"
title: "Radius Community Update: September 2026"
linkTitle: "Community Update September 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the September 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams keep control over how resources are provisioned.

September brought Radius v0.61.0 with a wider set of `Radius.Core` capabilities, the removal of the legacy Kubernetes onboarding controllers, and a new release of the Radius plugin for the GitHub Copilot app. Read on for what landed, what is coming next, and how to get involved.

## Releases

### Radius v0.60.2 (September 3)

This patch fixes `install.sh` escalating to `sudo` for a user-writable `$HOME/.local/bin`, returns a relative paginated `nextLink` so clients can reach the next page through the Kubernetes and UCP proxies, and supports windowless background CLI execution on Windows. See the [v0.60.2 release notes](https://github.com/radius-project/radius/releases/tag/v0.60.2) for the full changelog.

### Radius v0.61.0 (September 25)

- **More `Radius.Core` capabilities.** The preview Resource Types gained several updates:
  - `rad resource list --preview` now lists `Radius.Core/environments` and `Radius.Core/applications`.
  - `rad env create --preview` and `rad env update --preview` can reference a Recipe pack that lives outside the Environment's own Resource Group.
  - Each Environment must use a Kubernetes namespace no other Environment holds, so two Environments can no longer quietly deploy into the same one.
  - Deleting an Environment removes the Applications and resources deployed into it instead of leaving them behind.
  - `rad deploy` warns when a template uses the older `Applications.*` Resource Types and suggests the `Radius.*` replacement, so you can migrate before support is removed in a later release.
- **Deploy templates directly from HTTPS URLs.** `rad deploy` accepts a Bicep or ARM JSON template hosted at an HTTPS URL. Radius validates the URL, resolves relative Bicep module references from the remote template's location, and redacts URL credentials from command output.
- **Share Secrets between connected resources.** Connections to Recipe-backed resources carry both ordinary values and references to producer-managed Secrets. Radius stores Recipe secret outputs in managed `Radius.Security/secrets` resources and makes the references available to consuming Recipes without decrypting or exposing the values.
- **More services in the default Kubernetes Recipe pack.** The pack now includes PostgreSQL, RabbitMQ, and Redis, so you can deploy those backing services without configuring a custom Recipe pack. You can [download the pack](https://github.com/radius-project/resource-types-contrib/tree/main/recipe-packs/kubernetes) and attach it to an Environment today.
- **Fewer resource-name collisions.** Recipe-created cloud resources are now named using their Application and Environment, so two Applications or Environments no longer share the same underlying resource.

This release also contains a breaking change: the legacy Kubernetes `Recipe` custom resource and the `radapp.io/enabled` annotation-based Deployment onboarding have been removed. If you rely on either, migrate those workloads to Bicep, ARM, or Flux GitOps deployments before upgrading. Review the [v0.61.0 release notes](https://github.com/radius-project/radius/releases/tag/v0.61.0) and the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/) before you start, and remember that only incremental version upgrades are supported.

### Radius v0.61.1 (September 30)

This patch makes the deployment engine honor Bicep conditions for Kubernetes resources and other resources handled through extensibility providers. Resources whose conditions evaluate to `false` are skipped without invoking their providers, so untracked resources such as HorizontalPodAutoscalers are no longer created and left behind after `rad app delete`. See the [v0.61.1 release notes](https://github.com/radius-project/radius/releases/tag/v0.61.1).

### Recipes and Resource Types

The [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) catalog kept growing alongside the release. The [Azure Container Instances Recipe pack](https://github.com/radius-project/resource-types-contrib/tree/main/recipe-packs/azure-aci) is now available, and [MySQL](https://github.com/radius-project/resource-types-contrib/tree/main/Data/mySqlDatabases) and [PostgreSQL](https://github.com/radius-project/resource-types-contrib/tree/main/Data/postgreSqlDatabases) gained a `tls` transport policy property that the Azure Recipes enforce. Catalog guidance also moved to Secret-backed connections, and Recipe packs became Environment-independent, so a pack defines only Recipes and is attached to an Environment separately.

## Radius plugin for the GitHub Copilot app

[radius@0.2.0](https://github.com/radius-project/ai-extensions/releases/tag/radius%400.2.0), released on September 25, is the latest version of the `radius` plugin that powers Radius Canvas in the [GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app). It adds:

- **A way past recoverable verification failures.** When credential verification fails for a reason you can accept, such as missing permissions or an unreachable cluster, the panel offers **Create Environment anyway**. The Environment is then listed as `bypassed` rather than verified, so deploys are unblocked without discarding the real result.
- **Credential drift detection on redeploy.** A deploy that fails at its cloud login step now explains that the credentials drifted and offers a **Re-verify credentials** action instead of a raw workflow error.
- **Recognizable provider service names** in planned and deployed graphs, with the exact concrete Resource Type still available in node details.
- **The latest released Resource Types and Recipe packs.** Packs now define only Recipes, so the deploy workflow creates the Environment and then attaches the pack. Existing Environments keep their packs and need no action.
- **Safer graphs and deletes.** Graph artifacts retain only required resource, relationship, and provider-output metadata, and graph-visible `Radius.Security/secrets` data is rejected before a graph is saved or rendered. The delete confirmation now names the resources the delete will destroy.

Radius Canvas is in preview. Try it from the [how-to guide](https://docs.radapp.io/integrations/github-copilot-app/canvas-extension/) and tell us what you think by [opening an issue](https://github.com/radius-project/ai-extensions/issues/new/choose).

## Upcoming features

The following work merged to `main` in September after the v0.61.0 release and is not part of it. It offers a preview of what is coming next.

- **A clear error when an Environment name cannot be a namespace.** `rad env create` uses the Environment name as the Kubernetes namespace when you do not pass `--kubernetes-namespace`. That default was never validated, so a name such as `myEnv` reached the server and failed with an unrelated message. The CLI now fails fast and explains the namespace rules, and a mixed-case name still works when you pass an explicit namespace. ([#13156](https://github.com/radius-project/radius/pull/13156))
- **Readable output from `rad resource-type show`.** Long property descriptions printed on a single line, so the terminal hard-wrapped them at column 0. In a terminal, descriptions now word-wrap under the DESCRIPTION column, and long tokens such as URLs are split safely. Piped and `-o json` output is unchanged. ([#13158](https://github.com/radius-project/radius/pull/13158))
- **The PowerShell installer no longer hangs on a stalled Bicep download.** `install.ps1` bounds `rad bicep download` with a timeout, so a stalled transfer produces a warning and the install continues instead of waiting indefinitely. ([#12852](https://github.com/radius-project/radius/pull/12852))

## Community

**Blog.** [Day One in an Unknown Repo](https://blog.radapp.io/posts/2026/09/30/day-one-unknown-repo/) by [Nithya Subramanian](https://github.com/nithyatsu) opens a series on the Application graph. It walks through what you face when you clone an unfamiliar repository, and how the graph pulls Dockerfiles, Kubernetes manifests, Helm charts, configuration, and source code into one view of the Application.

**Docs.** Documentation caught up with Radius Canvas this month, with a how-to guide for the [Radius plugin for the GitHub Copilot app](https://docs.radapp.io/integrations/github-copilot-app/canvas-extension/). The getting started walkthrough for [adding a connection](https://docs.radapp.io/getting-started/add-connection/) now models the database password as an authored Secret and connects the container to it.

**Activity.** More than 300 pull requests merged across the public `radius-project` repositories in September. A large share of that work was test, release, and continuous integration hardening: Cloud end-to-end coverage for the Environment and deployment lifecycles in ai-extensions, Conventional Commit and release-parity tooling in the Radius repository, and functional tests for `rad upgrade kubernetes`.

**Contributing.** A Recipe is self-contained Bicep or Terraform, which makes [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) one of the easiest places to start contributing. If you want to add support for infrastructure you use, browse the [good first issues](https://aka.ms/radius-first-issues).

## Get involved

Whether you are a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we would love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
