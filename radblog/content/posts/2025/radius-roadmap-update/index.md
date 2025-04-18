---
date: "2026-04-30T08:00:00-08:00"
title: "Radius feature roadmap update"
linkTitle: "Radius roadmap update"
author: "Radius project maintainers"
type: blog
---

The Radius project maintainers would like to provide a progress update on our [feature roadmap](https://aka.ms/radius-roadmap) to share some of the features that have been released, what's coming next, and how the community can help shape the future of Radius.

We invite the community to provide feedback on our priorities to jointly grow and enhance Radius. Please bookmark the [**Radius roadmap**](https://aka.ms/radius-roadmap) for updates on the full set of roadmap priorities.

{{< image src="images/gh-roadmap.png" alt="screenshot of the Radius roadmap board from GitHub" width=800 >}}

## Recent progress
The Radius maintainers and contributors have been hard at work in delivering new features and updates with an increased focus on enhancing functionality and user experience. Key new features that have been released include Flux support for GitOps and the addition of the Dapr Configuration building block. The new `rad resource-type create` CLI command introduces foundational primitives resource extensibility, while preparations for migrating to PostgreSQL lay the groundwork for further improvements to the Radius data store. These updates reflect the collaborative efforts of the Radius team and its community to drive innovation and usability.

### Support for GitOps using Flux
Radius now has integrated first-class support for [Flux](https://fluxcd.io/), a popular GitOps tool. Flux is designed to work with Kubernetes and provides a set of features for managing applications and infrastructure through Git. To learn more, visit the [Radius and GitOps overview](https://docs.radapp.io/guides/deploy-apps/gitops/overview/) and [how-to guide for Radius + Flux](https://docs.radapp.io/guides/deploy-apps/gitops/howto-flux/).

### Support for Dapr Configuration Building Block
A new `Applications.Dapr/configurationStores` resource type is now available to define and deploy the [Dapr Configuration](https://docs.dapr.io/getting-started/quickstarts/configuration-quickstart/) building block in Radius. The Dapr Configuration building block allows for dynamic configuration updates, including feature flag management, and is a great addition to the Dapr integration in Radius. To learn more, go to the [Dapr Configuration Store resource schema](https://docs.radapp.io/reference/resource-schema/dapr-schema/configurationstore/) in the Radius documentation.

### rad CLI command for creating new resource types
We have added a CLI command `rad resource-type create` to create new resource-types in Radius. This was added to enable resource extensibility in Radius. The end-end functionality of creating and deploying a custom user-defined resource type will be available in a future release. To learn more about these efforts, see the [resource types extensibility technical design document](https://github.com/radius-project/design-notes/blob/main/architecture/2024-07-user-defined-types.md).

### Preparations for using PostgreSQL as the Radius database
In the near future, the Radius data store will be migrated from etcd to a PostgreSQL database. In preparation for this, the Helm chart for installing Radius now includes deploying PostgreSQL to the Kubernetes cluster. You can follow the progress of moving the Radius data store in [this issue](https://github.com/radius-project/radius/issues/8398).

## Upcoming priorities
Looking ahead, our feature focus will be on enhancing the extensibility of Radius, starting with the ability to create custom resource types and enabling compute platform portability into serverless container platforms. Scalability and operational excellence improvements are also on the horizon, including control plane upgrades, support for external data stores, and ability to specify additional application configurations.

### [Custom resource types](https://github.com/radius-project/roadmap/issues/14)
Radius currently supports a set of [built-in resource types](https://docs.radapp.io/guides/author-apps/portable-resources/overview/) that you can define and deploy in your Radius application. Through custom resource types, Radius will provide an extensibility model where the user can bring their own services or resources and integrate them with Radius. This will enable users to easily define and deploy their own resource types and leverage the other features of Radius such as Recipes and Application Graph to manage their complete suite of resources. Additionally, it will provide an avenue for the open-source community to publish custom resource types and Recipes as community supported assets.

### [Serverless container platforms](https://github.com/radius-project/roadmap/issues/23)
An important part of the Radius vision is to be platform agnostic, and that includes the underlying compute such that Radius can deploy the same application across different compute platforms. Given the importance of serverless infrastructure in the modern application landscape, it is a priority for Radius to support serverless container platforms, in addition to Kubernetes, as the underlying compute provider. Our first foray into this space will be to build support for Azure Container Instances as a compute provider. We wanted our first expansion beyond Kubernetes to be into a less unopinionated compute platform that provides raw compute primitives like Azure Constainer Instances or AWS Elastic Container Service, which allows us to better learn how to model the extensibility of Radius core. Our learnings will hopefully pave the way for expansion into more opinionated or advanced solutions like AWS Lambda or Azure Functions in the future.

### [Control plane upgrades](https://github.com/radius-project/roadmap/issues/52)
Today, Radius does not have a safe mechanism for upgrading from one release to another. This enhancement provides users the ability to upgrade from an existing installation to a new release with safeguards in place like data backups, rolling upgrades to minimize downtime, and the ability to roll back if something goes wrong with the upgrade. This is a critical feature for production deployments of Radius, and we are working to ensure that users can effortlessly upgrade their control plane installations without losing the stored state of their applications.

### [External data store](https://github.com/radius-project/roadmap/issues/49)
Radius currently stores its configuration and resource data in etc within the host Kubernetes cluster. This presents challenges for users backing up their Radius resource data and coordinating with Kubernetes cluster updates. Efforts are underway to implement options for advanced Radius deployments which use an external data store provided by the user, with the first supported external data store being PostgreSQL.

### Additional application configurations
Incremental improvements to the application configuration experience in Radius are also in progress. These include the ability to specify application scaling behavior (such as custom metrics for scaling and setting maximum number of replicas) and the ability to configure HTTP timeouts for gateways. These are community-driven enhancements that will provide users with more control over their applications and improve the flexbility of Radius across a wider range of production scenarios.

## Learn more and contribute

All feedback and contributions are welcome! The community is encouraged to engage with the Radius project in the following ways: 

- Provide feedback to influence roadmap decisions by commenting on and upvoting [existing items](https://aka.ms/radius-roadmap)
- Submit new [feature requests](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E) to propose new functionality or other [issue reports](https://github.com/radius-project/radius/issues/new/choose)
- Review in-progress [designs](https://github.com/radius-project/design-notes/pulls) and [code](https://github.com/radius-project/radius/pulls)
- Contribute directly to fix [open issues](https://github.com/radius-project/radius/issues) and [documentation](https://github.com/radius-project/docs/issues)
- Engage with the Radius community via the [monthly community calls](https://github.com/radius-project/community?community-meetings) and [Discord](https://aka.ms/radius/discord)