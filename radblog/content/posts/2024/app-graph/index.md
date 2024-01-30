---
date: "2026-02-01T00:00:00"
title: "Understand your entire application with the Radius Application Graph"
linkTitle: "Application Graph"
author: [Will Tsai](https://www.github.com/willtsai)
type: blog
---

In today's complex landscape of cloud-native architectures, it can be difficult to understand how all the pieces of an application fit together. A single application can be composed of multiple microservices, each with their own resources, dependencies, and relationships. Typically defined in lists of Kubernetes YAML, infrastructure-as-code templates, and Helm charts, knowing "what is my app?" is hard to answer. Plus, there is no unified way to track the relationships and dependencies between resources. Instead, teams are left to recreate their architecture with network-packet diagrams, or with team wikis documented external to the app that quickly fall out of date.

While Kubernetes has become the go-to platform for teams building cloud-native apps, an application is so much more than a flat list of Kubernetes resources. What's needed is a way to model an entire application and its relationships, consisting of both its Kubernetes components plus its external cloud/on-premises infrastructure, presented in a way that's always up to date and easy to consume by teams.

## Application graph data that is inherently part of the development process

With an application structure that includes environments, resource groups, and connections, applications deployed using Radius get represented into a graph-like data set that reveals precisely how the resources within the application are interconnected. Operator teams that support developers are thus empowered to build visualizations using this graph data that help them intuitively understand what makes up an application. Best of all, this data is generated automatically as part of the development process with Radius inherent in the application declarations, so it is always up to date without requiring additional effort from developers.

{{ < image src="images/app-graph-overview.png" alt="Application graph overview diagram" width="600" > }}

## View application graph relationships with the Radius CLI

Using Radius to declare [connections](https://docs.radapp.io/guides/author-apps/containers/overview/#connections) between dependencies to simplify the provisioning and deployment of resources directly results in the documentation of the application. These resource and connection declarations are used by Radius to construct the application graph data. The Radius CLI provides a lightweight `rad app connections` command to view the application and its connections in a terminal window. This provides developers and operators with a way to quickly understand how the application is structured and how its resources are connected while they are building their applications.

{{ < image src="images/app-graph-connections.png" alt="Screenshot of application graph connections console output" width="600" > }}

## Build visualizations using the Radius application graph API

Instead of multiple views of logs, infrastructure, and code, Radius provides a single source of truth for the application. The application graph API provides a way to query the application graph data and build visualizations that help teams understand how their application is structured and how its resources are connected. Radius provides an HTTP-based API that allow users to communicate with its control plane to query for the application graph data. The API can be hosted inside a Kubernetes cluster or as a standalone set of processes or containers. Visit the [Radius API documentation](https://docs.radapp.io/concepts/api-concept/) pages to learn more.

{{ < image src="images/app-graph-api.png" alt="Application graph API diagram" width="550" > }}

{{ < image src="images/app-graph-api-visualization.png" alt="Screenshot of application graph API query with arrow pointing to a visualization diagram" width="600" > }}