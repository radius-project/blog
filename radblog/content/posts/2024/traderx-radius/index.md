---
date: "2024-10-10T00:00:00"
title: "Deploying the FINOS TraderX Application Using Radius"
linkTitle: "TraderX deployment"
author: "[Will Tsai](https://www.github.com/willtsai)"
type: blog
---

The Radius maintainers have been collaborating with members of the [Fintech Open Source Foundation (FINOS)](https://www.finos.org/) community in participation of their [Tech Sprint 2024](https://www.finos.org/blog/finos-tech-sprint-2024) event, during which we worked on a project to [deploy the TraderX application using Radius](https://github.com/finos/traderX/discussions/190). Our working group was able to build a CI pipeline for the application containers and *Radify* the TraderX application to deploy on local, AWS, and Azure environments using Radius. The project was demonstrated in a [session](https://www.youtube.com/watch?v=_tI467p5R4Y&list=PLmPXh6nBuhJsLdVouWRmB6q9WKnjNdxyL) at the [Open Source in Finance Forum 2024](https://events.linuxfoundation.org/open-source-finance-forum-new-york) event in New York. 

In this blog post we will assume the persona of an application developer and walk through our journey in detail of how we integrated Radius into TraderX, the challenges we faced, and what's next for TraderX and Radius.

## Overview of the TraderX Application

[TraderX](https://github.com/finos/traderX) is a sample application created and maintained by members of the FINOS community to serve as a reference application for developers in the financial services industry looking to build cloud-native applications and leverage open source projects. It is a distributed application that consists of multiple services, including a front-end web service, various back-end services, a message bus, and a relational database. The application was originally packaged and deployed using Docker Compose, which worked well for local development and testing but lacked the scalability and robust orchestration capabilities required for large-scale production environments in the cloud. This is where Radius becomes helpful, as it provides a consistent deployment model that allows developers to deploy applications across multiple environments without needing to configure cloud-specific infrastructure.

{{< image src="images/traderx-overview.png" alt="Architecture diagram of the TraderX application" width="1200" >}}

## Integrating TraderX with Radius

With TraderX being already containerized and leveraging cloud-agnostic open-source technologies like containers and Nginx, it was a natural fit to add Radius for application deployment. Radius provides a consistent yet flexible deployment model that allows developers to deploy applications across multiple environments without needing to configure cloud-specific infrastructure. This is particularly important for regulated industries like finance and healthcare, where applications may be required to be deployed across multiple cloud providers. Radius also provides a self-documenting application model that generates an application graph, which helps developers and operators understand the application architecture and dependencies. If you're new to Radius, you can learn more by following the [getting started guide](https://docs.radapp.io/getting-started/). Below we'll cover in more detail the tasks involved in deploying TraderX using Radius.

### Publish Images to a Container Registry

We needed to publish the images to a container registry to make them available for deployment using Radius. GitHub Container Registry (GHCR) is a container registry that allows us to publish and share container images. To publish the TraderX container images into the [FINOS GitHub container registry](https://github.com/orgs/finos/packages), we created a [GitHub Actions CI pipeline](https://github.com/finos/traderX/actions/workflows/build-and-publish.yml) to automate the build and publish process. The CI pipeline is defined in a GitHub Actions workflow file called [`build-and-publish.yml`](https://github.com/finos/traderX/blob/main/.github/workflows/build-and-publish.yml) within the TraderX repository. The workflow triggers on every push to the `main` branch and builds container images for each service in the application. The images are then scanned for vulnerabilities before being tagged with the `latest` label and pushed to GHCR. The CI pipeline ensures that the TraderX images are always up to date and available for deployment using Radius.

### Author the TraderX Application Definition Using Radius

With the CI pipeline in place, we were ready to set up TraderX for deployment using Radius. The starting point for deploying an application with Radius is to author the application definition in [Bicep](https://github.com/Azure/bicep). To do this, we created an application definition file called [`app.bicep`](https://github.com/finos/traderX/blob/main/radius-traderx/app.bicep) within the TraderX repo. It defines the TraderX application using the Radius application model, which includes the application containers, required environment variables, and connections between the containers. This `app.bicep` Radius application definition file captures all the necessary configurations (namely the container images, ports, and environment variables) from the exising [`docker-compose` file](https://github.com/finos/traderX/blob/main/docker-compose.yml) into a cloud-agnostic application model that allows TraderX to be deployed across local and cloud environments. For example, the resource definition for [`position-service`](https://github.com/finos/traderX/tree/main/position-service) looks like this: 

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

Notice that the `app.bicep` application definition file snippet above includes a declared [connection](https://docs.radapp.io/guides/author-apps/containers/overview/#connections) to the database. Connections is how Radius establishes and tracks dependencies between applications and application components. This connection data is used to generate the Radius Application Graph which we will discuss later. The full `app.bicep` application definition file for TraderX can be found [here](https://github.com/finos/traderX/blob/main/radius-traderx/app.bicep).

### Deploy the TraderX application using Radius

With the TraderX application definition authored, we were ready to deploy the application using Radius. We began with deploying TraderX to a local Kubernetes cluster which we built using [k3d](https://k3d.io/v5.6.3/):

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

After validating that the application was deployed and running successfully on our local cluster, we sought to deploy TraderX to AWS and Azure. This proved to be very easy because we could reuse the cloud environments and resources that had already been previously put in place by our operations team. We used the same application definition file to deploy TraderX to AWS and Azure. The only difference was that we specified the target cloud environment using the [`--workspace` flag](https://docs.radapp.io/reference/cli/rad_deploy/#options) , which allows you to manage and target Radius environments using a local, client-side, configuration file. For example, to deploy TraderX to our existing [Radius Workspaces](https://docs.radapp.io/guides/operations/workspaces/overview/) named `prod-aws` and `prod-azure`, we ran the following commands:

```bash
rad deploy app.bicep --workspace prod-aws
```

```bash
rad deploy app.bicep --workspace prod-azure
```

The deployment experience was identical across local, AWS, and Azure environments, with Radius handling the provisioning of the necessary Kubernetes resources across the local k3d, AWS Elastic Kubernetes Service, and Azure Kubernetes Service environments. The consistent deployment experience across environments clearly demonstrated how Radius enables developers to deploy applications across multiple environments without needing to fuss with configuring cloud-specific infrastructure.

### View the Application Graph

One of the key features of Radius is the [Application Graph](https://docs.radapp.io/guides/author-apps/application/overview/#query-and-understand-your-application-with-the-radius-application-graph), which provides a visual representation of the application architecture and is automatically generated. Using Radius to deploy TraderX, we were able to view dependencies between application components in the Radius dashboard. The Application Graph is a valuable tool for developers and operators to understand the application architecture and dependencies, and can be used to troubleshoot issues and optimize the application deployment. Below is the Radius Application Graph for TraderX--you can see that it closely resembles the TraderX architecture diagram we showed earlier:

{{< image src="images/traderx-app-graph.png" alt="Application graph of the TraderX application" width="1200" >}}

## Challenges and Lessons Learned

Overall, the process of deploying TraderX using Radius was smooth and straightforward, thanks to the well-structured application architecture and the containerized nature of the application. However, we did encounter a few challenges along the way that we'll share here to help others who are starting their Radius journey:

- **Permissions for FINOS container registry**: When publishing the container images to the FINOS GHCR, we were not able to directly push the images to the registry given that none of us were maintainers of TraderX. This made it challenging to incrementally test the building and publishing steps of the CI workflow. Thus, we tested the Docker build and push steps manually in our local environment and private GHCR registry first before submitting a PR with the CI workflow changes to the TraderX repo. The manual validation of the CI steps ensured a smoother PR review process and quicker turnaround time for getting the CI pipeline merged and operational. The CI pipeline was then easily built using the [Checkout](https://github.com/marketplace/actions/checkout) and [Build and push Docker images](https://github.com/marketplace/actions/build-and-push-docker-images) workflows available on the GitHub Actions marketplace.

- **Scanning for vulnerabilities in container images**: The TraderX maintainers were keen on ensuring that the container images were free of vulnerabilities before being published to the GHCR, and recommended that we build a vulnerability scanning step into the CI pipeline. Fortunately, there are several GitHub Actions available on the marketplace that can be leveraged for image scanning. Following the lead of existing TraderX workflows, we opted for the [Container Scan](https://github.com/marketplace/actions/container-scan) GitHub Action that leverages [Trivy](https://github.com/aquasecurity/trivy) for scanning, which worked perfectly for our use case.

- **Setting environment variables in the application definition**: When authoring the TraderX application definition using Radius, we needed to specify environment variables for the application containers. This took some research into the internals of the TraderX application to understand which environment variables were required for each service. We found that the environment variables were mostly defined in the `docker-compose.yml` file, which we then translated into the Radius application model. We learned that it's important to have a good understanding of the application architecture and dependencies when authoring the application definition to ensure that the application is configured correctly and runs successfully.

## What's Next for TraderX and Radius

While being able to deploy TraderX across local and cloud environments using Radius is a great start, there are many more exciting things we can do with TraderX and Radius to further enhance the deployment experience and portability of the application. Some future areas of focus for the TraderX and Radius project include:

### Configurable Database and Message Bus Resources

The TraderX [database](https://github.com/finos/traderX/tree/main/database) container today hosts a [H2 database](https://www.h2database.com/) as a standalone server. The TraderX [`trade-feed`](https://github.com/finos/traderX/tree/main/trade-feed) container today hosts a simple pub-sub server that uses [Socket.IO](https://socket.io/). We can use Radius to enable dynamic deploy-time provisioning of the database and message bus, both driven by Radius Recipes. This will enable users to deploy TraderX with a compatible database and message bus of their choice that's hosted either on-premises or in the cloud, all without needing to modify the application code or deployment definition.

### Automated CD via GitOps

We would like to integrate a GitOps platform coupled with Radius to enable continuous deployment of TraderX. Coupled with the GitHub Actions CI pipeline in place from our tech sprint efforts, TraderX will have an end-to-end automated CI/CD pipeline. This will enable developers to push code changes to the Git repository and have the application automatically built, tested, and deployed to the target environment.

### Complete Multi-Environment Deployment Experience

Finally, we want to demonstrate that TraderX can be deployed to multiple cloud environments using Radius. We will create a reference architecture that can serve as a user guide for deploying TraderX to local, Azure, and AWS environments. Done thoughtfully, this would provide users with a one-click deployment experience that allows developers to experience TraderX on any cloud with minimal effort.

## Learn More and Contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We're looking for people to join us!  To get started with Radius today, please see:

- Start using Radius with the [getting started guide](https://docs.radapp.io/getting-started/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).