---
date: "2024-03-20T00:00:00"
title: ""
linkTitle: "Recipes"
author: "[Reshma Abdul Rahim](https://www.github.com/reshrahim)"
type: blog
---

## Platform Engineering and Cloud Native Application Management
Cloud Native application management is a complex endeavour that involves collaboration across the developer and infrastructure operator teams. We learned that there weren’t great tools for collaboration between IT organizations and the developers they were supporting. Collaboration between developers and operators required detailed coordination, resulting in back-and-forth manual processes that slow down development velocity. Most organizations resorted to building custom pipelines or ticketing systems for infrastructure deployments, but these only ease part of the pain without addressing the underlying manual processes. Teams needed a better way to collaborate with each other. Radius Recipes are designed to address this problem by providing a way for infrastructure engineers to define and manage cloud resources in a way that is easy for developers to consume.

Within an IT or platform engineering team, many organizations have defined specialized roles like SecOps, FinOps, and cloud centers-of-excellence to address their complex needs for using the cloud. Recipes are designed for these engineers to standardize and govern the organizations use of the cloud while still supporting self-service deployment. Since the Recipes are stored in the Environment they do not need to be shared directly with or understood and managed by application developers. By providing Recipes, platform engineers can streamline and simplify the interface to the cloud used by application developers. Since Recipes execute as part of Application deployment, the provisioning of cloud resources is part of an existing process rather than a manual step. 

## Introducing Radius Recipes

Recipes use infrastructure-as-code templates stored in the Environment to create cloud resources on-demand when an Application is deployed. Since the Recipes are stored in the Environment, the set of available cloud resources and the configuration used for provisioning can be tightly controlled. Recipes use the credentials stored in the Environment when provisioning cloud resources to limit those who need access to cloud accounts. The Recipes configured in an Environment are versioned, and can be updated in a granular way to lower the risk of unforeseen changes. When a Recipe is executed, it automatically catalogs the infrastructure used as part of the Radius Application Graph where it is visible to the whole organization. Because Recipes are part of the Environment, they can also vary across environments. 

Applications use Recipes to create cloud infrastructure during deployment without describing how that infrastructure will be provisioned. For example a developer, might include a Redis Cache as part of an Application. When the Application is deployed, the Redis Cache will be created according to the Recipe, ensuring that it uses a supported configuration. Recipes make it easy for the Application to connect to the cloud resources by automatically configuring access-policies, networking, and connection settings for the Application code. Since that Application can rely on the recipe to provision the correct infrastructure and deliver the correct configuration, it is easy to deploy the same Application to different Environments without code changes

## 