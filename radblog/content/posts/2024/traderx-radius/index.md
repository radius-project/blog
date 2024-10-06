---
date: "2024-10-10T00:00:00"
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

The Radius maintainers have been collaborating with members of the [Fintech Open Source Foundation (FINOS)](https://www.finos.org/) community in participation of their [Tech Sprint 2024](https://www.finos.org/blog/finos-tech-sprint-2024) event, during which we worked on a project to [deploy the TraderX application using Radius](https://github.com/finos/traderX/discussions/190). Our working group was able to build a CI pipeline for the application containers and *Radify* the TraderX application to deploy on local, AWS, and Azure environments using Radius. The project was demonstrated in a [session](https://sched.co/1i6ud) at the [Open Source in Finance Forum 2024](https://events.linuxfoundation.org/open-source-finance-forum-new-york) event in New York. In this blog post, we assume the persona of an application developer who is ready to deploy and test TraderX across local and cloud environments. We will walk through our journey in detail of how we integrated Radius into TraderX, the challenges we faced, and what's next for TraderX and Radius.

## Overview of the TraderX application

[TraderX](https://github.com/finos/traderX) is a sample application created and maintained by members of the FINOS community to serve as a reference application for developers in the financial services industry looking to build cloud-native applications and leverage open source projects. It is a distributed application that consists of multiple services, including a front-end web service, various back-end services, a message bus, and a SQL database. The application was originally packaged and deployed using Docker Compose, which worked well for local development and testing but lacked the scalability and robust orchestration capabilities required for large-scale production environments in the cloud. This is where Radius comes in.

{{< image src="images/traderx-overview.png" alt="Architecture diagram of the TraderX application" width="600" >}}

## Integrating TraderX with Radius

With TraderX being readily containerized and leveraging cloud agnostic open source technologies like Docker containers and Nginx, it was a natural fit to add Radius for application deployment. Radius provides a consistent yet flexible deployment model that allows developers to deploy applications across multiple environments without needing to configure cloud-specific infrastructure. This is particularly important for regulated industries like finance and healthcare, where applications may be required to be deployed across multiple cloud providers. Radius also provides a self-documenting application model that generates an application graph, which helps developers and operators understand the application architecture and dependencies. If you're new to Radius, you can learn more by following the [getting started guide](https://docs.radapp.io/getting-started/). Below we'll cover in more detail the tasks involved in deploying TraderX using Radius.

### Publish images to a container registry

Even though the TraderX is readily containerized with Dockerfiles for building each service, we needed to publish the images to a container registry to make them available for deployment using Radius. GitHub Container Registry (GHCR) is a fully integrated container registry that allows us to publish and share Docker images within the GitHub ecosystem and thus is a good fit for an open source project hosted on GitHub like FINOS and TraderX. To publish the TraderX container images into the [FINOS GitHub registry](https://github.com/orgs/finos/packages), we created a [GitHub Actions CI pipeline](https://github.com/finos/traderX/actions/workflows/build-and-publish.yml) to automate the build and publish process. The CI pipeline is defined in a GitHub Actions workflow file called [`build-and-publish.yml`](https://github.com/finos/traderX/blob/main/.github/workflows/build-and-publish.yml) within the TraderX repo. The workflow triggers on every push to the `main` branch and builds the Docker images for each service in the application. The images are then scanned for vulnerabilities before being tagged with the `latest` label and pushed to the GHCR. The CI pipeline ensures that the TraderX images are always up to date and available for deployment using Radius.

### Author the TraderX application definition using Radius

With the CI pipeline in place, we were ready to set up TraderX for deployment using Radius. The starting point for deploying an application with Radius is to author the application definition. To do this, we created an application definition file called [`app.bicep`](https://github.com/finos/traderX/blob/main/radius-traderx/app.bicep) within the TraderX repo. It defines the TraderX application using the Radius application model, which includes the application containers, required environment variables, and connections between the containers. This `app.bicep` Radius application definition file captures all the necessary configurations (namely the container images, ports, and environment variables) from the exising [`docker-compose` file](https://github.com/finos/traderX/blob/main/docker-compose.yml) into a cloud-agnostic application model that allows TraderX to be deployed across local and cloud environments. For example, the resource definition for [`position-service`](https://github.com/finos/traderX/tree/main/position-service) looks like this: 

```bicep
resource positionservice 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'position-service'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/finos/traderx/position-service:latest'
      ports: {
        web: {
          containerPort: 18090
        }
      }
      env: {
        DATABASE_TCP_HOST: {
          value: database.name
        }
      }
    }
    connections: {
      db: {
        source: database.id
      }
    }
  }
}
```

Additionally, the `app.bicep` application definition file includes [connection](https://docs.radapp.io/guides/author-apps/containers/overview/#connections) declarations between containers and is thus a self-documenting artifact that serves as the single source of truth for the TraderX application and used by Radius establish connections between containers and generate the application graph (more on this later).

### Deploy the TraderX application using Radius

<!-- TODO: Describe the three environments that had been made available to me as a developer, including how the operations teams had set up the necessary EKS and AKS clusters to provision the necessary infrastructure for the TraderX application. Show the commands used and their corresponding output to deploy the TraderX application using Radius across local, AWS, and Azure. Emphasize that the same application definition is reused to deploy across the different environments. Show the various local and cloud resources that were provisioned as part of the deployment process. -->

With the TraderX application definition authored, we were ready to deploy the application using the Radius toolset. We began with deploying TraderX to a local [k3d](https://k3d.io/v5.6.3/) cluster:

```bash
rad deploy app.bicep                      
Building app.bicep...
.
.
.
Deployment Complete

Resources:
    account-service Applications.Core/containers
    database        Applications.Core/containers
    ingress         Applications.Core/containers
    people-service  Applications.Core/containers
    position-service Applications.Core/containers
    reference-data  Applications.Core/containers
    trade-feed      Applications.Core/containers
    trade-processor Applications.Core/containers
    trade-service   Applications.Core/containers
    web-front-end-angular Applications.Core/containers
```

After validating that the application was deployed and running successfully on our local cluster, we sought to deploy TraderX to AWS and Azure. This proved to be very easy (almost no-op, in fact) because we could re-use the cloud environments and resources that had already been previously put in place by our operations team. We used the same application definition file to deploy TraderX to AWS and Azure. The only difference was that we specified the target cloud environment using the `-w` flag:

```bash
rad deploy app.bicep -w prod-aws

rad deploy app.bicep -w prod-azure
```

The deployment experience was identical across local, AWS, and Azure environments, with Radius handling the provisioning of the necessary Kubernetes resources across the local k3d, AWS Elastic Kubernetes Service, and Azure Kubernetes Service environments. The consistent deployment experience across environments clearly demonstrated how Radius enables developers to deploy applications across multiple environments without needing to fuss with configuring cloud-specific infrastructure.

### View the application graph

<!-- TODO: Show the application graph that gets generated as part of the deployment process and compare it to the TraderX architecture diagram. Emphasize that the application graph is automatically generated as a part of the Radius application authoring and deployment process and is always up to date. -->

One of the key features of Radius is the [Application Graph](https://docs.radapp.io/guides/author-apps/application/overview/#query-and-understand-your-application-with-the-radius-application-graph), which provides a visual representation of the application architecture and is automatically generated. Using Radius to deploy TraderX, we were able to generate its Application Graph data and visualize the application architecture in the Radius Dashboard. The Application Graph is a valuable tool for developers and operators to understand the application architecture and dependencies, and can be used to troubleshoot issues and optimize the application deployment. Below is the Radius Application Graph for TraderX -- you can see that it closely resembles the TraderX architecture diagram we showed earlier:

{{< image src="images/traderx-app-graph.png" alt="Application graph of the TraderX application" width="600" >}}

## Challenges and lessons learned

<!-- TODO: Describe the challenges faced and lessons learned during the process of deploying TraderX using Radius to serve as a reference for others starting their Radification journey. -->

## What's next for TraderX and Radius

While being able to deploy TraderX across local and cloud environments using Radius is a great start, there are many more exciting things we can do with TraderX and Radius to further enhance the deployment experience and portability of the application. Some future areas of focus for the TraderX and Radius project include:

### Configurable database and message bus resources

The TraderX [database](https://github.com/finos/traderX/tree/main/database) container today hosts an H2 SQL database as a standalone server. The TraderX [`trade-feed`](https://github.com/finos/traderX/tree/main/trade-feed) container today hosts a simple pub-sub server that uses [Socket.IO](https://socket.io/). We can use Radius to enable dynamic deploy-time provisioning of the database and message bus, both driven by configured Recipes. This will enable users to deploy TraderX with a compatible SQL database and message bus of their choice that's hosted either on-prem or in the cloud, all without needing to modify the application code or deployment definition.

### Automated CD via GitOps

We would like to integrate a GitOps platform coupled with Radius to enable continuous deployment of TraderX. Coupled with the GitHub Actions CI pipeline in place from our tech sprint efforts, TraderX will thus have an end-to-end automated CI/CD pipeline. This will enable developers to push code changes to the repository and have the application automatically built, tested, and deployed to the target environment.

### Complete multi-environment deployment experience

Finally, we want to demonstrate that TraderX can be deployed to multiple cloud environments using Radius. We will create a reference architecture that can serve as a user guide for deploying TraderX to local, Azure, and AWS environments. Done thoughtfully, this would provide users with a one-click deployment experience that allows developers to experience TraderX on any cloud with minimal effort.

## Learn more and contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We're looking for people to join us!  To get started with Radius today, please see:

- Start using Radius with the [getting started guide](https://docs.radapp.io/getting-started/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).