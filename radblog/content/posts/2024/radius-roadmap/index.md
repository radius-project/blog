---
date: "3024-01-31T08:00:00-08:00"
title: "Radius feature roadmap"
linkTitle: "Roadmap"
author: "Radius project maintainers"
type: blog
---

The Radius project maintainers are excited to share our feature roadmap for Radius! We are looking forward to working with the community to grow and enhance Radius and will keep this roadmap updated as we make progress. To remain agile and adaptive to community needs, after each release we will reassess and update the roadmap as necessary to reflect the latest priorities.

Please engage with the Radius community via the [monthly community calls](https://github.com/radius-project/community?community-meetings) and [Discord](https://aka.ms/radius/discord) if you have any feedback, suggestions, or feature requests!

## Summary

At this stage of the project, building an active and diverse open-source community for Radius is our top priority and we will focus on work that accelerates the growth of our community and adopters. Items like testing, pipelines, automation, and bug fixes that make life easier for open-source contributors will be prioritized. In terms of feature work, we are investing in what our community and users have identified as our most strategic areas: Recipes, Dashboard, connecting to existing resources, and serverless integrations. Please follow the [Radius backlog](https://github.com/orgs/radius-project/projects/8/views/1) for updates on the full set of roadmap priorities. Below we'll discuss the top priority areas and features for Radius in more detail.

<img src="gh-roadmap.png" alt="screenshot of the Radius roadmap board from GitHub" width=500 />

## Radius Recipes

We believe Recipes to be one of the the highest value propositions of Radius, because they enable separation of concerns across developers and operators. The initial public release of Radius offers end-to-end Recipe deployment and deletion for both Bicep and Terraform templates. This unlocks a basic resource lifecycle for learning about and leveraging Recipes in simple applications. For Recipes to become a production-grade feature, there are a set of items we need to design and implement, with the following being our current priorities:

- **Private Terraform modules**: Today Radius only supports public Terraform modules. The first addition to Terraform Recipes we need to add is support for private modules from the Terraform module gallery or from other private galleries.
- **Recipe “stickiness” and versioning**: Operators need to be able to update & make changes to Recipes within an environment. Today this requires any resource using the Recipe to immediately start using the new Recipe template/version upon the next deployment. This may break developers not expecting changes to their infrastructure. We need a way to make this configurable, where teams can control how new Recipe templates are rolled out, along with a versioning strategy.
- **Ability to configure which drivers are supported**: There has been some feedback around being able to selectively disable specified Recipe drivers, e.g. disable Bicep or Terraform Recipes per IT policies. Given the compliance-related nature of this ask, we have prioritized it.
- **Recipes for any Resource**: Today we only support portable resources (Applications.Dapr, Applications.Datastores, Applications.Messaging) for Recipes. As part of our Recipes enhancement, we want to support any resource across Azure, AWS, and more. This would allow operators to define a template for something like an S3 bucket and the developer can request “an S3 bucket” without knowing the details.

## Radius Dashboard

The Radius application graph is a key differentiator and value proposition for Radius, but one that can only be fully realized through a Dashboard offering. Today we have [`rad app connections`](https://docs.radapp.io/reference/cli/rad_application_connections/) functionality in the CLI to list the connections and resources in a Radius application, which is useful but barely scratches the surface of what's possible. Thus, we have prioritized work to deliver a Radius Dashboard that enables users to visualize their Radius application graphs. As a start, will build and make available the API for users, along with a basic implementation of an application graph visualization in a lightweight Dashboard deployed alongside the Radius control plane. We will also explore Backstage and their plugins framework as a part of the Dashboard implementation, as we see great value in leveraging and perhaps collaborating with their well-established community and user base.

## Connecting to existing resources

The Radius vision includes the capability to connect to existing resources that were previously provisioned and existed outside of the scope of the Radius application. The most immediately prioritized work is to enable Radius to connect to such existing pre-provisioned resources using Recipes.

## Serverless integrations

Given the importance of serverless infrastructure in the modern application landscape, it is a priority for Radius to support serverless resources. The initial expansion will focus on integrating with an unopinionated serverless infrastructure platform, specifically [Azure Container Instances](https://azure.microsoft.com/en-us/products/container-instances/), before exploring integrations with more opinionated serverless platforms like [Azure Functions](https://azure.microsoft.com/en-us/services/functions/), [Azure Container Apps](https://azure.microsoft.com/en-us/services/azure-container-apps/), and [AWS Lambda](https://aws.amazon.com/lambda/).

## Learn more and contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We’re looking for people to join us!  To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).