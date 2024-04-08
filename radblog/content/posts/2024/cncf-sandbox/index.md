---
date: "2024-04-09T00:00:00"
title: "Radius Accepted as Cloud Native Compute Foundation (CNCF) Sandbox Project"
linkTitle: "CNCF Sandbox"
author: "[Mark Russinovich](https://www.linkedin.com/in/markrussinovich/)"
type: blog
---

The Microsoft Azure Incubations Team is excited to announce that Radius has been approved by the Cloud Native Compute Foundation as a [Sandbox](https://www.cncf.io/sandbox-projects/) project, the entry point for new CNCF projects.  This approval is a key step toward building a vibrant community and open governance for the Radius project in partnership with the CNCF, along with addressing the growing emphasis from enterprises on leveraging only CNCF approved projects for strategic cloud investments. 

Radius is a cloud-native, cloud-agnostic application platform that enables developers and the platform engineers who support them to collaborate on delivering and managing cloud-native applications that follow corporate best practices for cost, operations, and security by default. It was initiated by the same Incubations team that launched other CNCF projects including [KEDA](https://github.com/kedacore/keda) (CNCF Graduated), [Dapr](https://github.com/dapr) (CNCF Incubating) and [Copacetic](https://github.com/project-copacetic/copacetic) (CNCF Sandbox). 

Since the [announcement of Radius in October 2023](https://blog.radapp.io/posts/2023/10/18/introducing-radius-a-new-open-source-application-platform-for-cloud-native-apps/), the team has made significant progress both in growing the Radius open-source community and in delivering new features.  As a result, Radius has an increasingly vibrant community including:  

- The [main Radius GitHub repository](https://github.com/radius-project/radius) has received ~1300 stars. There are a total of ~73 community contributors who have made over ~350 contributions to Radius, both for code and for documentation changes across [all Radius GitHub repositories](https://github.com/orgs/radius-project/repositories). (Note these contributions are measured by CNCF standards and include PR open/close and reviews, issue open/close, comments on PRs/issues and commits.) Community members have fixed ~10 good-first issues, which involved fixing bugs and adding Radius features. 
- There are ~750 members engaging in support channels at the [Radius Discord server](https://aka.ms/radius/discord). 
- The [Radius project roadmap](https://github.com/orgs/radius-project/projects/8) is updated monthly. 
- The [Radius Community Meeting](https://github.com/radius-project/community) occurs after each monthly release. 

The Radius team and community have released six monthly releases of Radius since going public last year.  Key features across those releases include: 

- Deeper integration with [Kubernetes](https://docs.radapp.io/guides/author-apps/containers/overview/#kubernetes) and [Helm](https://docs.radapp.io/tutorials/helm/), making it easier to add Radius to an existing Kubernetes application or Helm chart, allowing for incremental adoption of Radius features for applications that have already been deployed. 
- [Radius Dashboard](https://docs.radapp.io/guides/tooling/dashboard/overview/).  A key value proposition of Radius is the Radius Application Graph.  The Radius Dashboard provides a visualization of the application graph data, providing both textual and visual representations of the Radius applications and resources, as well as a directory of available Recipes, making it easier for developers and operators to understand and collaborate on building and delivering Radius applications. 
- [Radius Application Graph API](https://docs.radapp.io/guides/author-apps/application/overview/#query-and-understand-your-application-with-the-radius-application-graph), upon which the Radius Dashboard is built.  The API provides a way to query the application graph data, empowering operators and developers to mine the data for insights or even build additional visualizations.  
- [Radius simulated environments](https://docs.radapp.io/guides/deploy-apps/environments/overview/#simulated-environments). In the initial Radius public release, the Application Graph was only generated and viewable when an application was actually deployed along with its resources.  Users can now optionally designate an environment as “simulated”, which means it will not output any resources or run any Recipes when an application is deployed.  This enables developers to better understand their application architecture during development and allows for dry runs and testing. 
- [Terraform Recipes in private git repositories](https://docs.radapp.io/guides/recipes/howto-private-registry/).  The initial public release of Radius supported using Terraform modules as Radius Recipes, only if those modules were stored in a public git repository.  Now users can pull Terraform Recipes from their own, private git repositories.  This makes it possible for enterprises to leverage their internal Terraform modules in Radius Recipes.  

You can review the Radius CNCF Sandbox submission [here](https://github.com/cncf/sandbox/issues/65).  To get started and learn more about Radius, visit [radapp.io](http://radapp.io/), join the discussions on [Discord](https://aka.ms/radius/discord), or dial into an upcoming [community meeting](https://github.com/radius-project/community).

The Radius team is excited to continue collaborating with the CNCF as the Radius community grows and the project evolves based on community engagement and contributions.

We're looking for people to join us!  To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).