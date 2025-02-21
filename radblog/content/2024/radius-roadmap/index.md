---
date: "2024-01-12T08:00:00-08:00"
title: "Introducing the Radius feature roadmap"
linkTitle: "Introducing the Radius roadmap"
author: "Radius project maintainers"
type: blog
---

The Radius project maintainers are excited to share our [feature roadmap for Radius](https://aka.ms/radius-roadmap)! We are looking forward to working with the community to grow and enhance Radius and will keep this roadmap updated as we make progress.

We hope to encourage transparency in community engagement and collaboration by sharing our roadmap and priorities. Please treat the roadmap as a living document that reflects the current goals and plans of the project, which may change based on the landscape and community needs. Thus, target delivery dates are deliberately avoided. To remain agile and adaptive, after each release the Radius maintainers will reassess and update the roadmap as necessary to reflect the latest priorities. Additionally, note that the roadmap currently reflects the priorities of the project maintainers, but as more partners join us these may change. The community may also work on things that aren't part of the roadmap.

Bookmark the [**Radius roadmap**](https://aka.ms/radius-roadmap) for updates on the full set of roadmap priorities.

{{< image src="images/gh-roadmap.png" alt="screenshot of the Radius roadmap board from GitHub" width=900 >}}

## Feedback and contributions

All feedback and contributions are welcome! The community is encouraged to engage with the Radius project in the following ways: 

- Provide feedback to influence roadmap decisions by commenting on and upvoting [existing items](https://aka.ms/radius-roadmap)
- Submit new [feature requests](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E) to propose new functionality or other [issue reports](https://github.com/radius-project/radius/issues/new/choose)
- Review in-progress [designs](https://github.com/radius-project/design-notes/pulls) and [code](https://github.com/radius-project/radius/pulls)
- Contribute directly to fix [open issues](https://github.com/radius-project/radius/issues) and [documentation](https://github.com/radius-project/docs/issues)
- Engage with the Radius community via the [monthly community calls](https://github.com/radius-project/community?community-meetings) and [Discord](https://aka.ms/radius/discord)

## Current priorities

At this stage of the project, building an active and diverse open-source community for Radius is our top priority and we will focus on work that accelerates the growth of our community and adopters. Items like testing, pipelines, automation, and bug fixes that make life easier for open-source contributors are our upcoming focus. In terms of feature work, we are currently focused on what our community and users have identified as our most strategic areas: recipes, application graph and dashboard, and serverless container runtimes.

### Radius Recipes

The initial public release of Radius offers end-to-end Recipe deployment and deletion for both Bicep and Terraform templates. This unlocks a basic resource lifecycle for learning about and leveraging Recipes in simple applications. Based on what we're hearing from users, these are the most requested features to further enhance the Recipes experience:

- [**Private Terraform modules**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47722965): Today Radius only supports public Terraform modules. The first addition to Terraform Recipes we need to add is support for private modules from the Terraform module gallery or from other private sources.
- [**Recipe “stickiness” and versioning**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47749189): Operators need to be able to update & make changes to Recipes within an environment. Today this requires any resource using the Recipe to immediately start using the new Recipe template/version upon the next deployment. This may break developers not expecting changes to their infrastructure. We need a way to make this configurable, where teams can control how new Recipe templates are rolled out, along with a versioning strategy.
- [**Ability to configure which IaC languages are supported**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47749391): There has been some feedback around being able to selectively disable specific Recipe languages (_e.g. disable Bicep or Terraform Recipes per IT policies_). Given the compliance-related nature of this ask, we have prioritized it.
- [**Recipes for any Resource**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750131): Today we only support portable resources (Applications.Dapr, Applications.Datastores, Applications.Messaging) for Recipes. As part of our Recipes enhancement, we want to support any resource across AWS, Azure, and more. This would allow operators to define a template for something like an S3 bucket and the developer can request “an S3 bucket” without knowing the details.
- [**Connecting to pre-provisioned resources**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750466): Users have consistently expressed a need for the capability to connect to existing resources that were previously provisioned and existed outside of the scope of the Radius application. The most immediately prioritized work is to enable Radius to connect to such existing pre-provisioned resources using Recipes.

### Radius Application Graph and Dashboard

The application graph concept and experience introduced by Radius has enabled an application-centric approach in developing software. The Radius team is investing in both the API to interact with this graph, as well as new ways to enrich applications with additional information and capabilities. Users have expressed interest in leveraging the concept of the Radius application graph and its corresponding data to power visual experiences for operators and developers. Today we have [`rad app connections`](https://docs.radapp.io/reference/cli/rad_application_connections/) functionality in the CLI to list the connections and resources in a Radius application, which has garnered positive initial feedback and motivates the Radius maintainers to expand upon the features:

- [**Application Graph API**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750561): The [Application Graph API](https://docs.radapp.io/concepts/application-graph/#mine-the-app-graph-api) was released as a part of v0.27 that allows users to mine the application graph data. We will continue to expand and improve upon the API to support more use cases.
- [**Radius Dashboard**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750597): The goal is to deploy a lightweight developer portal alongside the Radius control plane to provide a developer dashboard that allows users to visualize and explore their application graph. Extensibility and ability to integrate into existing developer portals and tools will be key considerations for this feature.

### Serverless container runtime

The Radius maintainers are committed to expanding the platform to support more infrastructure technologies and meet developers where they are, beginning with serverless container runtimes.

- [**Serverless container runtime**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750916): Given the importance of serverless infrastructure in the modern application landscape, it is a priority for Radius to support serverless resources. The initial expansion will focus on support for an unopinionated serverless container runtime before exploring integrations with other serverless platforms.

## Learn more and contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We're looking for people to join us!  To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).