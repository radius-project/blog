---
date: "2026-07-31T07:00:00-07:00"
title: "Radius Community Update: July 2026"
linkTitle: "Community Update July 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the July 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams keep control over how resources are provisioned.

July was a busy month across the whole organization. The v0.60.0 release candidate shipped, the new `Radius.Core` preview resource model reached more of the CLI, the application graph gained icons and richer relationships, and a new `ai-extensions` repository brought a Radius canvas experience to GitHub Copilot. Community contributions also picked up, with five people landing their first Radius pull requests.

## Releases

### Radius v0.60.0-rc1 (July 22)

The release candidate for v0.60.0 is available ([#12466](https://github.com/radius-project/radius/pull/12466)). It gathers the work that landed after v0.59.0, including multi-cluster deployment groundwork, direct module support for Recipes, the optional control-plane NetworkPolicy, and the `RADIUS_PREVIEW` environment variable. See the [v0.60.0-rc1 release notes](https://github.com/radius-project/radius/releases/tag/v0.60.0-rc1) for the full changelog.

## Highlights

### More CLI coverage for the preview resource model

Radius continues to build out the `Radius.Core` Resource Types that will eventually replace `Applications.Core`. You can opt into them with the `--preview` flag, or by setting `RADIUS_PREVIEW=true` once for all commands.

- **`rad install kubernetes --preview`** installs the control plane configured for the preview resource model ([#12504](https://github.com/radius-project/radius/pull/12504)).
- **`rad deploy -a --preview`** resolves the Application by name against `Radius.Core/applications` ([#12507](https://github.com/radius-project/radius/pull/12507)).
- **`rad env create --preview --recipe-packs`** lets you attach Recipe packs to an Environment at creation time ([#12531](https://github.com/radius-project/radius/pull/12531)), and `rad env update` now honors `RADIUS_PREVIEW` as well ([#12371](https://github.com/radius-project/radius/pull/12371)).
- **Reference documentation** for the new Resource Types is now generated from the Bicep extension, so preview types show up in the docs alongside the built-in ones ([#12545](https://github.com/radius-project/radius/pull/12545), [#12558](https://github.com/radius-project/radius/pull/12558)).

### A more informative application graph

The application graph became easier to read this month. Resource Types can now carry icons, which are synced and registered for built-in types and rendered in both the static and deployed graphs ([#12339](https://github.com/radius-project/radius/pull/12339), [#12351](https://github.com/radius-project/radius/pull/12351), [#12362](https://github.com/radius-project/radius/pull/12362), [#12396](https://github.com/radius-project/radius/pull/12396)). Edges now show `dependsOn` relationships in addition to connections ([#12479](https://github.com/radius-project/radius/pull/12479)), Azure resources link out to the Azure portal ([#12295](https://github.com/radius-project/radius/pull/12295)), and properties marked `x-radius-sensitive` are excluded from the static graph so secrets are not surfaced ([#12448](https://github.com/radius-project/radius/pull/12448)).

### Deploying Radius applications from a repository

Work on running Radius directly from a Git repository moved forward. A repo-based deploy workflow with reusable extension templates and composite actions landed ([#12348](https://github.com/radius-project/radius/pull/12348)), along with custom Recipe pack and delete workflows ([#12367](https://github.com/radius-project/radius/pull/12367)), a pluggable storage backend and an OCI state archive for control-plane state ([#12333](https://github.com/radius-project/radius/pull/12333), [#12364](https://github.com/radius-project/radius/pull/12364)), and GHCR authentication for `rad startup` and `rad shutdown` ([#12472](https://github.com/radius-project/radius/pull/12472), [#12493](https://github.com/radius-project/radius/pull/12493)).

### Fixes and platform support

- **Windows ARM64 builds** are now produced for the rad CLI ([#12512](https://github.com/radius-project/radius/pull/12512)).
- **Registry credentials** are injected into the application deployment instead of provisioning a control-plane Secret ([#12510](https://github.com/radius-project/radius/pull/12510)).
- **`rad init`** progress display and Ctrl-C handling were fixed so interrupting the command behaves predictably ([#12540](https://github.com/radius-project/radius/pull/12540)).
- **Gateways** no longer hang when a Contour HTTPProxy route child is deployed before its root ([#12282](https://github.com/radius-project/radius/pull/12282)).
- **In-cluster image builds** now run with bounded concurrency so a burst of builds cannot exhaust cluster resources ([#12547](https://github.com/radius-project/radius/pull/12547)).

### Resource Types and Recipes

The `resource-types-contrib` repository adopted the Recipe pack model across the portable data types, adding Azure Recipe packs for MySQL, Kafka, MongoDB, RabbitMQ, PostgreSQL, SQL Server, and search ([#200](https://github.com/radius-project/resource-types-contrib/pull/200)–[#206](https://github.com/radius-project/resource-types-contrib/pull/206)), plus new `Radius.Data/redisCaches`, `Radius.AI/models`, and object storage types ([#210](https://github.com/radius-project/resource-types-contrib/pull/210), [#212](https://github.com/radius-project/resource-types-contrib/pull/212), [#217](https://github.com/radius-project/resource-types-contrib/pull/217)). A default pack of Kubernetes Recipes authored in Bicep also landed ([#239](https://github.com/radius-project/resource-types-contrib/pull/239)), and `Radius.Compute/containerImages` gained a Bicep Recipe with scoped registry support ([#251](https://github.com/radius-project/resource-types-contrib/pull/251), [#12361](https://github.com/radius-project/radius/pull/12361)).

### Radius in GitHub Copilot

The new [ai-extensions](https://github.com/radius-project/ai-extensions) repository packages Radius as a Copilot plugin with a visual canvas for modeling and deploying applications. July brought the initial marketplace packaging ([#17](https://github.com/radius-project/ai-extensions/pull/17)), a move to React Flow for graph rendering ([#138](https://github.com/radius-project/ai-extensions/pull/138)), source-code references on graph nodes ([#59](https://github.com/radius-project/ai-extensions/pull/59)), and end-to-end Azure OIDC deployment support ([#163](https://github.com/radius-project/ai-extensions/pull/163)).

## Community

**Step challenge sample.** Will Velida published [step-challenge](https://github.com/willvelida/step-challenge), a sample application that shows Dapr, Radius, and Drasi working together. Radius describes the four .NET and Vue services, their Dapr components, and an in-cluster Postgres database as a single deployable unit in `infra/app.bicep`, so the same definition runs on a local kind cluster or on Azure with one `rad deploy`. Dapr handles pub/sub, cron bindings, and secrets between the services, while Drasi watches Postgres over logical replication and turns database changes into live contest events. It is a good end-to-end read if you want to see Radius composed with other cloud-native projects.

**Welcome to our new contributors.** Five people made their first contribution to a Radius repository this month:

- [@AzureMike](https://github.com/AzureMike) documented and implemented the `Radius.Compute/containerImages` Bicep Recipe, then followed up with several fixes ([#12372](https://github.com/radius-project/radius/pull/12372), [#254](https://github.com/radius-project/resource-types-contrib/pull/254), [#270](https://github.com/radius-project/resource-types-contrib/pull/270))
- [@adam-obrebski](https://github.com/adam-obrebski) added a Kubernetes Redis Recipe in both Bicep and Terraform ([#235](https://github.com/radius-project/resource-types-contrib/pull/235))
- [@Alec13355](https://github.com/Alec13355) added global list-all-resources support ([#12481](https://github.com/radius-project/radius/pull/12481))
- [@gergo-hortobagyi](https://github.com/gergo-hortobagyi) fixed a Gateway deployment hang ([#12282](https://github.com/radius-project/radius/pull/12282))
- [@preko-p](https://github.com/preko-p) improved the error message for a missing Terraform configuration ([#12070](https://github.com/radius-project/radius/pull/12070))

**Docs.** The documentation site got a use-case-driven homepage, a consolidated Contributing section, and a Roadmap link in the top navigation ([#1963](https://github.com/radius-project/docs/pull/1963), [#1958](https://github.com/radius-project/docs/pull/1958), [#1961](https://github.com/radius-project/docs/pull/1961)).

## Get involved

Whether you are a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we would love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stay updated:** Join our monthly community meeting (sign up via the [Radius Google Group](https://groups.google.com/g/radapp_io)) or subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
