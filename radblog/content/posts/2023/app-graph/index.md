---
date: "2023-11-01T00:00:00"
title: "Making sense of cloud native applications with the Radius application graph"
linkTitle: "Application graph"
author: Radius project maintainers
type: blog
---

In the complex landscape of cloud native architectures today, it can be difficult to understand how all the pieces of your application fit together. A single application can be composed of many different microservices, each with their own resources, dependencies, and relationships. Typically represented as lists of resources making up the application, these relationships can be difficult to visualize, and even more so if architectural design documents are lacking or out of date. Although engineers know all too well that applications are so much more than just Kubernetes and flat lists of resources, creating and maintaining a consistently up-to-date catalog of application components is a tall order for any organization.

## Application graph data that is inherently part of the development process

With an application structure that includes environments, resource groups, and connections, applications deployed using Radius get represented into a graph-like dataset that reveals precisely how the application and its infrastructure are interconnected. Operator teams that support developers are thus empowered to build visualizations using this graph data that help them intuitively understand what makes up an application. Best of all, this data is generated automatically as part of the development and deployment process with Radius, so it is always up to date without requiring incremental effort from developers.

<img src="app-graph-overview.png" alt="Application graph overview diagram" width="600"/>

## Viewing application graph relationships with the Radius CLI

TODO

## Building visualizations using the Radius application graph API

TODO