---
date: "2024-08-12T00:00:00"
title: "How to Participate in the Radius Design Process"
linkTitle: "Radius Design Process"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: blog
---

If you are interested in collaborating with the community to influence, design, and build the newest features in Radius, then you've come to the right place. From upvoting roadmap items to authoring and submitting design proposals, this blog post will walk you through all the ways you can participate in the Radius design process. Radius enables developers and platform engineers who support them to collaborate on delivering and managing cloud-native applications that follow corporate best practices for cost, operations, and security by default. You can help realize this vision by providing your input on the Radius roadmap and by engaging in the community design process to improve Radius features.

## Help shape the Radius feature roadmap

The [Radius roadmap](https://aka.ms/radius-roadmap) reflects the current feature plan for the project. After every release, the roadmap is refined to reflect the latest input from the Radius community.  You can contribute to the roadmap in the following ways:

- Provide feedback to influence roadmap decisions by commenting on and upvoting [existing items](https://aka.ms/radius-roadmap)

- Propose a feature for the roadmap.  To do so, submit a new [feature request](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E). The Radius maintainers regularly review all feature requests and determine which to add to the roadmap.

Bookmark the [**Radius roadmap**](https://aka.ms/radius-roadmap) to stay up to date.

## Influence feature designs 

All design proposals, enhancements and architectural decisions for Radius are documented in the [design notes repository](https://github.com/radius-project/design-notes). By providing this consolidated record of all major decisions and changes, the Radius maintainers hope to bring clarity and transparency to the Radius community. Once a feature is accepted into the Radius roadmap, any contributor can submit a design proposal to the design notes repository.

 - If you are interested in proposing a design:
        
    - Confirm there is a GitHub Issue describing the feature in the [Radius repository](https://github.com/radius-project/radius).  If not, submit a new [feature request](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E).

    - **Feature Specification proposal**: Write a feature specification following this [template](https://github.com/radius-project/design-notes/blob/main/template/YYYY-MM-feature-spec-template.md) and submit a PR. This document covers the _what_ and _why_ of a feature. It includes the problem statement, personas, user experience and impact of the feature on the Radius community.  For example, the [Feature Specification for Gitops support in Radius](https://github.com/radius-project/design-notes/blob/main/tools/2024-06-gitops-feature-spec.md) covers the what and why of Radius integration with GitOps tools. The feature specification document precedes the technical design proposal.

    - **Technical Design proposal**: Once the feature specification is approved, create a design proposal document following the [template](https://github.com/radius-project/design-notes/blob/main/template/YYYY-MM-feature-spec-template.md) and submit a PR. This document covers the _how_, i.e. the technical design details of the feature, including architecture, design decisions, implementation details, and testing strategy. The technical design proposal precedes implementation. For example, the [Technical Design for supporting any Terraform providers](https://github.com/radius-project/design-notes/blob/main/recipe/2024-02-terraform-providers.md) covers the in-depth design and implementation details of supporting any Terraform provider in Radius. 

 - If you are interested in contributing to existing designs, you can do so by reviewing the in-progress [design proposals](https://github.com/radius-project/design-notes/pulls). You can provide feedback and suggestions by commenting directly on the proposals.

These documents are reviewed by the Radius maintainers and community members within a week of submission. Reviewers provide feedback and suggestions to ensure features are well-designed and meet user requirements. Feature specifications and technical designs must be approved by a Radius maintainer before they can be merged into the design notes repository (and before implementation can begin). If you have questions or need help with a design proposal, reach out in the [Designs channel in Discord](https://discord.com/channels/1113519723347456110/1267883683302473834).

## Learn more and contribute

We're looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).