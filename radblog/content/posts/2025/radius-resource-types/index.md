---
date: "2026-06-10T08:00:00-08:00"
title: "Radius Community Call Highlights: Introducing Custom Resource Types!"
linkTitle: "Radius Resource Types"
author: "[TBD](TODO)"
type: blog
---

The Radius Community Call on June 10, 2025, was a special one! We had the privilege of hosting Mark Russinovich, CTO of Microsoft Azure, who joined us to unveil a game-changing new capability in Radius: **Radius Resource Types**. This feature marks a significant step in our journey to simplify and empower cloud-native application development and platform engineering.

If you missed the call, don't worry! We've got the highlights for you right here.

## A New Era of Customization: Radius Resource Types

Mark Russinovich kicked off the discussion by sharing the exciting news of what he termed a "relaunch" for Radius, centered around the introduction of **Radius Resource Types** (often referred to as custom resource types).

So, what are Radius Resource Types? In essence, they allow **you** to define your own resource types within Radius. This means platform engineering teams can create bespoke abstractions tailored to their organization's specific needs, standards, and operational practices.

As Mark explained, this powerful feature was directly inspired by feedback from enterprise customers already leveraging Radius. These users expressed a desire to encapsulate their internal platform models and best practices—such as a custom "failover-enabled database" type—directly within Radius. With Radius Resource Types, this is now a reality.

## How It Works: Building on Recipes and Environments

Radius Resource Types seamlessly integrate with existing core Radius concepts:

*   **Recipes:** These custom types are backed by **recipes**, which define the provisioning logic. Platform teams can implement these recipes using familiar tools like **Terraform modules or Bicep**. This allows them to enforce security, compliance, and cost management policies directly within the resource definitions their developers use.
*   **Environments:** Recipes are registered to Radius Environments. This means a developer can request a custom resource like `mycorp-postgres`, and Radius, based on the target environment (e.g., dev, test, prod), will use the appropriate recipe to provision it. For instance, a `dev` environment might spin up a containerized database, while a `prod` environment provisions a highly available, managed database service, all without the developer needing to change their application definition.

This extends the power of recipes beyond the existing open-source portable types (like MongoDB, Redis, RabbitMQ) and Dapper component types that Radius already supports.

## Why This Matters: Empowering Platform Teams and Developers

The introduction of custom resource types brings several key benefits:

*   **True Separation of Concerns:** It reinforces Radius's core mission to decouple application definitions from underlying infrastructure, making applications more portable and resilient to infrastructure changes.
*   **Enhanced Platform Engineering:** Platform teams gain greater control and the ability to provide a curated, policy-compliant "internal developer platform" experience.
*   **Developer Productivity:** Developers can work with higher-level, familiar abstractions defined by their organization, simplifying their workflow and reducing cognitive load.
*   **Multi-Cloud and Hybrid Ready:** Combined with Radius's Universal Control Plane (UCP), these custom types can orchestrate resources across Azure, AWS, Kubernetes, and potentially other clouds, all from a single application definition.

Mark highlighted the journey of the Incubations team within the Office of the CTO, which has a history of creating impactful open-source projects like KEDA (Kubernetes Event-driven Autoscaler) and Dapper (Distributed Application Runtime)—both now graduated CNCF projects. Radius follows this lineage, aiming to address critical gaps in the cloud-native application lifecycle.

## The Road Ahead

The vision for Radius Resource Types doesn't stop here. Mark also shared a glimpse into future enhancements, including:

*   **Recipe-ifying Existing Cloud Resources:** The ability to apply recipes to *existing* native cloud resource types (e.g., an AWS S3 bucket or an Azure Storage Account). This would allow platform teams to augment or constrain these standard resources with their own policies and configurations when deployed via Radius.
*   **Internal Consistency:** Potentially, even Radius's own built-in types could be implemented using this same powerful recipe mechanism, further unifying the model.

## Get Involved!

We're incredibly excited about the potential of Radius Resource Types to transform how applications are built and managed in the cloud. This is a significant milestone for Radius, and we believe it will unlock new levels of productivity and control for our users.

As Zach Casper mentioned at the end of the call, we'll be sharing links to all the materials and documentation for you to dive deeper. We encourage you to explore this new capability and share your feedback with the community.

Stay tuned to the Radius blog and our community channels for more updates, tutorials, and examples of how to leverage Radius Resource Types.