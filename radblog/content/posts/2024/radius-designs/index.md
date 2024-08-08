---
date: "2024-08-12T00:00:00"
title: "How to Participate in the Radius Design Process"
linkTitle: "Radius Design Process"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: blog
---

If you are interested in collaborating with the community to influence, design, and build the newest features in Radius, then you've come to the right place. From upvoting roadmap items to authoring and submitting design proposals, this blog post will walk you through all the ways you can participate in the Radius design process. The core focus of Radius is to provide a seamless experience for platform engineers and developers to build, collaborate on, and deploy cloud native applications. What better way to achieve this than to engage with the community in building better features and experiences for Radius!

## The Radius feature roadmap

The [feature roadmap for Radius](https://aka.ms/radius-roadmap) is a living document that reflects the current goals and plans of the project, which may change based on community needs. After every release, the roadmap will be updated to reflect the latest priorities and in-progress features. You can engage with the roadmap in the following ways:

- Provide feedback to influence roadmap decisions by commenting on and upvoting [existing items](https://aka.ms/radius-roadmap)

- To add a new roadmap item, submit new [feature requests](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E). The Radius maintainers review all feature requests and determine which to add to the roadmap.

Bookmark the [**Radius roadmap**](https://aka.ms/radius-roadmap) for updates on the full set of roadmap priorities.

## Design notes in Radius 

All design proposals, enhancements and architectural decisions for Radius are documented in the [design notes repository](https://github.com/radius-project/design-notes). By providing this consolidated record of all major decisions and changes, the Radius maintainers hope to bring clarity and transparency to the Radius community.

Once a feature is accepted into the Radius roadmap, any contributor can submit a design proposal to the design notes repository, which can then be reviewed and iterated upon by the Radius maintainers and community. There are two types of design proposals:

- **Feature Specification proposal**: This document covers the _what_ and _why_ of a feature. It includes the problem statement, user personas, user experience and impact of the feature on the Radius community. The feature specification document precedes the technical design proposal. For example, the [Feature Specification for Gitops support in Radius](https://github.com/radius-project/design-notes/blob/main/tools/2024-06-gitops-feature-spec.md) covers the what and how of Radius integration with GitOps tools.

- **Technical Design proposal**: This document covers the _how_, i.e. the technical design details of the feature, including architecture, design decisions, implementation details, and testing strategy. The technical design proposal precedes implementation. For example, the [Technical Design for supporting any Terraform providers](https://github.com/radius-project/design-notes/blob/main/recipe/2024-02-terraform-providers.md) covers the in-depth design and implementation of supporting any Terraform provider in Radius.

These documents are reviewed by community members, who provide feedback and suggestions to ensure that the feature is well-designed and meets the requirements of potential users. Feature specifications and designs must be approved by a Radius maintainer before they can be merged into the design notes repository and implementation may begin.

## Help shape the future of Radius

The Radius project maintainers are excited to collaborate with the community to grow and enhance Radius. This section details on how you can engage with the project and contribute to the design and development of new features in Radius.

 - If you are interested in contributing to existing designs, you may do so by reviewing the in-progress [design proposals](https://github.com/radius-project/design-notes/pulls). You can provide feedback and suggestions by commenting directly on the proposals to help shape the design of the feature.

 - If you are interested in proposing new feature design, you can do the following:
        
    - Make sure a GitHub Issue describing the desired feature is present in the [Radius repository](https://github.com/radius-project/radius) or submit a new [feature request](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E) if not

    - Create a feature specification document following the template [here](https://github.com/radius-project/design-notes/blob/main/template/YYYY-MM-feature-spec-template.md) and submit a pull request to the design notes repository following the guidelines [here](https://github.com/radius-project/design-notes/blob/main/README.md#creating-a-pull-request)

    - Once the feature specification is approved, create a design proposal document following the template [here](https://github.com/radius-project/design-notes/blob/main/template/YYYY-MM-feature-spec-template.md). This document can be authored in parallel with the feature specification document. Submit a pull request to the design notes repository following the guidelines [here](https://github.com/radius-project/design-notes/blob/main/README.md#creating-a-pull-request)

The design proposals are reviewed by the Radius maintainers and community within a week of submission. If you have any questions or need help with design proposal, you can reach out in the [Designs channel in Discord](https://discord.com/channels/1113519723347456110/1267883683302473834).

We encourage you to engage with the project by providing feedback, submitting feature requests, and making code contributions. We are looking forward to working with you in shaping the future of Radius!

## Learn more and contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We're looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).