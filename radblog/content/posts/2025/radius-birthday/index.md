---
date: "2025-10-20"
title: "Happy 2nd Birthday, Radius!"
linkTitle: "Happy 2nd Birthday, Radius!"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: blog
---

On October 18, 2025 we celebrated two years since Radius was released as an open-source project! This milestone gives us a chance to reflect on our collective journey and the significant progress made with the community. This past year has been transformative for Radius, with a focus on providing an extensibility model for enterprises adopting Radius into their internal developer platforms, to adding capabilities that improved operational maturity of the platform.

The Radius community has grown with new contributors, thoughtful feedback, and collaborative feature development. We've delivered consistent monthly releases with features that catered to both application developers and platform engineers, and improved product documentation and community resources. We extend our sincere gratitude to everyone who has participated, contributing code, writing documentation, testing features, and providing feedback. Your contributions have been essential to Radius' progress, and we're excited to continue this collaboration as we further evolve the platform.

## Highlights of the Past Year

- **Radius Resource Types** are one of the most transformative enhancements to the platform this year because they make Radius fundamentally extensible. Instead of being limited to a fixed catalog of built-in resources, platform engineers can now define custom resource types tailored to their organization’s workflows, policies, and infrastructure. Resource types act as a contract between application developers and their internal developer platform, abstracting away the complexity of underlying cloud resources while enabling seamless integration with existing Infrastructure-as-Code tools like Terraform and Bicep. This decoupling of resource definition from implementation empowers platform teams to enforce best practices and evolve infrastructure without disrupting developer workflows, while developers gain a simplified, application-centric experience. In short, resource types unlock innovation, flexibility, and scalability—positioning Radius as a cornerstone for building modern internal developer platforms. We are building a community driven library of Resource Types and Recipes in [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository to accelerate adoption and provide best practices for defining application centric abstractions in Radius.

- **Native GitOps Integration** with built-in Flux integration now enables teams to promote application and infrastructure updates from Git while Radius keeps the desired state synchronized. The integration includes a new Radius Flux Controller that watches for changes in Git repositories containing `radius-gitops-config.yaml` files and a DeploymentTemplate Controller that creates, updates, or deletes applications based on these configurations. This brings the operational benefits of GitOps workflows while preserving Radius's application-centric approach.

- **Multi-platform support beyond Kubernetes** through first-class integration with Azure Container Instances (ACI), enabling serverless container deployments without changing application definitions. This advancement demonstrates Radius's platform-agnostic vision, allowing the same application to deploy across different compute platforms while maintaining a consistent developer experience. 

- **In-place control plane upgrades** introduced in v0.50.0 with the `rad upgrade` and `rad rollback` commands, making it significantly easier to keep Radius installations up-to-date without disrupting environments or applications. This feature includes preflight safety checks that validate cluster health, permissions, and version compatibility before any changes are made, with built-in rollback capabilities for fast recovery if needed.

- **Enhanced usability improvements** across multiple releases for destructive operations like `rad uninstall kubernetes`, `rad group delete` and `rad app delete`

## Community and Ecosystem

We have had fruitful engagements with the community through various events and contributions. Our community has grown to ~883 members engaging on Discord and ~864 contributions to a wide range of areas, including some significant features that unblocked specific user scenarios. Highlights include:

- [**MYSQL Resource Type and Recipe**](https://github.com/radius-project/resource-types-contrib/tree/main/Data/mySqlDatabases) contributed by community member Andrew, enabling developers to easily add MySQL databases to their applications using a simple Resource Type definition, with the underlying infrastructure provisioned via a Bicep Recipe.

- **KubeCon EU 2025** session with Millennium BCP showcased Radius as the IDP application layer, including live multi-cloud demos and custom resource catalogs [KubeCon EU 2025](https://youtu.be/ZmcZlDCYDgE?si=M4FlrKtBcz23Edw2).

- **Mark Russinovich's Ignite session**, highlighted how the platform maps real-world collaboration between developers and operators [Inside Azure Innovations](https://youtu.be/lHBo_lDWFcI?si=kD3fTzkps8cogIK5&t=2270).

## What's Next

- **Extending Radius to even more serverless container runtimes** Per above, we've added support for ACI, and have other runtimes, like AWS Elastic Container Service in the Radius backlog. 

- **Radius for Air-Gapped Environments** to meet strict enterprise security and compliance needs by enabling installations and ongoing operations in fully isolated or heavily restricted networks.

- **Introducing fine-grained authorization**, so platform operators can manage access to Radius Resource Groups, Environments and Recipes.

Thank you to every maintainer, contributor, speaker, and demo author who invested time in the Radius repositories, documentation, and community sessions—your efforts power the shared progress we celebrate today.

## Learn More and Get Involved

We would love for you to join us to help build Radius:

- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/)
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
