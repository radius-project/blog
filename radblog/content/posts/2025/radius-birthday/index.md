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

- **Radius Resource Types** are one of the most transformative enhancements to the platform this year because they make Radius fundamentally extensible. Instead of being limited to a fixed catalog of built-in resources, platform engineers can now define custom resource types tailored to their organization’s workflows, policies, and infrastructure. Resource Types act as a contract between application developers and their internal developer platform, abstracting away the complexity of underlying cloud resources while enabling seamless integration with existing Infrastructure-as-Code tools like Terraform and Bicep. This decoupling of resource definition from implementation empowers platform teams to enforce best practices and evolve infrastructure without disrupting developer workflows, while developers gain a simplified, application-centric experience. We are building a community driven library of Resource Types and Recipes in the Radius [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository to accelerate adoption and provide best practices for defining application-centric abstractions in Radius.

- **Native GitOps Integration** built-in Flux integration enables teams to promote application and infrastructure updates from Git while Radius keeps the desired state synchronized. The integration includes a new Radius Flux Controller that watches for changes in Git repositories containing `radius-gitops-config.yaml` files and a DeploymentTemplate Controller that creates, updates, or deletes applications based on these configurations. This brings the operational benefits of GitOps workflows while preserving Radius's application-centric approach.

- **Support for serverless platforms** Radius now has first-class integration with Azure Container Instances (ACI), which enables deploying the same application, unchanged, to either a Kubernetes cluster or to ACI. This demonstrates Radius's runtime-agnostic vision, allowing the same application to deploy across different compute platforms while maintaining a consistent developer experience. 

- **In-place control plane upgrades** introduced in v0.50.0 with the `rad upgrade` and `rad rollback` commands, makes it easy to keep Radius up-to-date. This feature includes preflight safety checks that validate cluster health, permissions, and version compatibility before any changes are made. It also includes built-in rollback capabilities for fast recovery as needed.

- **Usability improvements** across multiple releases have improved the developer and platform engineering experience. Key improvements include:
    - **Radius Dashboard**: Platform engineers can publish organization-specific resource types with rich Markdown docs that includes details on how and when to use them, and developers browse them in one place instead of trawling CLI output. The environment page shows additional details about the Kubernetes cluster and the cloud provider configuration.

        {{< image src="images/resource-types.png" alt="Screenshot of Radius Resource Types" width="70%">}}
        <br>
        {{< image src="images/environment.png" alt="Screenshot of Radius Environment" width="70%">}}
    
    - **Radius CLI**: Interactive confirmation prompts for destructive operations like `rad uninstall kubernetes`, `rad group delete`, and `rad app delete` that clearly explain what resources will be affected, preventing accidental data loss.

## Community and Ecosystem

We have had fruitful engagements with the community through various events and contributions. Our community has grown to ~883 members engaging on Discord and ~864 contributions to a wide range of areas, including some significant features that unblocked specific user scenarios.

**Key community contributions:**

- [MySQL Resource Type and Kubernetes Recipe](https://github.com/radius-project/resource-types-contrib/tree/main/Data/mySqlDatabases) contributed by [Andrew Matveychuk](https://github.com/andrewmatveychuk).
- [Neo4j Resource Type and Kubernetes Recipe](https://github.com/radius-project/resource-types-contrib/pull/58) contributed by [Nick Beenham](https://github.com/superbeeny).

**Community events and talks:**

- [KubeCon EU 2025](https://youtu.be/ZmcZlDCYDgE?si=M4FlrKtBcz23Edw2) session with Millennium BCP showcased Radius as the IDP application layer, including live multi-cloud demos and curated resource catalogs.
- [KubeCon US 2024 BackstageCon](https://youtu.be/U2-Lo-yuvdc?si=Tm_GlKQg5SVMQLyz) session showing how Radius integrates with Backstage to visualize environments and deployed applications.
- [Mark Russinovich’s community presentation on Radius Resource Types](https://youtu.be/MNuoMSIs4Jo?si=XI1Uh1Ej7a1uhLEo) outlining the extensibility feature and how platform teams can share reusable abstractions across organizations.
- [Microsoft Build 2025](https://youtu.be/lHBo_lDWFcI?si=kD3fTzkps8cogIK5&t=2270) session with Mark Russinovich spotlighting how Radius aligns developers and platform engineers on real-world deployments.

## What's Next

- **Extending Radius to even more serverless container runtimes** with support for AWS Elastic Container Service (ECS) and Azure Container Apps on the roadmap.

- **Air-gapped environment support** with offline installation, configuration, and upgrades so organizations with strict security requirements can vet and cache packages and control dependency versions without internet access.

- **Radius Resource Types for AI workloads.** As AI reshapes both applications and software delivery workflows to include developers pairing with agents and services that spans beyond Kubernetes, hosted models, databases, queues, and storage, platform engineers must keep both developers and agents aligned with security, cost, and operational guardrails. Check out this blog post on [how you can future proof your AI applications with Radius Resource Types](https://blog.radapp.io/posts/2025/07/18/future-proofing-ai-applications-via-radius-resource-types/). More updates coming soon.

## Thank You

Thank you to every maintainer, contributor, speaker, and demo author who invested time in Radius. The result of your efforts are what we celebrate today.

## Learn More and Get Involved

We would love for you to join us to help build Radius:

- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/)
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
