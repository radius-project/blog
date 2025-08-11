---
date: "2025-08-11"
title: "Contribute Your First Resource Type and Recipe"
linkTitle: "Radius Resource Types Contributions"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: blog
---

Radius helps platform engineers build powerful Internal Developer Platforms (IDPs) with curated resource catalogs that empower developers to build applications that adhere to all enterprise best practices. Key to delivering custom resource catalogs is the **Radius Resource Types** feature. 

Think of Radius Resource Types as the developer's interface to your platform. They define a contract—a set of properties developers use to provision infrastructure without needing to know the implementation details. Platform engineers then create [**Recipes**](https://docs.radapp.io/guides/recipes/overview/)—the implementation of that contract—using tools like Terraform or Bicep to deploy and manage the actual cloud resources, ensuring that best practices related to security, compliance, and cost are followed by default.

While Radius ships with a catalog of common resource types, the true power of Radius is unlocked when the community extends it by creating a **shared library** of Resource Types. Shared Resource Types, enable you and the community to model any service or technology, from a niche cloud service to a complex, multipart web application.

This post explains how to contribute Resource Types and Recipes to the Radius ecosystem, with the goal of enabling a rich, community-driven library that benefits everyone.

## Contribution Process Overview

Contributions to the `resource-types-contrib` repository are categorized into three maturity levels. This allows for a flexible contribution process, where you can start small and collaborate with the community to mature your Resource Type over time.

- **Alpha**: This is the entry point for all new contributions. At this stage, the focus is on sharing your experimental work. You'll need a valid schema, at least one working Recipe for any platform, basic documentation, and evidence of manual testing.

- **Beta**: As a contribution matures, it can be promoted to Beta. This stage indicates that the Resource Type is well-tested and ready for broader use. Beta requirements include having Recipes for all major platforms (AWS, Azure, Kubernetes) in both Bicep and Terraform, along with automated functional tests.

- **Stable**: The final stage is for Resource Types that are considered production-ready and are officially supported by the Radius project. These contributions have 100% test coverage, are fully integrated into the Radius CI/CD pipeline, and have a designated owner for long-term maintenance.

You can find the detailed requirements for each stage in our [contribution guide](https://github.com/radius-project/resource-types-contrib/blob/main/contributing-docs/contributing-resource-types-recipes.md#maturity-levels).

## What Can You Contribute?

You can define any resource specific to your own needs or pick a resource type from the list of [open issues](https://github.com/radius-project/resource-types-contrib/issues). 

We'd love to see contributions for:

- **Databases:** NoSQL, time-series, or graph databases.
- **Messaging:** Message queues or event streaming platforms.
- **AI/ML:** Model serving platforms or vector databases.
- **Cloud Services:** Niche cloud provider services or multi-cloud abstractions.
- **Observability:** Monitoring, logging, or tracing solutions.

The more diverse the contributions, the richer the Radius ecosystem becomes.

## An Example to Get You Started

To showcase what a good contribution looks like, the Radius team has added a [Redis resource type with a Kubernetes recipe](https://github.com/radius-project/resource-types-contrib/pull/5). This alpha-stage contribution provides:

- A complete Redis Resource type schema.
- Both Bicep and Terraform Recipes for Kubernetes.
- Manual testing with a sample application.
- Clear documentation for others to follow.

This serves as a template for community driven development. We encourage you to use it as a reference for your own contributions.

## Step-by-Step Guide

We've structured the process in the [resource-types-contrib repository](https://github.com/radius-project/resource-types-contrib/blob/main/contributing-docs/contributing-resource-types-recipes.md) to be as clear as possible, with three maturity levels for contributions: **Alpha**, **Beta**, and **Stable**.

Here’s the high-level process:

### 1. Set Up Your Contribution
Fork the [resource-types-contrib repository](https://github.com/radius-project/resource-types-contrib) and create a directory for your resource type. The structure is simple and documented in our contribution guide.

### 2. Define Your Schema
Create a `.yaml` schema file for your resource type. This is the developer-facing interface. Key guidelines are documented in our [contribution guide](https://github.com/radius-project/resource-types-contrib/blob/main/contributing-docs/contributing-resource-types-recipes.md#4-define-your-resource-type-schema)

### 3. Create Recipes
Develop Terraform and/or Bicep Recipes to deploy your resource. This is the platform-facing implementation. Key guidelines are documented in our [contribution guide](https://github.com/radius-project/resource-types-contrib/blob/main/contributing-docs/contributing-resource-types-recipes.md#recipe-guidelines)

### 4. Document and Test
Create a `README.md` with an overview, usage instructions, and examples. Most importantly, **test your resource type** with a real application and provide evidence that it works as expected.

### Contribution Checklist
Before you submit a pull request, make sure you have:

- ✅ A schema following the naming conventions.
- ✅ At least one working recipe (Terraform or Bicep).
- ✅ A comprehensive `README.md`.
- ✅ Evidence of successful testing with a sample application.
- ✅ Clear commit messages.

## Filing Issues and Getting Help

Not ready to contribute code? You can still participate!

- **Propose a New Resource Type:** Open an issue in the [resource-types-contrib repository](https://github.com/radius-project/resource-types-contrib) to discuss your idea.
- **Report a Bug:** If you find an issue with an existing Resource type, let us know.
- **Request an Enhancement:** For broader ideas, file an issue in the main [Radius repository](https://github.com/radius-project/radius).

## Get Started Today!

The future of Radius resource types is community-driven. By sharing your experiments, testing each other's implementations, and collaboratively improving the ecosystem, we're building a platform that truly serves the needs of cloud native application developers. As we build out the testing and CI/CD infrastructure for `beta` and `stable` contributions, we look forward to collaborating with you to mature your Resource types and Recipes. Your alpha contributions are the first step in a journey of collaborative development. Together, we can promote them through the maturity levels, ensuring they become robust and reliable components for the entire community.

Ready to contribute? We can't wait to see what you build! 

## Get Involved with Radius

- **Resource Types:** Check out our [tutorial](https://docs.radapp.io/tutorials/create-resource-type/) for step-by-step guides on creating Resource Types and Recipes.
- **Recipes:** Learn more about [Recipes](https://docs.radapp.io/guides/recipes/overview/).
- **Monthly Community Meetings:** Join the [Radius Google Group](https://groups.google.com/g/radapp_io) for announcements.
- **Discord:** Connect with us and other contributors on the [Radius Discord](https://aka.ms/radius/discord).
- **YouTube:** Watch demos and tutorials on the [Radius YouTube channel](https://www.youtube.com/@radapp_io).
- **Docs:** Learn more at [docs.radapp.io](https://docs.radapp.io/tutorials/create-resource-type/).
