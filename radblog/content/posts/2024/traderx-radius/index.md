---
date: "2024-09-27T00:00:00"
title: "Deploying the FINOS TraderX Application Using Radius"
linkTitle: "TraderX deployment"
author: "[Will Tsai](https://www.github.com/willtsai)"
type: blog
---

TODO: Introduction to FINOS, TraderX, and how Radius can help deploy it.

## Overview of the TraderX application

TODO: Provide an overview of the TraderX application, including its background, architecture, components, and how it's currently being packaged and deployed.

## Integrating TraderX with Radius

TODO: Provide and introduction to why Radius is a good fit for deploying TraderX, including details like the TraderX being readily containerized, the need for a consistent yet flexible deployment model that accomodates multiple environments and a self-documenting application model (benefits of the app graph).

### Publish images to a container registry

TODO: Provide overview of publishing TraderX images to a container registry (GHCR), including the necessary configurations and commands that were run. Describe why this was needed and how it fits into the TraderX deployment process.

### Author the TraderX application definition using Radius

TODO: Provide an overview of authoring the TraderX application definition using Radius, including the necessary configurations and showing snippets of the `app.bicep` file that gets authored. Describe how the TraderX application containers are defined, how they are connected using Radius connections, and how the application graph will be generated.

### Modify TraderX to use a portable database resource

TODO: This actual task is yet to be done, but we can describe the code and configuration changes we made to the TraderX database service that allows us to decouple the database from the application such that it no longer has a hard dependency on an H2 database implementation. This will allow us to use cloud resources like Azure SQL Database or AWS RDS for the database service.

### Deploy the TraderX application using Radius

TODO: Describe the three environments that had been made available to me as a developer, including how the operations teams had set up all the Recipes needed to provision the necessary infrastructure for the TraderX application. Show the commands used and their corresponding output to deploy the TraderX application using Radius across local, AWS, and Azure. Emphasize that the same application definition is reused to deploy across the different environments. Show the various local and cloud resources that were provisioned as part of the deployment process.

### View the application graph

TODO: Show the application graph that gets generated as part of the deployment process and compare it to the TraderX architecture diagram. Emphasize that the application graph is automatically generated as a part of the Radius application authoring and deployment process and is always up to date.

## What's next for TraderX and Radius

TODO: Describe what more we can do with TraderX and Radius, including:
- Setting up a CI/CD pipeline for TraderX using GitHub Actions and a GitOps platform.
- Modifying the message bus service to use a portable resource.
- Reference architecture to help users enable "one-click deployment" of TraderX to local, Azure, AWS

## Learn more and contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We're looking for people to join us!  To get started with Radius today, please see:

- Start using Radius with the [getting started guide](https://docs.radapp.io/getting-started/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).