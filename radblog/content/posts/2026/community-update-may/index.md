---
date: "2026-06-01T08:00:00-08:00"
title: "Radius Community Update: May 2026"
linkTitle: "Community Update May 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the May 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams maintain control over how resources are provisioned.

This month brought two releases, a streamlined getting-started experience, early CLI support for the next-generation `Radius.Core` resource types, and automated resource type registration on install.

## Releases

### Radius v0.57.1 (patch release — May 12)

This patch release ensures stability for users on v0.57.0 by pinning key dependencies to known-good versions:

- **Deployment Engine pinned to v0.56** — A bug in the v0.57.0 engine could cause deployment failures; this pin ensures your deployments continue to succeed reliably.
- **Bicep CLI pinned to v0.42.1** — A breaking change in Bicep v0.43+ rejected local registry targets, which prevented users from using local Bicep registries for storing and sharing infrastructure templates.
- **Terraform version pinned** — Prevents unexpected behavior from upstream Terraform changes affecting your infrastructure provisioning.

For full details, see the [v0.57.1 release notes](https://github.com/radius-project/radius/releases/tag/v0.57.1).

### Radius v0.58.0 (May 26)

This is the latest major release of Radius. Here are the highlights and what they mean for you:

#### Faster getting started

- **`rad install` now automatically creates a default resource group and environment** — Previously, after installing Radius you had to manually run additional commands to set up a resource group (a logical container for your app resources) and an environment (the target where your app runs). Now installation takes you straight to a ready-to-deploy state. ([#11870](https://github.com/radius-project/radius/pull/11870))

- **Breaking change to `rad init`:** The `rad init` command no longer creates a `.rad/rad.yaml` file to track your current application. This simplifies project setup and avoids confusion in multi-app repositories. If you previously relied on implicit app detection, you'll now pass `--application <name>` to commands like `rad deploy`. This makes it explicit which application you're targeting, reducing accidental deployments to the wrong app.

#### Radius Resource Types for Compute platform extensibility

>Note: the new Radius.Core resource types are actively under development and only available now as an early preview.

**CLI support for the new Radius.Core Resource Types** - Radius is introducing a new set of Resource Types under the `Radius.Core` namespace (e.g., `Radius.Core/applications`, `Radius.Core/environments`) that will eventually replace the existing `Applications.Core` types. These new types are available via the `v20250801preview` API surface and represent the next generation of Radius's resource model.

Previously, CLI commands like `rad app list` and `rad app graph` only worked with the older `Applications.Core/applications` type — meaning applications deployed using the new `Radius.Core/applications` type were invisible to the CLI. The new `--preview` flag fixes this by directing commands to operate against `Radius.Core` resources:

- **`rad app graph --preview` and `rad app status --preview`** — View the application graph and check status for apps deployed as `Radius.Core/applications`. ([#11983](https://github.com/radius-project/radius/pull/11983))
- **`rad app show/list/delete --preview`** — List, inspect, and delete applications created with the `Radius.Core/applications` type. ([#11935](https://github.com/radius-project/radius/pull/11935))
- **`rad workspace create --preview`** — Create workspaces that use `Radius.Core/environments`, so you can pair them with the new resource types. ([#11905](https://github.com/radius-project/radius/pull/11905))

**Automated resource type registration** - Radius [Resource Types](https://docs.radapp.io/concepts/resource-types/) defines the resources your applications can use (e.g., containers, databases, message queues). Previously, operators had to manually register each type. Now, all default resource types from the [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository are registered automatically when you install Radius, so you can start deploying immediately with Recipes linked to the types. ([#11911](https://github.com/radius-project/radius/pull/11911))

#### Additional improvements

- **Fixed Helm chart Terraform binary path** — Users mounting a custom Terraform binary via Helm values can now rely on the correct path being used at runtime. ([#11880](https://github.com/radius-project/radius/pull/11880))
- **Fixed `rad resource-type list` showing incomplete results** — All registered resource types now appear correctly when listing available types. ([#11933](https://github.com/radius-project/radius/pull/11933))

For full details, see the [v0.58.0 release notes](https://github.com/radius-project/radius/releases/tag/v0.58.0).

## New contributors

A warm welcome to the new contributors who merged their first PRs in the v0.58.0 release:

- **@officialasishkumar** — [#11557](https://github.com/radius-project/radius/pull/11557)
- **@sethficke** — [#11680](https://github.com/radius-project/radius/pull/11680)
- **@AkashKumar7902** — [#11764](https://github.com/radius-project/radius/pull/11764)

Thank you for your contributions! 🎉

## Community spotlight

We'd like to highlight [Dan Rios's blog post on Project Radius](https://rios.engineer/project-radius/). Dan is a Microsoft MVP who walks through setting up Radius from scratch and deploying a sample application. If you're evaluating Radius for your team, this is a great real-world perspective on what the onboarding experience looks like. Thank you, Dan, for sharing your journey with the community!

## Get involved

Whether you're a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we'd love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stay updated:** Join our monthly community meeting (sign up via the [Radius Google Group](https://groups.google.com/g/radapp_io)) or subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
