---
date: "2023-12-06T08:00:00-08:00"
title: "Case Study: How Millennium bcp leverages Radius"
linkTitle: "Case study: Millennium bcp"
author: "[Nuno Guedes](https://www.linkedin.com/in/nunoguedes)"
type: blog
---

{{< image src="images/logo.svg" alt="Millennium bcp logo" >}}
<br />

[Millennium bcp](https://ind.millenniumbcp.pt/) is Portugal’s largest privately owned bank, with over 1,300 branches serving more than 6 million customers around the world. In the ever-evolving landscape where finance intersects with technology, we consistently focus on generating business value through innovation and excellence. In our pursuit of delivering exceptional services to our customers, we understand the value of technical leadership and one of the keys to our vision and success has been continued use of the latest technologies to generate business value. We were among the first in our market to introduce ATMs and alternative payment methods, and one of the first to deploy online services like transactional websites and an online financial marketplace.

We have been a leader in the adoption of cloud technologies, and have been using Kubernetes in production since 2019. The bank has also been a strong supporter of open-source software (OSS), and has contributed to multiple OSS projects. The bank’s digital transformation strategy is based on a cloud-first approach, and we have been working to build a platform that can be used by all development teams to accelerate application development and deployment while ensuring security, compliance, and operational excellence.

We also have an extensive and diverse application portfolio that has evolved over the years to serve a multitude of business functions. However, efficiently managing this expansive application portfolio while upholding best practices and principles has posed a difficult challenge.

It is within this context that we are proud to be part of the select group of companies that are early adopters of Radius, seeking to standardize processes, expedite developer workflows, and future-proof our infrastructure and enroll in this transformative journey that has reshaped our approach to application definition, governance, and development. Adopting Radius is more than just an initiative; it is an example of our commitment to excellence in every facet of our technological operations. It signifies our dedication to enhancing customer experiences, streamlining operations, and reinforcing our position as an industry leader.

In this technical case study, we will detail how Radius was adopted at Millenium bcp. We will walk through our target developer experience, the platform we began building on KubeVela, what we learned along the way, and why we decided to move to Radius. Throughout this case study we will highlight our methodologies, tools, and strategies that have empowered us to navigate the intricacies of effectively managing a large, complex application portfolio.

## Scoping the Problem

It was clear to us that the pressure to deliver new features and applications and the infrastructure to support them was ever-increasing while, unfortunately, the resources to support that drive were not infinite. Aligning expectations between the multiple teams involved was a challenge. We needed to find a way to accelerate the application lifecycle, from implementation to decommissioning while maintaining focus on all requirements that a financial services company has. Clear requirements definition was also a challenge, as development teams and infrastructure teams have different backgrounds and concerns. We needed to find a way to align these teams, and to ensure that the requirements were clear and unambiguous.

Beyond day 1 operations to deploy new features and applications, we also needed to improve decoupling between applications and infrastructure implementations, as those two lifecycles seldomly matched. The need to change an infrastructure deployment pattern should not have an impact in the application lifecycle, as well as the other way around. A common interface between applications and infrastructure was needed to ensure that the two lifecycles could evolve independently.

Additionally, we needed to ensure that the platform would be cloud-agnostic and would allow applications to be deployed and managed across multiple clouds. This would allow us to take advantage of the best features of each cloud provider, and to avoid vendor lock-in, while complying with regulatory requirements.

Finally, a large Terraform code base already existed for infrastructure lifecycle automation, and we needed to find a way to leverage that code base while ensuring that the infrastructure lifecycle was aligned with the application lifecycle.

## From 8 days to 8 minutes at Millennium bcp

Prior to leveraging Radius, we decided that it was critical to build a platform that would allow developers to focus on their applications, while allowing infrastructure teams to focus on the underlying infrastructure. Our goal was to improve from days of work to just minutes when deploying an application across all environments. This includes the ability to deploy across multiple clouds, meeting the cloud-agnostic requirements of the bank. This platform is based on a set of application patterns, supported by an internal software framework that generates a clear definition of the application and its infrastructure requirements. These patterns, or abstractions, allow Millennium bcp to make application definitions and lifecycles first-class entities in the IT landscape.

By having known patterns and contracts, the bank can provide a self-service experience to developers, allowing them to focus on their applications and not on the underlying infrastructure. This self-service experience is also available to infrastructure teams, who can now focus on the infrastructure and not on application details.

## Our original platform

In the first design of our platform, we decided to use a mix of current and new technologies to support our initial use cases, focusing on targeting the most commonly used resource types by container-based applications:

{{< image src="images/idp_v1.png" alt="Diagram of original MBCP platform" width="1000px" >}}

### The developer story

In this version, application developers use a [Backstage](https://backstage.io/)-based portal to define their applications and their infrastructure requirements. Developers select from well-known patterns the one that applies to their task, along with a set of options and dependencies to be provided to the application. These can range from a simple database in any of the available database engines, to caching mechanisms, messaging resources, identity and observability resources. In any of these resource types only IT business related variables exist (_such as the SKU_), with all implementation details hidden from developers and handled by the platform.

{{< image src="images/service_catalog_1.png" alt="Screenshot of Backstage service catalog" width="1000px" >}}

_Developers can select from pre-defined patterns the one that meets their needs_

{{< image src="images/service_catalog_2.png" alt="Screenshot of Backstage service catalog" width="1000px" >}}

_Only business-related configuration is exposed to developers, instead of the underlying implementation_

In about 3 minutes, the initial setup for an application is ready, including the setup of Azure DevOps resources (_teams, projects, repos, pipelines, etc._) and the initial code commit. Within the repo is a JSON file that describes the application, including the previously selected infrastructure dependencies.

Developers can, at any time, change the application infrastructure requirements by changing this JSON file and commit it to the git repo. Focusing on this application abstraction, developers do not concern themselves with wiring up the application to the infrastructure dependencies, as that is always handled by the platform.

As CI/CD pipelines deliver the application to multiple target environments, that JSON file is converted to an [Open Application Model](https://oam.dev/) representation and pushed to a git repo, triggering the infrastructure story when [Flux](https://fluxcd.io/flux/) delivers it to a Kubernetes cluster.

### The infrastructure story

Upon delivery of the Application OAM resource to a cluster, [KubeVela](https://kubevela.io/) would, based on custom component and trait definitions by Millennium bcp, create the required resources to support the application. These resources are created either directly (_Kubernetes objects_), or leverage [Crossplane](https://www.crossplane.io/) compositions and [Terraform](https://www.terraform.io/) modules. On successful creation of the infrastructure resources, KubeVela would then wire up the application to those resources by injecting environment variables into the application deployments. Infrastructure dependency updates follow the same path, with existing resource state being compared to the desired state, and any change being automatically implemented.

At this time, there was also a decision to start moving the existing Terraform code base that existed to Crossplane, so that a process of continuous drift detection and remediation could be implemented. This would allow us to ensure that the infrastructure was always in the desired state, and that any drift would be automatically corrected.

### What we learned

This initial version of the platform allowed us to validate the concept of using a common language to define applications and their infrastructure requirements and the concept of using a common framework to generate the application code base. Adoption of the platform was also very positive, with developers being able to focus on their applications and not on the underlying infrastructure and achieving the performance goals initially set.

However, we also learned that the initial design had some challenges, namely:
- Maintaining the Backstage-based portal was a challenge, as it required a lot of custom code to support the desired workflows within the Backstage framework.
- Some design choices behind KubeVela did not align with our requirements, as we wanted this component to focus on infrastructure orchestration and choreography, rather than trying to address the entire application lifecycle with its own internal algorithms.
- The number of moving parts was high, generating complexity and increased cognitive load to the teams involved in designing, implementing and maintaining the platform.

## The role of the Radius project

We found our same vision in Radius, where challenges such as multi-cloud, architecture best practices, multiple release cadences for apps and infra, and cognitive overload are addressed using concepts like [Recipes and Environments](https://docs.radapp.io/concepts/collaboration/).

With Radius, infrastructure implementation details can be handled exclusively by internal infra product teams, exposing only IT business variables to our IT customers in Recipes, abstracting complexity, and ensuring design decisions are made by the right people. Developers can also focus on identifying what is relevant for their applications, without having to go into implementation concerns, knowing that those Recipes available to them have already taken care of those. This common contract correctly refocuses teams: developers focus exclusively on evolving the application and infrastructure teams can now manage infrastructure with a clear understanding of application dependencies. Also, a Radius environment is created for each internal product team's target environment, providing the required isolation for each team and their workloads but also allowing for resource sharing within that team.

In this new approach, instead of our JSON application definition we leverage the [Bicep language](https://github.com/Azure/Bicep). Developers interact with Bicep application definitions using the rich set of available tooling and validation, providing a first-class application experience. For infrastructure management, Recipes allow our infra product team to leverage our existing Terraform and Crossplane codebase. Radius [extender resources](https://docs.radapp.io/guides/author-apps/custom/overview/) plus Recipes meet us where we are today by supporting any resource type, even our custom resources that are [not yet](https://github.com/radius-project/radius/issues/6688) supported natively in Radius.

Radius becomes our main infrastructure orchestration and choreography tool, with the ability to target multiple cloud (and on-premises) providers through multiple infrastructure implementation patterns for the same infrastructure resource types, allowing us to bind multiple release cadences for applications and infrastructure in an agile and well-governed way.

{{< image src="images/idp_v2.png" alt="Diagram of MBCP platform with Radius" width="1000px" >}}
<br />

While Radius does [not yet](https://github.com/radius-project/radius/issues/6689) support a GitOps approach, we are working together with the Radius maintainers and community to make this a supported scenario. Until that is available, the [Radius CLI](https://docs.radapp.io/guides/tooling/rad-cli/overview/) is used from CI/CD pipelines to deploy infrastructure requirements to the target environments.

## Moving forward

As our Radius adoption journey continues, we are looking forward to continue leveraging Radius to support our application development and deployment needs. There are interesting challenges ahead, such as supporting additional resource types and decoupling resource management control planes from clusters running business workloads. We are looking forward to working with the Radius maintainers and community in the [monthly community calls](https://github.com/radius-project/community?community-meetings) and in [Discord](https://aka.ms/radius/discord) to address those challenges.