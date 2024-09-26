---
date: "2024-09-27T00:00:00"
title: "Deploying the FINOS TraderX Application Using Radius"
linkTitle: "TraderX deployment"
author: "[Will Tsai](https://www.github.com/willtsai)"
type: blog
---

<!-- Here is some context for this blog post:

Radius is a new Cloud Native Computing Foundation (CNCF) project. It is a cloud-native application platform that enables developers and platform engineers who support them to collaborate on delivering and managing cloud-native applications that follow corporate best practices for security, cost and operations by default. It supports deploying applications across private cloud, Amazon Web Services (AWS) and Microsoft Azure, with more cloud providers to come. This talk will show how easy it is to deploy and manage a popular open-source trading application, TraderX, to multi-cloud environments without requiring the developer to configure cloud-specific infrastructure. The session will also illustrate how Radius enables better collaboration across developers and operators through features like: the Radius application dashboard, which provides developers and operators a common graphical view of TraderX, as deployed across clouds and; Radius Recipes, which give TraderX developers self-serve access to cloud resources, such as SQL databases, while enabling operators to define and enforce best practices for security, cost and operations regarding how cloud resources are consumed.

Business Problem
TraderX is currently deployed using Docker Compose, which is an excellent tool for local development and testing. However, it lacks the scalability and robust orchestration capabilities required for large-scale production environments. This limitation hinders TraderX's ability to handle increased traffic and maintain high availability.

Proposed Solution
Migrate TraderX from Docker Compose to Radius, a cloud-native application platform designed for scalability and portability. Radius, recently open-sourced and accepted as a CNCF sandbox project, offers a comprehensive solution for managing and orchestrating containerized applications.

Roadmap
"Radify" the components of TraderX:

Configurable database and message bus resources
End-to-end automated CI/CD:

Build a CI pipeline with GitHub Actions
Integrate a GitOps platform (e.g. Flux, ArgoCD) for CD
Multi-environment deployment:

Reference architecture for deploying to local, Azure, AWS
One-click deployment to experience TraderX on any cloud
Developer dashboardd experience with application graph
Related Technologies/Platforms
Radius: The core platform for application deployment and management.
Kubernetes: The underlying container orchestration engine.
Docker: The containerization technology for packaging TraderX.
Prometheus/Grafana: Potential tools for monitoring and observability.

here is a tasklist: https://gist.github.com/willtsai/6f45fceb91d1acdbbe7ba2fcef6acd08

 -->

<!-- TODO: Introduction to FINOS, TraderX, and how Radius can help deploy it.-->

The Radius maintainers have been collaborating with members of the [Fintech Open Source Foundation (FINOS)](https://www.finos.org/) community to participate in their [Tech Sprint 2024](https://www.finos.org/blog/finos-tech-sprint-2024) event, during which we worked on a project to [deploy the TraderX application using Radius](https://github.com/finos/traderX/discussions/190). Our working group was able to *Radify* the TraderX application and deploy it to local, AWS, and Azure environments using Radius, which was demonstrated in a [session](https://sched.co/1i6ud) at the [Open Source in Finance Forum 2024](https://events.linuxfoundation.org/open-source-finance-forum-new-york) event in New York. This blog post will walk through our journey in detail of how we integrated Radius into TraderX, the challenges we faced, and what's next for TraderX and Radius.

## Overview of the TraderX application

<!-- TODO: Provide an overview of the TraderX application, including its background, architecture, components, and how it's currently being packaged and deployed. -->

[TraderX](https://github.com/finos/traderX) is a sample application created and maintained by members of the FINOS community to serve as a reference application for developers in the financial services industry looking to build cloud-native applications and leverage open source projects. It is a distributed application that consists of multiple services, including a front-end web application, various back-end services, a message bus, and a SQL database. The application was originally packaged and deployed using Docker Compose, which worked well for local development and testing but lacked the scalability and robust orchestration capabilities required for large-scale production environments in the cloud. This is where Radius comes in.

{{< image src="images/traderx-overview.png" alt="Architecture diagram of the TraderX application" width="600" >}}

## Integrating TraderX with Radius

TODO: Provide and introduction to why Radius is a good fit for deploying TraderX, including details like the TraderX being readily containerized, the need for a consistent yet flexible deployment model that accomodates multiple environments and a self-documenting application model (benefits of the app graph). Emphasize the importance of cross-cloud deployment for regulated industries like finance and healthcare. Reference the getting started guide for readers who may not understand the basics of radius. Set up the persona of a developer whose organization has already set up the environment and containerized the application, to provide context before diving into the specific tasks.

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

## Challenges and lessons learned

TODO: Describe the challenges faced and lessons learned during the process of deploying TraderX using Radius to serve as a reference for others starting their Radification journey.

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