---
date: "2024-10-18T08:00:00-08:00"
title: "Happy 1st Birthday, Radius!"
linkTitle: "Happy 1st Birthday, Radius!"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: blog
---

Today marks the first anniversary of releasing Radius as an open-source project! We are thrilled to celebrate this milestone with the community and reflect on the progress we have made together. In the past year, we have seen tremendous growth with the Radius community. We have welcomed new contributors, received valuable feedback, and collaborated on exciting new features. We have also expanded our documentation, improved our tooling, and released new versions of Radius with more capabilities. Furthermore, we are grateful to everyone who has contributed to Radius, whether through code, documentation, testing, or feedback. Your support has been invaluable, and we look forward to continuing to work together to build an even better platform.

## Releasing Radius as an Open-source Project

As you know, [Radius was released as an open-source project on October 18, 2023](https://blog.radapp.io/posts/2023/10/18/introducing-radius-a-new-open-source-application-platform-for-cloud-native-apps/). Radius is an open application platform for building cloud native applications and infrastructure. Radius was designed to be open-source for anyone to be able to contribute and extend the platform to support their own scenarios. Following the launch of Radius, we received positive feedback regarding the project and its relevance to solving challenges in building cloud native applications. We gathered numerous suggestions and ideas on enhancing Radius for enterprise applications and its integration with other cloud native technologies. Community members began contributing by tackling various tasks, from straightforward [good-first-issues](https://aka.ms/radius-first-issues) to more complex features.

This past year we have learned a lot from our community both in terms of making the platform better and building an ecosystem for them to thrive and succeed in their ventures with Radius. We have about 821 members engaging in Discord and 575 contributions from the community on a wide range of areas some of which were huge features that unblocked scenarios for users. Since Radius is fully committed to becoming an industry standard, we submitted our project to the Cloud Native Compute Foundation (CNCF) and was accepted as CNCF sandbox project earlier this year! This approval is a key milestone towards building a vibrant community through open governance and addressing the key emphasis of enterprises leveraging CNCF technologies for their cloud native strategies.

Radius has evolved as platform in the past year with many new features and capabilities. Our primary focus was to unblock the community working on extending Radius for their internal developer platforms. Some of the major capabilities that we enabled together with the community in the past year are:

1. [**Radius Dashboard**](https://docs.radapp.io/guides/tooling/dashboard/overview/): One of the key value propositions of Radius is the Application Graph. The Radius Dashboard built on top of Backstage provides visualization of the application graph data including applications, environments, resources and Recipes. The application graph API which powers the Radius Dashboard provides a way to query the application graph data.

2. **Secrets management**: Community members have contributed capabilities to reference secrets as environments variables in containers and to reference any secret in Dapr components. This enables users to securely manage and reference secrets in their Radius applications.

3. [**Terraform Recipes**](https://docs.radapp.io/guides/recipes/terraform/): We have added features to Terraform Recipes which includes the use of Terraform modules from private Git repositories and from any Terraform provider allowing users to interact with and manage resources of any specific infrastructure platform or service, such as AWS, Azure, or Google Cloud.

4. [**Workload / Federated identity support**](https://docs.radapp.io/guides/operations/providers/overview/): Radius Cloud providers can be configured with AWS IAM roles for service accounts and Azure workload identity to interact and deploy resources on the respective clouds. With this, infrastructure operators are not burdened with the rotation of credentials anymore.

## What is Next for Radius 

We have miles to go, problems to solve, and solutions to deliver! 

Our current focus is on developing the following major capabilities:

**Radius Integration with GitOps**: We learned that GitOps tools are extremely popular with enterprise teams. GitOps tools like Flux and Argo CD provide a declarative approach to managing infrastructure and automatically reconciles the state of the infrastructure using Git as the single source of truth. Radius does not have built-in integration with these tools today, so we are building native support for Flux and Argo CD into Radius and will look to support additional GitOps tools in the future.

**Resource extensibility with User-Defined Types**: Providing enough extensibility points within Radius is key area to enable users to extend Radius and build custom platforms. Many organizations use a wide range of services in their applications for achieving their cloud-native strategy. Providing resource extensibility with User-Defined Types enable users to easily define their services as a custom resource type, then deploy and leverage all the goodness of Radius such as Recipes and Application Graph. Additionally, we want to empower the open-source community to publish these resource type definitions and Recipes as community supported assets for the community to discover and consume.

**Operational Maturity**: As we are working with enterprises to run their production workloads on Radius, we want to evolve the operational maturity of Radius. We wanted to enable capabilities that make Radius a highly resilient, scalable and flexible platform. Integration of Dapr into the Radius control plane and containerization of Recipes execution are some of the key areas we are focusing on to make Radius scale to satisfy enterprise needs.

## Learn More and Contribute 

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community. We're looking for people to join us!

To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).
