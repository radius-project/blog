---
date: "2026-03-19T08:00:00-08:00"
title: "How I Built a Radius Plugin for Headlamp"
linkTitle: "Radius + Headlamp"
author: "[Filipe Revez](https://www.github.com/filipevrevez)"
type: blog
---

Hi, I'm Filipe Revez, and I work at [Millennium bcp](https://millenniumbcp.pt/), Portugal's largest privately owned bank. As some of you may know, Millennium bcp has been an early adopter of Radius — we wrote about our journey in a [case study](https://blog.radapp.io/posts/2023/12/06/case-study-how-millennium-bcp-leverages-radius/) back in 2023, where we shared how we use Radius to go from 8 days to 8 minutes when deploying applications across environments. We also have a few engineers that actively contribute to the Radius ecosystem. Radius has become a key part of the platform we've built for our development teams, enabling them to focus on their applications while our infrastructure teams manage the underlying resources through [Recipes](https://docs.radapp.io/concepts/recipes/) and [Environments](https://docs.radapp.io/concepts/environments/).

As our Radius adoption has grown, so has the need for better visibility into what's deployed and how it's running. The [rad CLI](https://docs.radapp.io/guides/tooling/rad-cli/overview/) and the [Radius Dashboard](https://docs.radapp.io/guides/tooling/dashboard/overview/) are great for individual developers and Radius-specific workflows, but we wanted a unified web-based experience where our teams could browse Radius applications, environments, and resources alongside their Kubernetes workloads — all in one place. That's why I built a [Radius plugin for Headlamp](https://github.com/headlamp-k8s/plugins/tree/main/radius). 

## Why Headlamp?

[Headlamp](https://headlamp.dev/) is an open-source Kubernetes web UI maintained under [Kubernetes SIGs](https://github.com/kubernetes-sigs/headlamp). It runs [in-cluster](https://headlamp.dev/docs/latest/installation/in-cluster) or as a [desktop app](https://headlamp.dev/docs/latest/installation/desktop), and, most importantly for this project, it has a [plugin system](https://headlamp.dev/docs/latest/development/plugins/) that lets you add custom pages, sidebar entries, and resource views without forking the project. For us at Millennium bcp, Headlamp is our de facto Kubernetes UI, so extending it with Radius views was a natural fit for the platform we're building.

## What the Plugin Does

The plugin adds a "Radius" section to the Headlamp sidebar with several views that provide comprehensive visibility into your Radius resources:

- **Overview Dashboard** — A summary of all Radius resources in the cluster with status breakdowns (succeeded, failed, processing, suspended).

  {{< image src="images/radius_overview.png" alt="screenshot of the Headlamp Radius overview dashboard" width="70%" >}}

- **Applications** — Lists all Radius applications, with detail views showing environment configuration, associated resources, and system metadata.

  {{< image src="images/app_detail.png" alt="screenshot of the Headlamp application detail view" width="70%" >}}
  
- **Environments** — Browse Radius environments and their compute configuration.

  {{< image src="images/environments.png" alt="screenshot of the Headlamp environments view" width="70%" >}}

- **Resources** — View resources across all Radius providers (`Applications.Core`, `Applications.Datastores`, `Applications.Messaging`, `Applications.Dapr`) with provisioning state indicators.

  {{< image src="images/resources.png" alt="screenshot of the Headlamp resources view" width="70%" >}}
  
- **Resource Types** — Explore the Radius resource types registered in your cluster, including API versions, schemas, and properties.

  {{< image src="images/rt_details.png" alt="screenshot of the Headlamp resource types view" width="70%" >}}

Each resource gets a status label that maps Radius provisioning states to Headlamp's built-in visual indicators, making it easy to spot issues at a glance. For a team like ours that manages a large and diverse application portfolio spanning multiple environments, having this unified view has significantly reduced the time we spend tracking down application states and debugging deployment issues.

## How It Works Under the Hood

One of the things that made this plugin straightforward to build is that Radius exposes its [UCP (Universal Control Plane) API](https://docs.radapp.io/reference/api/api-ucp/) through the Kubernetes API Aggregation Layer. That means the plugin doesn't need any extra proxies or API endpoints — it talks to Radius through the same Kubernetes API server that Headlamp is already connected to.

The flow is simple:

1. **Headlamp** connects to your Kubernetes cluster as usual.
2. The **plugin** registers sidebar entries and routes for the Radius views.
3. When you navigate to a Radius view, it makes API calls through the Kubernetes API Aggregation Layer to the **Radius UCP**.
4. The UCP returns data about applications, environments, resources, and resource types, and the plugin renders it.

If you can access your cluster with Headlamp, you can see your Radius resources — no additional setup required on the API side.

## Trying It Out

To use the plugin, you'll need:

1. A Kubernetes cluster with [Radius installed](https://docs.radapp.io/guides/operations/kubernetes/install/).
2. [Headlamp](https://headlamp.dev/docs/latest/installation/) installed (in-cluster or desktop).
3. The Radius plugin installed in Headlamp (available on [Artifact Hub](https://artifacthub.io/packages/headlamp/headlamp-plugins/headlamp_radius)).

{{< image src="images/headlamp_plugin.png" alt="screenshot of the Headlamp Radius plugin" width="70%" >}}

You can install the plugin directly from Headlamp's plugin catalog or manually from Artifact Hub. Once installed, you'll see the "Radius" section in the sidebar. From there you can browse apps, environments, resources, and resource types — all from the same UI you use for the rest of your cluster.

## What I'd Like to Build Next

This is the first version and there are a few things I'd like to improve:

- **Enhanced sidebar navigation** - The current view is functional but could be more intuitive with nested sidebar entries, collapsible sections, and resource counts. I'm also considering adding filtering and search capabilities to make it easier to navigate between related resources in larger deployments.
- **Application graph visualization** - Using the [Radius Application Graph](https://docs.radapp.io/guides/author-apps/application/overview/#query-and-understand-your-application-with-the-radius-application-graph) to render an interactive visual map of how resources in an application are connected. This is something we're especially excited about at Millennium bcp, as it would give our teams an always-up-to-date picture of how their applications are put together and how changes propagate through dependencies.
- **Resource actions** - Adding the ability to perform common operations directly from the UI, such as deploying new resources, updating configurations, viewing logs and events, or triggering recipe updates.
- **Change Radius logo** - The current plugin has the icon in black. I'd like to update it to the official Radius logo in color, but I haven't had a chance to get to that yet.

If any of these sound interesting to you, I'd love help or feedback. The plugin is open source and contributions are welcome!

## Get Involved

I built this plugin because we needed it at Millennium bcp, but I'm contributing it to the [Headlamp plugins repository](https://github.com/headlamp-k8s/plugins) so it's available to the whole community. If you'd like to check it out or get involved:

- See the [plugin PR](https://github.com/headlamp-k8s/plugins/pull/461) for the full implementation.
- Install the plugin from [Artifact Hub](https://artifacthub.io/packages/headlamp/headlamp-plugins/headlamp_radius)
- Get started with Radius using the [getting started guide](https://docs.radapp.io/getting-started/).
- Learn about building [Headlamp plugins](https://headlamp.dev/docs/latest/development/plugins/).
- Join the [Radius community on Discord](https://aka.ms/radius/discord) — I'd love to hear what you think.

## Wrapping Up

Building this plugin has been a great way to bridge the gap between Radius and Kubernetes tooling. By bringing Radius visibility into the same UI our teams already use for cluster management, we've made it easier for developers to understand and manage their applications without switching contexts.

The combination of Radius's application-centric abstractions and Headlamp's extensible UI creates a powerful platform for teams looking to streamline their application management workflows. Whether you're just getting started with Radius or already using it in production, I hope this plugin helps you and your team work more efficiently.

Thanks to the Radius and Headlamp communities for building such great open-source tools, and for welcoming contributions like this one.
