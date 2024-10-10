---
date: "2024-10-18T08:00:00-08:00"
title: "Happy birthday, Radius!"
linkTitle: "Happy birthday, Radius!"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: blog
---

Today marks the one-year anniversary of open-sourcing Radius! We are thrilled to celebrate this milestone with the community and reflect on the progress we have made together. In the past year, we have seen tremendous growth with the Radius community. We have welcomed new contributors, received valuable feedback, and collaborated on exciting new features. We have also expanded our documentation, improved our tooling, and released new versions of Radius with more capabilities. Furthermore, we are grateful to everyone who has contributed to Radius, whether through code, documentation, testing, or feedback. Your support has been invaluable, and we look forward to continuing to work together to build an even better platform.

## Conception of Radius

From incubating CNCF projects like [Dapr](https://dapr.io/) and [Keda](https://keda.sh/), the Microsoft Azure Incubations team has been on the forefront of solving challenges in building distributed cloud native applications. Modern applications use more kinds of differentiated compute, data services, identity systems and infrastructure options. This multitude of options results in developers struggling with enormous amount of complexity to wire up everything within an application from handling secrets to managing dependencies. Also, distributed applications increasingly leverage diverse hosting scenarios, and enterprises are tasked with making their applications portable across these hosting environments.

We learned the need to build a platform-agnostic application model that abstracts the complexities and improves collaboration where the developers can focus on the application needs and the platform engineers/ IT operators can focus on the infrastructure needs. The idea was to develop a centralized tool set that meets developers and operators where there and enables them to effectively collaborate, share and operate their applications across multiple cloud providers. Radius was conceived to achieve this with application at the center of every stage of development – redefining how applications are built, managed and deployed.

## Open-sourcing Radius 

Radius was designed to be open-source from the start to support enterprise multi-cloud strategies. By open sourcing we wanted to make our source code publicly available under an OSI approved permissive license for anyone to be able to contribute and extend Radius for their own scenarios. The main idea was to make Radius visible and understood among the cloud native open-source communities; we listen to their feedback and ideas and strive to satisfy them by meeting them where they are. We also wanted to ensure that the community feels empowered to contribute to Radius in an independent and meaningful way.

Following the launch of Radius on October 18, 2023, we received positive feedback regarding the project and its relevance to solving challenges in building cloud native applications. Our launch at the Linux Foundation Member Summit and presentation at Microsoft Ignite raised awareness about Radius among diverse communities of developers, open-source advocates, and enterprise decision-makers. We gathered numerous suggestions and ideas on enhancing Radius for enterprise applications and its integration with other cloud native technologies. Community members began contributing by tackling various tasks, from straightforward [good-first-issues](https://aka.ms/radius-first-issues) to more complex features.

This past year we have learned a lot from our community both in terms of making the platform better and building an ecosystem for them to thrive and succeed in their ventures with Radius. We have about ~820 members engaging in Discord and a total of ~568 contributions from the community on a wide range of areas some of which were huge features that unblocked scenarios for users. Since Radius is fully committed to becoming an industry stand for enterprises, we submitted our project to CNCF (Cloud Native Compute Foundation) and got accepted as CNCF sandbox project this year. This approval is a key milestone towards building a vibrant community and addressing the key emphasis of enterprises leveraging CNCF technologies for their cloud native strategies.

Radius has evolved as platform in the past year with lots of features and capabilities. Our primary focus was to unblock the community working on extending Radius for their internal developer platforms. Some of the major capabilities that we enabled together with the community in the past year are 

1. [**Radius Dashboard**](https://docs.radapp.io/guides/tooling/dashboard/overview/): One of the key value propositions of Radius is the application graph. The Radius Dashboard built on top of Backstage provides visualization of the application graph data including applications, environments, resources and Recipes. The application graph API which powers the Radius Dashboard provides a way to query the application graph data.
 
2. [**Terraform Recipes**](https://docs.radapp.io/guides/recipes/terraform/): We have added features to Terraform Recipes which includes the use of Terraform modules from private Git repositories and from any Terraform provider allowing users to interact with and manage resources of any specific infrastructure platform or service, such as AWS, Azure, or Google Cloud.

3. [**Workload / Federated identity support**](https://docs.radapp.io/guides/operations/providers/overview/): Radius Cloud providers can be configured with AWS IAM roles for service accounts and Azure workload identity to interact and deploy resources on the respective clouds. With this, infrastructure operators are not burdened with the rotation of credentials anymore.

## What’s, Next for Radius 

We have miles to go!, problems to solve!, solutions to deliver! 

Our current focus is on developing the following major capabilities:

**Radius Integration with GitOps**: We learned that enterprise teams are burdened with the challenges around continuous deployment of cloud native applications and infrastructure. GitOps framework implemented as popular tools like Flux and Argo CD helps in mitigating these challenges by providing a declarative approach to manage infrastructure and automatically reconciles the state of the infrastructure using Git as the single source of truth. Enterprise that uses GitOps and Radius do not have a clear path for how to use both technologies together. Hence, Radius is working towards providing a consistent Radius +GitOps model for both existing and future GitOps solutions.

**Resource extensibility with User Defined Types**: Providing enough extensibility points within Radius is key area to enable enterprises to extend Radius and build custom platforms. Many enterprises use a wide range of services in their applications for achieving their cloud-native strategy. Providing resource extensibility with User defined types enable users to easily define their services as a custom resource type, deploy and leverage all the goodness of Radius such as Recipes and Application graph. Additionally, we want to empower the open-source community to publish these resource type definitions and Recipes as community supported assets for the community to discover and consume.

**Operational Maturity**: As we are working with enterprises to run their production workloads on Radius, we want to evolve the operational maturity of Radius. We wanted to enable capabilities that make Radius a highly resilient, scalable and flexible platform. Integration of Dapr workflows to the Radius control plane, containerization of Recipes execution are some of the key areas we are focusing on to make Radius scale to satisfy enterprise needs.

## Learn More and Contribute 

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community. We're looking for people to join us!

To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).
