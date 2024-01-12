---
date: "3024-01-31T08:00:00-08:00"
title: "Introducing the Radius feature roadmap"
linkTitle: "Introducing the Radius roadmap"
author: "Radius project maintainers"
type: blog
---

The Radius project maintainers are excited to share our [feature roadmap for Radius](https://aka.ms/radius-roadmap)! We are looking forward to working with the community to grow and enhance Radius and will keep this roadmap updated as we make progress.

Bookmark the [**Radius roadmap**](https://aka.ms/radius-roadmap) for updates on the full set of roadmap priorities.

{{< image src="images/gh-roadmap.png" alt="screenshot of the Radius roadmap board from GitHub" width=900 >}}

<br>

We hope to encourage transparency in community engagement and collaboration by sharing our roadmap and priorities. Please treat the roadmap as a living document that reflects the current goals and plans of the project, which may change based on the landscape and community needs. Thus, target delivery dates are deliberately avoided. To remain agile and adaptive, after each release the Radius maintainers will reassess and update the roadmap as necessary to reflect the latest priorities. Additionally, note that the roadmap currently reflects the priorities of the project maintainers, but as more partners join us these may change. The community may also work on things that aren't part of the roadmap.

## Provide feedback and contribute

All feedback and contributions are welcome! The community is encouraged to engage with the Radius project in the following ways: 

- Provide feedback to influence roadmap decisions by commenting on and upvoting [existing items](https://aka.ms/radius-roadmap)
- Submit new [feature requests](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E) to propose new functionality or and other [issue reports](https://github.com/radius-project/radius/issues/new/choose)
- Review in-progress [designs](https://github.com/radius-project/design-notes/pulls) and [code](https://github.com/radius-project/radius/pulls)
- Contribute directly to fix [open issues](https://github.com/radius-project/radius/issues) and [documentation](https://github.com/radius-project/docs/issues)
- Engage with the Radius community via the [monthly community calls](https://github.com/radius-project/community?community-meetings) and [Discord](https://aka.ms/radius/discord)

## Immediate priorities

At this stage of the project, building an active and diverse open-source community for Radius is our top priority and we will focus on work that accelerates the growth of our community and adopters. Items like testing, pipelines, automation, and bug fixes that make life easier for open-source contributors will be prioritized. In terms of feature work, we are investing in what our community and users have identified as our most strategic areas: Recipes, Application Graph, and platform expansions. Below we'll discuss the top priority areas and features for Radius in more detail.

### Radius Recipes

The initial public release of Radius offers end-to-end Recipe deployment and deletion for both Bicep and Terraform templates. This unlocks a basic resource lifecycle for learning about and leveraging Recipes in simple applications. Based on what we're hearing from users, these are the most requested features to further enhance the Recipes experience:

- [**Private Terraform modules**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47722965): Today Radius only supports public Terraform modules. The first addition to Terraform Recipes we need to add is support for private modules from the Terraform module gallery or from other private sources.
- [**Recipe “stickiness” and versioning**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47749189): Operators need to be able to update & make changes to Recipes within an environment. Today this requires any resource using the Recipe to immediately start using the new Recipe template/version upon the next deployment. This may break developers not expecting changes to their infrastructure. We need a way to make this configurable, where teams can control how new Recipe templates are rolled out, along with a versioning strategy.
- [**Ability to configure which IaC languages are supported**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47749391): There has been some feedback around being able to selectively disable specific Recipe languages (_e.g. disable Bicep or Terraform Recipes per IT policies_). Given the compliance-related nature of this ask, we have prioritized it.
- [**Recipes for any Resource**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750131): Today we only support portable resources (Applications.Dapr, Applications.Datastores, Applications.Messaging) for Recipes. As part of our Recipes enhancement, we want to support any resource across Azure, AWS, and more. This would allow operators to define a template for something like an S3 bucket and the developer can request “an S3 bucket” without knowing the details.

### Radius Application Graph

Users have expressed interest in leveraging the Radius application graph to power visual experiences for operators and developers. Today we have [`rad app connections`](https://docs.radapp.io/reference/cli/rad_application_connections/) functionality in the CLI to list the connections and resources in a Radius application, which has garnered positive initial feedback and motivates the Radius maintainers to expand upon the Application Graph features:

- [**Application Graph API**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750561): The [Application Graph API](https://docs.radapp.io/concepts/application-graph/#mine-the-app-graph-api) was released as a part of v0.27 that allows users to mine the application graph data. We will continue to expand and improve upon the API to support more use cases.
- [**Radius Dashboard**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750597): The goal is to deploy a lightweight developer portal alongside the Radius control plane to provide a developer dashboard that allows users to visualize and explore their application graph. Extensibility and ability to integrate into existing developer portals and tools will be key considerations for this feature.

### Platform expansions

The Radius maintainers are committed to expanding the platform to support more infrastructure technologies and meet developers where they are. We are currently prioritizing the following platform expansions:

- [**Connecting to existing resources**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750466): Users have consistently expressed a need for the capability to connect to existing resources that were previously provisioned and existed outside of the scope of the Radius application. This is especially important to further enable incremental adoption of Radius. The most immediately prioritized work is to enable Radius to connect to such existing pre-provisioned resources using Recipes.

- [**Serverless container runtime**](https://github.com/orgs/radius-project/projects/8/views/1?pane=issue&itemId=47750916): Given the importance of serverless infrastructure in the modern application landscape, it is a priority for Radius to support serverless resources. The initial expansion will focus on support for an unopinionated serverless container runtime before exploring integrations with other serverless platforms.

## On the horizon

There is a lot of other work in the backlog that will ultimately be high value to Radius users, but is less time critical than the immediate priorities above that we have frontloaded. The following are some of the features on the Radius roadmap that we intend to tackle as soon as we can. Feedback and upvotes are welcome in their respective issues.

### Further Recipes enhancements

- **Shared infrastructure**: Today a Recipe can either deploy all the infrastructure it needs, or existing infrastructure can be passed in as a parameter. The latter allows for shared accounts/servers with unique databases/tables. For example, an enterprise wouldn't want to spin up 20 CosmosDB accounts each with a single database. Further, an enterprise wouldn't want to spin up a CosmosDB account, SQL Server, and more just in case one of their developers might want to use one of the Recipes in an environment. We need a way for a “create if not exists” functionality to deploy a shared piece of infrastructure when it's first needed. On the flip-side a “delete if not used” capability is also needed for cleanup.

- **Recipe packs**: Today Recipes are individually managed. Installing multiple Recipes at a time requires scripting the `rad` CLI or listing each individually in the environment's Bicep definition. We need a packaging mechanism to bundle related Recipes and version them, allowing organizations to share their Recipes, either private or public, with Radius users.

- **Expand Recipe experience**: We currently provide Recipe support for Bicep and Terraform, but there is opportunity to expand Recipes experience to other IaC technologies, like Script and Helm.

- **Recipes for Gateways**: Today we've “hard-coded” the mapping between a Radius Gateway and the Contour HttpRoute Kubernetes objects. This got us up and running with gateways and allowed offer basic internet-facing routing and termination. Customers have provided feedback that they want to use other ingress controllers (Nginx, Kong, Traefik, Azure Application Gateway) or customize how the underlying Kubernetes/Azure objects are created. Recipes present the perfect concept for managing how Gateway infrastructure is created.

- **Recipes for user-defined types**: Further customization to allow for user-defined types in Recipes.

### Further Dashboard enhancements

Beyond the Application Graph API and simple dashboard via Backstage plugin, we would like to deliver additional Dashboard capabilities. These features tracked in our backlog include additional extensions for other developer tools like VSCode, other Backstage plugins for Recipes, Resource Provisioning, etc.

### Dapr integration into control plane

Improving observability and security of the Radius control plane itself includes adding more logging and metrics such as support for dependency service tracing and monitoring. Given that Dapr may offer many of these enhancements, we are inclined to integrate Dapr into the Radius Control Plane. We'll continue to gather the needs from the community to determine what other observability functionality is needed for using Radius in production scenarios.

### Expanding AWS support

The current implementation of AWS support is an important first step towards modeling AWS as a first-class citizen in Radius' multi-cloud strategy. We would like to further expand AWS support with additional key features, including support for non-idempotent AWS resources and for AWS Identity and Access Management (IAM).

### Identity management

Today, Radius leverages the same identity and credentials as those used to authenticate into accounts when the user registers a cloud provider via their respective CLIs. However, we often receive questions and even desire from users to be able to specify more explicit and precise RBAC policies within Radius.

### Azure Arc integration

[Azure Arc](https://azure.microsoft.com/en-us/products/azure-arc/) is a set of technologies that extends the Azure platform to on-premises, multi-cloud, and edge environments. It allows customers to build applications and services with a consistent development, operations, and security model. It also enables customers to have a central, unified, and self-service approach to manage their Windows and Linux Servers, Kubernetes clusters, and Azure data services wherever they are. There has been interest expressed by the community and users for Radius and Azure Arc integration.

### rad CLI enhancements

Although the rad CLI is in a state that's useful for users beginning to build with Radius, there are some functionality gaps that need to be filled (e.g. lack of credential validation, environment scoped operations, etc.). The team will closely monitor community feedback and prioritize CLI functionality as appropriate.

### Expand Kubernetes and Helm integrations

The first iteration of a Kubernetes Interop layer provides functionality to leverage Kubernetes YAML, PodSpec, and Helm Charts to deploy Radius-aware applications such that features like Connections, Recipes, and Application Graph can be incrementally adopted into an existing application. The Radius maintainers are closely monitoring feedback and issues coming from the community to expand on these features as necessary.

### Radius Terraform provider

Today Radius supports the Bicep language for modeling applications, environments, and other Radius resources. We're considering adding other IaC languages, such as Terraform, for modeling resources as well.

### Application model maturation

There are aspects of the Radius application model we would love to continue to extend, such as support for sidecars, additional standard resources like PostgreSQL, autoscaling of applications, and more, These enhancements will be prioritized based on community feedback and user need.

### Universal Control Plane improvements

There are a few planned enhancements to the Radius Universal Control Plane (UCP), including UCP Proxy and memory/CPU optimizations, which will be prioritized based on feedback and need.

## Learn more and contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We’re looking for people to join us!  To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).