---
date: "2026-07-06T07:00:00-07:00"
title: "Radius Community Update: June 2026"
linkTitle: "Community Update June 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the June 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams keep control over how resources are provisioned.

This month delivered the v0.59.0 release, which continues the journey toward extensible compute platforms with the new `Radius.Core` Resource Types. The release adds more CLI support for the preview resource model, automatic Gateway setup for route Recipes, and several bug fixes. Looking ahead, the next release will include early work on multi-cluster deployments, simpler Resource Type schemas, and a new set of contributor guides.

## Releases

### Radius v0.59.0 (June 18)

This is the latest release of Radius. Here are the highlights and what they mean for you.

> Note: the new `Radius.Core/*` Resource Types are actively under development and available now only as an early, sparsely documented preview. You can try them with the `--preview` flag on the relevant CLI commands. See the [rad CLI reference](https://docs.radapp.io/reference/cli/) for details.

#### CLI support for the new Radius.Core Resource Types

Radius is introducing a new set of Resource Types under the `Radius.Core` namespace (for example, `Radius.Core/applications` and `Radius.Core/environments`) that will eventually replace the existing `Applications.Core` types. These are served through the `v20250801preview` API surface and represent the next generation of the Radius resource model.

Until now, commands like `rad app graph` and `rad app status` operated only on the existing `Applications.Core/applications` type, so Applications deployed with the new `Radius.Core/applications` type were invisible to the CLI. The `--preview` flag directs commands to operate against `Radius.Core` resources instead:

- **`rad app graph --preview` and `rad app status --preview`** — View the application graph and check status for Applications deployed as `Radius.Core/applications`. ([#11983](https://github.com/radius-project/radius/pull/11983))
- **`rad workspace create --preview`** — Create workspaces that use `Radius.Core/environments`, so you can pair them with the new Resource Types. ([#11905](https://github.com/radius-project/radius/pull/11905))

#### Explicit Kubernetes namespace for new `Radius.Core/environments`

Previously, Environments created with `Applications.Core/environments` created a new Kubernetes namespace on your behalf. That approach did not match enterprise scenarios where namespace creation is managed by cluster administrators. New `Radius.Core/environments` now require you to pass the Kubernetes namespace you want to use for Application deployments, falling back to `default` if none is specified. ([#12045](https://github.com/radius-project/radius/pull/12045))

#### Default Contour Gateway for new `Radius.Compute/routes` Recipes

Radius now sets up Gateway API infrastructure automatically when Contour is installed. `rad install kubernetes` creates a shared `GatewayClass/contour` and `Gateway/radius` in the `radius-system` namespace, and the default `Radius.Compute/routes` Recipe is pre-configured to attach route resources to this managed Gateway. Applications no longer need to define their own Gateway resource in the default path. ([#11995](https://github.com/radius-project/radius/pull/11995))

#### Deprecation warning for `rad run` with extensible Environments

The `rad run` command is not supported for Environments configured with the new extensible `Radius.Core/environments` model and is planned for deprecation. `rad run` depends on Kubernetes-specific behaviors such as log streaming and port forwarding, which are incompatible with the platform-agnostic design of the new architecture. Instead, use `rad deploy` and rely on the native tooling of your chosen compute platform to access logs and connectivity. ([#12042](https://github.com/radius-project/radius/pull/12042))

#### Bug fixes

- **Fixed the Helm chart Terraform binary path** — The pre-mounted Terraform binary path in the Helm chart did not match what the runtime expected, causing Radius to silently re-download Terraform on every cold start. The paths are now aligned so the pre-mounted binary is used. ([#11880](https://github.com/radius-project/radius/pull/11880))
- **Fixed Recipe pack OCI tags** — Core Resource Type Recipes now use the full semantic version for OCI tags instead of the version channel, aligning with the kube-recipes publishing pipeline. ([#12027](https://github.com/radius-project/radius/pull/12027))
- **Aligned `rad env create` and `rad env update` flags** — `rad env create` now accepts cloud provider flags such as `--azure-subscription-id` and `--aws-region`, and `rad env update` now accepts `--namespace`, unifying the options across both commands. ([#11774](https://github.com/radius-project/radius/pull/11774))
- **Honor `x-ms-client-flatten` in the Bicep type generator** — The generator now flattens the ARM `.properties.` envelope, so you write `container.container.image` instead of `container.properties.container.image` in Bicep templates. ([#12001](https://github.com/radius-project/radius/pull/12001))

For full details, see the [v0.59.0 release notes](https://github.com/radius-project/radius/releases/tag/v0.59.0).

## Upcoming features

The following work merged to `main` after the v0.59.0 release and is not yet part of a published release. It offers a preview of what is coming next.

- **Multi-cluster deployment (v1)** — Until now, Radius always ran Recipes against the same Kubernetes cluster it was installed in. A new `ClusterAccessResolver` seam decides, per Recipe execution, which cluster to deploy to and how to authenticate, and both the Bicep and Terraform Recipe engines now consume that resolved connection instead of assuming the in-cluster config. This first version honors a kubeconfig injected through the `RADIUS_TARGET_KUBECONFIG` environment variable, so you can target an external cluster today. A later phase will add a named-cluster experience (`aws.eksClusterName` / `azure.aksClusterName`) that acquires cloud credentials for you. ([#12106](https://github.com/radius-project/radius/pull/12106))
- **Less boilerplate in Resource Type schemas** — Every Radius Resource Type needs common properties such as `environment`, `application`, and `connections`, and authors previously had to declare them in every schema by hand. Radius now merges these base properties into all Resource Type schemas automatically, so a new type only declares its own properties while staying consistent with server-side validation. ([#12223](https://github.com/radius-project/radius/pull/12223), [#12252](https://github.com/radius-project/radius/pull/12252))
- **Direct module support for Recipes** — Today a Terraform or Bicep module used as a Recipe must be wrapped to add a `context` input and a structured `result` output, which blocks using community modules such as those from the Terraform Registry or Azure Verified Modules directly. Recipes can now point their `source` straight at a standard module: Radius resolves `{{context.*}}` parameters, runs the module through the existing driver, and maps its outputs back to Resource Type properties through a new `outputs` field. Existing wrapped Recipes keep working unchanged. ([#12109](https://github.com/radius-project/radius/pull/12109))
- **Optional NetworkPolicy for the control plane** — A new opt-in `networkPolicies.enabled` Helm value locks down ingress to the `radius-system` control-plane namespace so that arbitrary workloads in the cluster can no longer reach UCP and the resource providers directly, while still allowing traffic between Radius components and from the Kubernetes API server. Enforcement requires a NetworkPolicy-capable CNI such as Calico or Cilium. ([#12208](https://github.com/radius-project/radius/pull/12208))
- **`RADIUS_PREVIEW` environment variable** — Instead of adding `--preview` to every command while trying the new `Radius.Core` Resource Types, you can now set `RADIUS_PREVIEW=true` once to turn on preview mode for all commands. The `--preview` flag still takes precedence when both are set. ([#12160](https://github.com/radius-project/radius/pull/12160))
- **Clearer errors for unregistered Resource Types** — Deploying a custom Resource Type that was never registered used to fail with a misleading `not supported by location "global"` message. Radius now reports the real problem — that the Resource Type is not registered — and tells you to register it before deploying resources of that type. ([#12183](https://github.com/radius-project/radius/pull/12183))
- **Preserve Helm values on upgrade** — `rad upgrade kubernetes` previously reset stored Helm values (for example, `global.azureWorkloadIdentity.enabled`) back to chart defaults on every upgrade. It now starts from the new chart defaults, replays the values you set on the previous release, and then applies any new `--set` overrides, with a `--reset-values` flag to opt out. ([#12029](https://github.com/radius-project/radius/pull/12029))


## Ecosystem and docs

Activity continued across the wider Radius ecosystem this month:

- **resource-types-contrib** added the `Radius.Compute/containerImages` Resource Type with a Kubernetes Terraform Recipe ([#151](https://github.com/radius-project/resource-types-contrib/pull/151)) and fixed a double-encoding bug in the `Security/secrets` Kubernetes Terraform Recipe ([#178](https://github.com/radius-project/resource-types-contrib/pull/178)).
- **Contributor guides** — A new series of guides covering prerequisites, building the rad CLI, testing, schema changes, and local debugging landed in the radius repository, making it easier to get started. ([#12174](https://github.com/radius-project/radius/pull/12174)–[#12180](https://github.com/radius-project/radius/pull/12180))

## Get involved

Whether you are a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we would love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stay updated:** Join our monthly community meeting (sign up via the [Radius Google Group](https://groups.google.com/g/radapp_io)) or subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
