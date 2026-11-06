---
date: "2026-11-06T07:00:00-08:00"
title: "Radius Community Update: October 2026"
linkTitle: "Community Update October 2026"
author: "Radius Maintainers"
type: blog
---

Welcome to the October 2026 Radius community update! [Radius](https://radapp.io/) is an open-source cloud-native application platform that helps developers define, deploy, and manage applications across any cloud or on-premises environment. It acts as an abstraction layer between your application and your infrastructure, letting you focus on building your app while platform teams keep control over how resources are provisioned.

October brought Radius v0.62.0, the release where the `Radius.Core` resource model becomes the default for the CLI and the `--preview` flag is no longer needed. It also brought five releases of the Radius plugin for the GitHub Copilot app, the first AWS Recipe pack, and a lot of groundwork for AWS. Read on for what landed, what is coming next, and where to find the Radius team at KubeCon.

## Releases

### Radius v0.62.0 (October 27)

#### `Radius.Core` is now the default for the CLI

Radius v0.60.0 introduced the `Radius.*` Resource Types as a preview behind the `--preview` flag. In v0.62.0, `rad init`, `rad workspace create`, `rad env`, `rad app`, and `rad resource list` target the `Radius.Core` resource model by default, and `rad resource expose` and `rad resource logs` target `Radius.Compute/containers`. You no longer pass `--preview` to work with Environments and Applications built on the new Resource Types.

As part of this change, the `rad recipe register`, `rad recipe unregister`, `rad recipe list`, and `rad recipe show` commands are removed, since Recipes are now provided to an Environment through Recipe packs. Legacy Azure Container Instances support is also removed. If your scripts pass `--preview` or call the `rad recipe` commands, update them before you upgrade.

#### A default Kubernetes Recipe pack

Radius now embeds a pinned copy of the [Kubernetes Recipe pack](https://github.com/radius-project/resource-types-contrib/tree/main/recipe-packs/kubernetes) from resource-types-contrib and builds the default Recipe pack from it. New Environments get a working set of Recipes out of the box, so you can deploy an Application to Kubernetes without first finding and attaching a pack yourself.

#### Store Terraform Recipe state in S3 or Azure Blob Storage

Until now, Radius stored Terraform Recipe state only in Kubernetes Secrets. Cloud backends are supported for **new Environments only**: create a new `Radius.Core/terraformSettings` resource with a `backend` pointing to an existing S3 bucket or Azure Blob Storage container, then reference its ID from the new Environment's `properties.terraformSettings` before deploying Applications. Existing settings cannot acquire a backend, and changing an existing deployment's settings reference does not migrate its state and can orphan its infrastructure. For example:

```bicep
resource settings 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 'terraform-settings'
  location: 'global'
  properties: {
    backend: {
      type: 's3'
      bucket: 'company-terraform-state'
      region: 'us-east-1'
      keyPrefix: 'production/radius'
    }
  }
}
```

Radius authenticates to the backend with the AWS or Azure credentials you already registered, so you don't add another set of credentials to the settings. Each Terraform-backed resource gets its own stable state file under the required `keyPrefix`, S3 uses native state locking, and Azure Blob Storage uses lease locking. Once a backend is configured, its location can't be changed or removed, which protects existing state from being orphaned. If you don't configure a backend, Radius keeps using Kubernetes. Learn more in the [Terraform state docs](https://docs.radapp.io/management/terraform-state/).

#### Version-pinned Helm chart images

The Helm chart now pins Radius component images to the full release version. Restarting a pod no longer picks up a later patch implicitly, so the version you run is the version you installed. Upgrade the chart to receive patched images. Explicit `global.imageTag`, component tag, and image overrides keep working as before.

#### Fewer API server requests on idle clusters

Radius workers poll their queue for new work every 200 ms, which accounts for much of the API server traffic on a small or quiet cluster. A new `workerServer.dequeueInterval` Helm value for UCP, the Applications RP, and the Dynamic RP lets you poll less often. Workers now poll again right after picking up an operation, so a longer interval doesn't slow down bursts of deployments.

#### Reliability improvements

Many retry and robustness fixes make the CLI and deployments more resilient to transient failures, covering Bicep Recipe downloads, Terraform provider discovery, API server reads, and managed Secret deletion. Azure resource deletion now selects supported API versions and deletes resources in dependency order. Radius also warns about Resource Type version skew before a deployment, and supports digest-pinned Bicep Recipe sources.

Review the [v0.62.0 release notes](https://github.com/radius-project/radius/releases/tag/v0.62.0) and the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/) before you start, and remember that only incremental version upgrades are supported.

### Recipes and Resource Types

The [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) catalog gained its first AWS Recipe pack, [`aws-eks`](https://github.com/radius-project/resource-types-contrib/pull/442). It maps `Radius.Data/mySqlDatabases` to a new Bicep Recipe that creates an encrypted, private Amazon RDS for MySQL instance in your EKS cluster's network, and maps the `tls` property to the RDS `require_secure_transport` setting. Containers, persistent volumes, Secrets, Routes, and container images use the Kubernetes Recipes because they run on the EKS cluster itself. MySQL is the only AWS managed service in the pack so far.

## Radius plugin for the GitHub Copilot app

The `radius` plugin that powers Radius Canvas in the [GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app) shipped five releases in October, from [radius@0.2.1](https://github.com/radius-project/ai-extensions/releases/tag/radius%400.2.1) to [radius@0.4.0](https://github.com/radius-project/ai-extensions/releases/tag/radius%400.4.0). Highlights include:

- **Graphs before Environments.** You can generate the Application graph before you select or create a deployment Environment.
- **Models that keep up with Radius.** After a plugin update moves to a newer Radius version, the plugin regenerates the Application model and updates the Radius extension pin in `.radius/bicepconfig.json` when modeling wrote that pin.
- **Clearer deployment failures.** The deployed graph shows each failed resource's own deployment error, and a **Refresh** button lets you retry modeling after you fix a problem outside the repository.
- **Predictable deployments.** Deploy and delete workflows install the pinned stable Radius release instead of the latest unreleased `edge` build. Starting with radius@0.4.0, you can select a specific Radius release, including a release candidate, through `RADIUS_RELEASE_OVERRIDE`.
- **Safer credentials.** Model validation fails when a Bicep credential-safety rule is turned off, and known credentials are redacted from workflow and control-plane diagnostics before they are displayed.

Radius Canvas is in preview. Try it from the [how-to guide](https://docs.radapp.io/integrations/github-copilot-app/canvas-extension/) and tell us what you think by [opening an issue](https://github.com/radius-project/ai-extensions/issues/new/choose).

## Upcoming features

The following work merged to `main` in October after the v0.62.0 release and is not part of it. It offers a preview of what is coming next.

- **AWS console links in the Application graph.** The graph already links Azure resources to the Azure portal. AWS resources created by Bicep or Terraform Recipes now link to their service's page in the AWS console, in the resource's region, and `rad app graph` shows the link. ([#13464](https://github.com/radius-project/radius/pull/13464))
- **Clear errors for unsupported AWS resource types.** AWS types that Cloud Control can't fully manage, such as legacy, deprecated, read-only, and create-only types, now fail with an error that names the type and explains what to do, instead of a raw Cloud Control error. ([#13466](https://github.com/radius-project/radius/pull/13466))
- **Quieter AWS redeploys.** Radius no longer sends changes to AWS when you redeploy an unchanged template. Values that AWS reorders or normalizes, such as tags, subnet IDs, or an RDS engine version of `8.4` reported back as `8.4.11`, are treated as unchanged. Before, these redeploys could upgrade and reboot an RDS instance. ([#13499](https://github.com/radius-project/radius/pull/13499))
- **Clean JSON from the CLI.** With `-o json`, status messages and diagnostics go to stderr, so stdout holds only parseable JSON for tools like `jq`. Application and Environment list commands also return an empty JSON array when there is nothing to list. ([#13580](https://github.com/radius-project/radius/pull/13580), [#13540](https://github.com/radius-project/radius/pull/13540))

## Radius at KubeCon

Heading to KubeCon + CloudNativeCon North America 2026 in Salt Lake City? Come meet the Radius team and learn how Radius helps developers and platform engineers simplify cloud-native application development and deployment. Here's where you can find us:

- **Microsoft Booth Theater session: _From Code to Cloud: Give AI Agents a Shared Understanding of the Application_**
  - Tuesday, November 10, 5:05–5:25 PM
  - Microsoft Azure booth
- **Radius at the CNCF Project Pavilion**
  - Wednesday, November 11, 10:15 AM–1:25 PM
  - Kiosk P-1B, Solutions Showcase, Level 1, Hall 5

Whether you're exploring AI-assisted development, application modeling, or platform engineering, stop by to see Radius in action, share your feedback, and help shape what's next for the project. See you in Salt Lake City!

## Community

**Blog.** [Day Two: Reviewing AI-Generated Changes](https://blog.radapp.io/posts/2026/10/19/day-two-reviewing-ai-generated-changes/) by [Nithya Subramanian](https://github.com/nithyatsu) continues the Application graph series. It follows a pull request that adds an order history page to the Online Boutique sample, and shows how the graph diff in Radius Canvas helps you see which services and dependencies changed before you review the code.

**Docs.** The Radius documentation now covers [Terraform state backends](https://docs.radapp.io/management/terraform-state/), and CLI examples across the docs no longer use the `--preview` flag.

**New contributors.** Welcome to [@itpropro](https://github.com/itpropro), who made the worker dequeue interval configurable and fixed a case where a DeploymentTemplate spec change made during a deployment was never applied, and to [@allexistence](https://github.com/allexistence), who corrected the custom install location example in the CLI contributing guide.

**Activity.** More than 550 pull requests merged across the public `radius-project` repositories in October. Alongside the features above, much of that work hardened the release process, including build provenance attestations for Radius release artifacts, dashboard images, and published Bicep Recipes.

**Contributing.** A Recipe is self-contained Bicep or Terraform, which makes [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) one of the easiest places to start contributing. If you want to add support for infrastructure you use, browse the [good first issues](https://aka.ms/radius-first-issues).

## Get involved

Whether you are a developer looking to simplify cloud deployments or a platform engineer building golden paths for your team, we would love to have you join the Radius community:

- **Get started:** Follow the [Radius Tutorial](https://docs.radapp.io/tutorials/) to deploy your first app in minutes
- **Shape the future:** Check out the [Radius roadmap](https://aka.ms/radius-roadmap) and vote on features that matter to you
- **Join the conversation:** Ask questions and share ideas on the [Radius Discord server](https://aka.ms/radius/discord)
- **Stuck on something:** Raise an issue in the [Radius repository](https://github.com/radius-project/radius/issues/new/choose)
