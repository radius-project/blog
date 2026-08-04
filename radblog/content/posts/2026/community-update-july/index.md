---
date: "2026-07-31T07:00:00-07:00"
title: "Radius Community Update: July 2026"
linkTitle: "Community Update July 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the July 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams keep control over how resources are provisioned.

July focused on making the pieces you work with every day easier to use: the preview resource model became usable across a full install-to-deploy loop, the application graph got clearer about what your Application contains, and the catalog of ready-to-use Recipes grew considerably. Five people also made their first contribution to Radius this month.

## Upcoming features

The following work merged to `main` in July and is not yet part of a published release. It offers a preview of what is coming next.

### More CLI coverage for the preview resource model

Radius is building a new generation of Resource Types under the `Radius.Core` namespace, which will eventually replace today's `Applications.Core` types. Because both models exist side by side while the work is in progress, the rad CLI needs to know which one you mean. You opt into the new model with the `--preview` flag on a single command, or by setting `RADIUS_PREVIEW=true` once so every command uses it.

In July that preview mode reached more of the CLI. You can now install the control plane, deploy an Application by name, and create or update an Environment against the new model, so a full install-to-deploy loop works end to end without switching back to the old types. Creating an Environment also accepts Recipe packs directly, which means you can point a new Environment at a curated set of Recipes in one step instead of registering them one at a time afterward. Reference documentation for these types is now generated automatically from the Bicep extension, so the new types are documented alongside the existing ones as they evolve.

### A clearer application graph

The application graph is how you see what your Application is actually made of: the Containers, databases, and other resources Radius deployed, and how they connect. Several changes this month make that view easier to interpret.

Resource Types can now carry an icon, so a database, a message broker, and a Container are distinguishable at a glance rather than by reading labels. The graph also draws explicit dependency edges, not just connections, so you can tell when one resource had to be provisioned before another. Azure resources link straight to the Azure portal for the deployed resource. Finally, properties that a Resource Type marks as sensitive are left out of the graph entirely, so viewing or sharing your application graph does not expose credentials.

### Fixes and platform support

- The rad CLI is now built for Windows on ARM64, so it runs natively on ARM-based Windows machines.
- When your Application needs registry credentials to pull an image, Radius passes them through the deployment instead of creating a Secret in the control plane, keeping application credentials with the Application.
- `rad init` reports progress correctly and exits cleanly when you press Ctrl-C, instead of leaving a partially drawn prompt behind.
- Gateways no longer hang when a route is deployed before the Gateway it attaches to, a timing problem that could stall an otherwise valid deployment.
- Building Container images inside the cluster now runs a bounded number of builds at a time, so a large Application cannot exhaust cluster resources by starting every build at once.

### More Resource Types and Recipes

Recipes are the infrastructure definitions a platform engineer registers so developers can request a database or a message queue without writing the infrastructure code themselves. A Recipe pack groups those Recipes together so an Environment can adopt a whole curated set at once.

The [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository moved its portable data types onto this model in July, publishing Azure Recipe packs for MySQL, PostgreSQL, SQL Server, MongoDB, Redis, Kafka, RabbitMQ, search, and object storage, along with a default pack of Kubernetes Recipes written in Bicep. The practical effect is that a new Environment can start from a working set of Recipes on either Kubernetes or Azure, rather than an empty catalog. The `Radius.Compute/containerImages` type, which builds a Container image from your source code, also gained a Bicep Recipe and support for scoped registries.

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
