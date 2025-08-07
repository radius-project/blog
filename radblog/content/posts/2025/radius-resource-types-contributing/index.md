---
date: "2025-08-07"
title: "Extend Radius: Contribute Your First Resource Type and Recipe"
linkTitle: "Radius Resource Types Contributions"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: blog
---

One of the core mission of Radius is to enable platform engineers to build powerful Internal Developer Platforms (IDPs) with curated resource catalog that empowers developers to build applications following all the enterprise best practices. The key to this is **Radius Resource Types**. 

Radius Resource Types are the developer's interface to your platform. They define a contract—a set of properties developers use to provision infrastructure without needing to know the implementation details. Platform engineers then create [**Recipes**](https://docs.radapp.io/guides/recipes/overview/)—the implementation of that contract—using tools like Terraform or Bicep to deploy and manage the actual cloud resources, ensuring security, compliance, and cost best practices are followed.

While Radius ships with a catalog of common resource types, the true power of Radius is unlocked when the community extends it and creates a **shared library** of the Resource Types. By creating and sharing your own Resource Types, you can model any service or technology, from a niche cloud service to a complex, multipart web application.

This blog post will show you how you can contribute your own Resource Types and Recipes to the Radius ecosystem and help build a rich, community-driven library that benefits everyone.

## A Great Example to Get You Started

To showcase what a great contribution looks like, the Radius team has added a [Redis resource type with a Kubernetes recipe](https://github.com/radius-project/resource-types-contrib/pull/5). This alpha-stage contribution provides:

- A complete Redis resource type schema.
- Both Bicep and Terraform recipes for Kubernetes.
- Real-world testing with a sample application.
- Clear documentation for others to follow.

This serves as a template for community-driven development. We encourage you to use it as a reference for your own contributions.

## Start with Alpha: No Contribution is Too Small

We welcome and encourage **alpha-stage contributions**. This is the perfect starting point for:

- **Sharing early work** and experimental ideas.
- **Getting community feedback** to refine your implementation.
- **Collaborating** with others to improve and stabilize your resource.

"Alpha" doesn't mean broken; it means you've built something that works and is ready for community collaboration.

## What Can You Contribute?

You can pick any resource type from the list of [open issues](https://github.com/radius-project/resource-types-contrib/issues). 

We'd love to see contributions for:

- **Databases:** NoSQL, time-series, or graph databases.
- **Messaging:** Message queues or event streaming platforms.
- **AI/ML:** Model serving platforms or vector databases.
- **Cloud Services:** Niche cloud provider services or multi-cloud abstractions.
- **Observability:** Monitoring, logging, or tracing solutions.

You can also pick a resource type that you use in your applications and create a Radius Resource Type for it. The more diverse the contributions, the richer the Radius ecosystem becomes.

## How to Contribute Your Resource Type

We've structured the process in the [resource-types-contrib repository](https://github.com/radius-project/resource-types-contrib) to be as clear as possible, with three maturity levels for contributions: **Alpha**, **Beta**, and **Stable**.

Here’s the high-level process:

### 1. Set Up Your Contribution
Fork the [resource-types-contrib repository](https://github.com/radius-project/resource-types-contrib) and create a directory for your resource type. The structure is simple and documented in our contribution guide.

### 2. Define Your Schema
Create a `.yaml` schema file for your resource type. This is the developer-facing interface. Key guidelines are documented in our [contribution guide](https://github.com/radius-project/resource-types-contrib/blob/main/contributing-docs/contributing-resource-types-recipes.md#4-define-your-resource-type-schema)

### 3. Create Recipes
Develop Bicep and/or Terraform Recipes to deploy your resource. This is the platform-facing implementation. Key guidelines are documented in our [contribution guide](https://github.com/radius-project/resource-types-contrib/blob/main/contributing-docs/contributing-resource-types-recipes.md#recipe-guidelines)

### 4. Document and Test
Create a `README.md` with an overview, usage instructions, and examples. Most importantly, **test your resource type** with a real application and provide evidence that it works as expected.

### A Quick Contribution Checklist
Before you submit a pull request, make sure you have:

- ✅ A schema following the naming conventions.
- ✅ At least one working recipe (Bicep or Terraform).
- ✅ A comprehensive `README.md`.
- ✅ Evidence of successful testing with a sample application.
- ✅ Clear commit messages.

## Filing Issues and Getting Help

Not ready to contribute code? You can still participate!

- **Propose a New Resource Type:** Open an issue in the [resource-types-contrib repository](https://github.com/radius-project/resource-types-contrib) to discuss your idea.
- **Report a Bug:** If you find an issue with an existing Resource type, let us know.
- **Request an Enhancement:** For broader ideas, file an issue in the main [Radius repository](https://github.com/radius-project/radius).

## Get Started Today!

The future of Radius resource types is community-driven. By sharing your experiments, testing each other's implementations, and collaboratively improving the ecosystem, we're building a platform that truly serves the needs of modern application development. As we build out the testing and CI/CD infrastructure for `beta` and `stable` contributions, we look forward to collaborating with you to mature your Resource types and Recipes. Your alpha contributions are the first step in a journey of collaborative development. Together, we can promote them through the maturity levels, ensuring they become robust and reliable components for the entire community.

Ready to contribute? We can't wait to see what you build!

## Get Involved with Radius

- **Monthly Community Meetings:** Join the [Radius Google Group](https://groups.google.com/g/radapp_io) for announcements.
- **Discord:** Connect with us and other contributors on the [Radius Discord](https://aka.ms/radius/discord).
- **YouTube:** Watch demos and tutorials on the [Radius YouTube channel](https://www.youtube.com/@radapp_io).
- **Docs:** Learn more at [docs.radapp.io](https://docs.radapp.io/tutorials/create-resource-type/).
