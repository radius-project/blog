---
date: "2026-08-05T07:00:00-07:00"
title: "Radius Community Update: July 2026"
linkTitle: "Community Update July 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the July 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams keep control over how resources are provisioned.

July focused on making the pieces you work with every day easier to use: the preview resource model became usable across a full install-to-deploy loop, the application graph got clearer about what your Application contains, and the catalog of ready-to-use Recipes grew considerably. Five people also made their first contribution to Radius this month.

## Upcoming features

The following work merged to `main` in July and is not yet part of a published release. It offers a preview of what is coming next.

### CLI support for the new Radius.Core Resource Types

Radius is building a new generation of Resource Types under the `Radius.Core` namespace, which will eventually replace today's `Applications.Core` types. Because both models exist side by side while the work is in progress, the rad CLI needs to know which one you mean. Add `--preview` to an individual command, or export `RADIUS_PREVIEW=true` in your shell so every command in that session uses the new types. The `--preview` flag wins when both are set.

Last month `rad app graph`, `rad app status`, and `rad workspace create` learned about the new types. In July the rest of the install-to-deploy loop followed:

- **`rad install kubernetes --preview`** — Install the control plane configured for the new Resource Types, so you no longer need a separately prepared cluster to try them.
- **`rad env create --preview`** — Create a `Radius.Core/environments` Environment. It now also accepts `--recipe-packs`, so you can attach a curated set of Recipes when you create the Environment instead of registering them one at a time afterward.
- **`rad env update --preview`** — Update those Environments, and honor `RADIUS_PREVIEW` the same way the other commands do.
- **`rad deploy -a <name> --preview`** — Resolve the `-a` Application name against `Radius.Core/applications` so you can deploy into an Application created with the new model.

Reference documentation for the new types is now generated from the Bicep extension, so they are documented alongside the existing types as they evolve.

### Application graph enhancements

The application graph shows what your Application is actually made of — the Containers, databases, and other resources Radius deployed, and how they relate. Run `rad app graph -a <name>` for the deployed view, or `rad app graph ./app.bicep` to build the modeled graph before you deploy. Four improvements landed this month:

- **Icons for Resource Types.** Each type renders with its own icon, so a database, a message broker, and a Container are distinguishable at a glance instead of by reading labels.
- **Dependency edges.** The graph draws `dependsOn` relationships in addition to connections, so you can see the provisioning order Radius followed, not just which services talk to each other.
- **Azure portal links.** Azure resources in the graph link to the deployed resource in the Azure portal, so you can jump from the graph to metrics or configuration.
- **Sensitive properties hidden.** Properties a Resource Type marks as sensitive are omitted from the graph, so you can share `rad app graph` output without exposing credentials.

### Fixes and platform support

- The rad CLI is now built for Windows on ARM64, so it runs natively on ARM-based Windows machines.
- `rad init` reports progress correctly and exits cleanly when you press Ctrl-C, instead of leaving a partially drawn prompt behind.
- Gateways no longer hang when a route is deployed before the Gateway it attaches to, a timing problem that could stall an otherwise valid deployment.
- Building Container images inside the cluster now runs a bounded number of builds at a time, so a large Application cannot exhaust cluster resources by starting every build at once.

### More Resource Types and Recipes

A Recipe is the infrastructure definition a platform engineer registers so developers can request a database or a message queue without writing infrastructure code themselves. A Recipe pack groups Recipes together so an Environment can adopt a whole curated set at once, using `rad env create --preview --recipe-packs`.

July added a lot to that catalog in [resource-types-contrib](https://github.com/radius-project/resource-types-contrib):

- **Azure Recipe packs** for MySQL, PostgreSQL, SQL Server, MongoDB, Redis, Kafka, RabbitMQ, search, and object storage, so an Environment on Azure starts from a working set of Recipes instead of an empty catalog.
- **A default Kubernetes Recipe pack** written in Bicep, giving the same coverage for clusters with no cloud provider configured.
- **New Resource Types** for Redis caches, AI models, and object storage.
- **A Bicep Recipe for `Radius.Compute/containerImages`**, the type that builds a Container image from your source code, including support for scoped container registries.

Recipes and Resource Types are one of the easiest places to start contributing, because a Recipe is self-contained Bicep or Terraform. If you want to add support for infrastructure you use, browse the [good first issues](https://aka.ms/radius-first-issues).

## Community

**Step challenge sample.** Will Velida published [step-challenge](https://github.com/willvelida/step-challenge), a sample application that shows Dapr, Radius, and Drasi working together. Radius describes the four .NET and Vue services, their Dapr components, and an in-cluster Postgres database as a single deployable unit in `infra/app.bicep`, so the same definition runs on a local kind cluster or on Azure with one `rad deploy`. Dapr handles pub/sub, cron bindings, and secrets between the services, while Drasi watches Postgres over logical replication and turns database changes into live contest events. It is a good end-to-end read if you want to see Radius composed with other cloud-native projects.

**Welcome to our new contributors.** Five people made their first contribution to a Radius repository this month:

- [@AzureMike](https://github.com/AzureMike) designed and built the Bicep Recipe for `Radius.Compute/containerImages`, then kept improving it with fixes for missing image tags and Docker Hub logins
- [@adam-obrebski](https://github.com/adam-obrebski) contributed a Kubernetes Redis Recipe in both Bicep and Terraform
- [@Alec13355](https://github.com/Alec13355) added a way to list resources across all Resource Groups in one command
- [@gergo-hortobagyi](https://github.com/gergo-hortobagyi) tracked down and fixed the Gateway deployment hang described above
- [@preko-p](https://github.com/preko-p) made the error you get from a missing Terraform configuration explain what is actually wrong

**Docs.** The [documentation site](https://docs.radapp.io/) has a new homepage organized around what you are trying to do rather than how Radius is structured, a consolidated Contributing section that brings the guidance for all repositories into one place, and a Roadmap link in the top navigation.

## Get involved

Whether you are a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we would love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stay updated:** Join our monthly community meeting (sign up via the [Radius Google Group](https://groups.google.com/g/radapp_io)) or subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
