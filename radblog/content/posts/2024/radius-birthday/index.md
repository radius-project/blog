---
date: "2024-10-18T08:00:00-08:00"
title: "Happy 1st Birthday, Radius!"
linkTitle: "Happy 1st Birthday, Radius!"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: blog
---

Today marks the first anniversary of the release of Radius as an open-source project! We are thrilled to celebrate this milestone with the community and reflect on the progress we have made together. In the past year, we have seen tremendous growth in the Radius community. We have welcomed new contributors, received valuable feedback, and collaborated on exciting new features. We have also expanded our documentation, improved our tooling, and released new versions of Radius, every month, with more capabilities. We are grateful to everyone who has contributed to Radius, whether through code, documentation, testing, or feedback. Your support has been invaluable, and we look forward to continuing to work together to build an even better platform.

## Releasing Radius as an Open-source Project

As you know, [Radius was released as an open-source project on October 18, 2023](https://blog.radapp.io/posts/2023/10/18/introducing-radius-a-new-open-source-application-platform-for-cloud-native-apps/). Radius is an open application platform for building cloud native applications and infrastructure. Radius was designed to be open-source, so anyone can contribute and extend the platform to support their own scenarios. Following the launch of Radius, we received positive feedback regarding the project and its relevance to solving challenges in building cloud native applications. We received suggestions regarding enhancing Radius for enterprise applications and its integration with other cloud native technologies. Community members began contributing by tackling various tasks, from straightforward [good-first-issues](https://aka.ms/radius-first-issues) to more complex features.

This past year we have learned a lot from our community both in terms of making the platform better and building an ecosystem for them to thrive and succeed in their ventures with Radius. We have about 821 members engaging in Discord and 575 contributions from the community on a wide range of areas some of which were huge features that unblocked scenarios for users. Since Radius is fully committed to becoming an industry standard, we submitted our project to the Cloud Native Compute Foundation (CNCF) and was accepted as CNCF sandbox project earlier this year! This approval is a key milestone towards building a vibrant community through open governance and addressing the key emphasis of enterprises leveraging CNCF technologies for their cloud native strategies.

Radius has evolved as a platform in the past year with many new features and capabilities. A key investment area this year has been to make the platform more appropriate for enabling real world scenarios. Some of the most significant capabilities that we enabled together with the community are:

1. [**Radius Dashboard**](https://docs.radapp.io/guides/tooling/dashboard/overview/): One of the key value propositions of Radius is the Application Graph. The Radius Dashboard built on top of Backstage provides visualization of the application graph data including applications, environments, resources and Recipes. The application graph API which powers the Radius Dashboard provides a way to query the application graph data.

2. **Secrets management**: Community members have contributed capabilities to reference secrets as environments variables in containers and to reference any secret in Dapr components. This enables users to securely manage and reference secrets in their Radius applications.

3. [**Terraform Recipes Enhancements**](https://docs.radapp.io/guides/recipes/terraform/): We have added features to Terraform Recipes which includes the use of Terraform modules from private Git repositories and from any Terraform provider allowing users to interact with and manage resources of any specific infrastructure platform or service, such as AWS, Azure, or Google Cloud.

4. [**Workload / Federated identity support**](https://docs.radapp.io/guides/operations/providers/overview/): Radius Cloud providers can be configured with AWS IAM roles for service accounts and Azure workload identity to interact and deploy resources on the respective clouds. With this, infrastructure operators are not burdened with the rotation of credentials anymore.

## What is Next for Radius 

We have miles to go, problems to solve, and solutions to deliver! 

Our current focus is on developing the following major capabilities:

**Radius Integration with GitOps**: A few enterprise application teams adopting Radius have emphasized the importance of GitOps tools in their workflows, highlighting the need for seamless integration with Radius. GitOps tools like Flux and Argo CD provide a declarative approach to managing infrastructure and automatically reconciles the state of the infrastructure using Git as the single source of truth. To address this feedback from early adopters, we are currently building native support for Flux into Radius and will extend that support to additional GitOps tools in the future based on the community feedback.

**Resource extensibility via User-Defined Types**: Radius currently supports a set of resources ["out of the box"](https://docs.radapp.io/guides/author-apps/portable-resources/overview/), that you can define and deploy in your Radius application. We want to expand these resource types by providing an extensibility model where the user can bring their own service and integrate it with Radius. User-Defined Types feature will enable users to easily define and deploy their own resource types and leverage the other features of Radius such as Recipes and Application Graph. Additionally, we want to empower the open-source community to publish the user defined type definitions and Recipes as community supported assets.

**Operational Maturity**: As we are working with enterprises to run their production workloads on Radius, we want to evolve the operational maturity of Radius. We wanted to enable capabilities that make Radius a highly resilient, scalable and flexible platform. Integration of Dapr into the Radius control plane and containerization of Recipes execution are some of the key areas we are focusing on to make Radius scale to satisfy enterprise needs.
 
 To learn more about everything that's upcoming for Radius, visit our roadmap published in GitHub: https://aka.ms/radius-roadmap. You can provide feedback by commenting or upvoting on the existing features you are most excited about! You can also submit [new feature requests](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.md&title=%3CFEATURE+TITLE%3E) on the GitHub repository.

## Learn More and Contribute 

Happy birthday Radius, and thanks to this great community for such a productive year!  We look forward to many more to come!

To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).
