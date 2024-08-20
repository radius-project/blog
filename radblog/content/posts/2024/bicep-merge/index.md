---
date: "2024-08-15T08:00:00-08:00"
title: "Using Radius with Bicep"
linkTitle: "Radius and Bicep"
author: "[Shruthi Kumar](https://www.github.com/sk593)"
type: blog
---

## Radius and Bicep

Radius uses Bicep for defining applications and Recipes and validating that these templates are able to be compiled. When Radius was first being developed, we needed an infrastructure tool that would facilitate defining applications and resources, while providing a high level of validation during compilation. It also needed to support an easy way to add new resources and types to ensure Radius could adapt to evolving requirements and capabilities. Our goal was to leverage a straightforward, declarative language that would enhance the development experience. Around the same time, [Bicep](https://github.com/Azure/bicep) was being developed as a new language designed to address what has worked well and not worked well for other infrastructure as code lanuages across the industry. Bicep stood out because it offers a simple syntax for defining resources, and the built-in tooling and validation features like intellisense and linting provide a robust authoring experience. Additionally, Bicep is an open-source project which is a significant advantage given the active community and engagement around it. 

Bicep is a great tool for defining and deploying resources, but it mainly supports Azure-specific resources. Radius, however, is designed to be a cloud-agnostic platform, which means we need to handle a variety of resource types beyond just those used by Azure. This blog explores how we worked with the Bicep project to address the gap in extensibility and integrate Radius, Kubernetes, and AWS resource types with Bicep. 

## The Gap in Extensibility

Up until now, Radius has used a temporary fork of Bicep to add support for resources that are unique to Radius. Bicep typically uses type definitions to handle Azure resources, as outlined in the [Azure Bicep types repository](https://github.com/Azure/bicep-types-az). These definitions provide information about the properties and configurations of resources. However, our situation required more than just creating type definitions. We also needed to define resource functions for Radius resources that would allow users to access properties like secrets, connection strings, passwords, etc. Bicep supports method definitions for Azure resources through their built-in [Azure type provider](https://github.com/Azure/bicep/tree/main/src/Bicep.Core/TypeSystem/Providers/Az), but it would not have built-in support for functions on other resources. Because of this limitation, relying solely on the Bicep compiler did not meet all our requirements.

We decided to maintain our own version of Bicep, called Radius-Bicep, as a temporary workaround. We could create defintitions for Radius, Kubernetes, and AWS types and customize the compiler to be able to process resource functions. This way, we could process and compile custom types while working alongside the Bicep project on supporting third party providers. The goal was that once support for third party providers was complete, we could remove the use of our fork in favor of the official Bicep compiler. 

In the meantime, the key gap we needed to address with the Radius-Bicep compiler was extensibility and there were a few requirements to ensure Radius-Bicep solved it:

1. Seamless resource type integration: Adding types and functionality should be an easy process and ideally, a built-in functionality. 
2. Independent versions: We would be relying on Bicep code as the basis for the fork, but we would not coordinate with Bicep on releases or code updates to the upstream project. Any changes made by Radius would be exclusive to the Radius-Bicep fork.
3. Commitment to open-source: Extensibility would be for anyone to use. It would not be unique to the Radius project and could be implemented by any user. 

These requirements would correspond the maintenance of different components in Radius: 
[TODO -- clarify diagram and add here]

## Maintaining a Radius-Bicep Fork 

The first step to implementing extensibility was finding a way to serialize types in a way that Radius-Bicep could compile. Similar to how Bicep uses Azure type defintions mentioned earlier, Radius, Kubernetes, and AWS types needed to be compiled into type definitions. We implemented a [generator](https://github.com/radius-project/radius/commit/e77b87838d3886a761c01725ad9fe491a2f0d5b7) that serialized type definitions so they could be consumed by the Radius-Bicep compiler. 

The Bicep type definitions for [Kubernetes resources](https://github.com/Azure/bicep-types-k8s), in particular, was an early collaboration and success in addressing the extensibility gap. Radius supports deploying Kubernetes resources, something that Bicep at the time did not. As part of the work for the Radius-Bicep fork, we had implemented the Kubernetes [generator](https://github.com/Azure/bicep-types-k8s/pull/11) that pulled Kubernetes resource specs and compiled them into type definitions. The next step for us would have been implementing a Kubernetes provider in the Radius-Bicep fork. Instead, we contributed the Kubernetes generator to Bicep as a repository that Bicep would maintain for Kubernetes type definitions. Bicep would then support a built-in Kubernetes provider similar to the Azure provider. 

This was the start of what would become Bicep extensibility—a feature added to the Bicep project to allow the definition and deployment of types outside of the standard ARM resource framework. This capability is facilitated through custom type definitions and can be explored further in the [Bicep extensibility repository on GitHub](https://github.com/azure/bicep-extensibility). With Bicep extensibility, we now had a way to create custom definitions for Radius, Kubernetes, and AWS types that could be compiled by Bicep. With type definitions taken care of, we could turn to implementing custom providers.

Bicep uses a [`TypeSystem`](https://github.com/Azure/bicep/tree/main/src/Bicep.Core/TypeSystem) to manage resources for supported providers like Azure and Kubernetes. We were able to add our own providers to the `TypeSystem` in the Radius-Bicep fork for [Radius and AWS](https://github.com/radius-project/bicep/tree/bicep-extensibility/src/Bicep.Core/TypeSystem) that could process our custom type defintions. This allowed us to add features such as [method support](https://github.com/radius-project/bicep/blob/8af459c1d59eae9c2f5289b3d203df66288704cf/src/Bicep.Core/TypeSystem/Radius/RadiusResourceTypeProvider.cs#L50) and special behaviors on [properties](https://github.com/radius-project/bicep/commit/e5bcc4f3f21ba3ce8243f3814fb687738467246e). 

While the Radius-Bicep fork was the best way to ensure that Radius and Bicep were compatible given the current state of each project, it wasn't without its challenges. We had to maintain a separate Radius-Bicep VS Code extension and publish a new version of the Radius-Bicep binary and extension every release. It was a pain to keep the fork up to date, and we ran into a lot of merge conflicts and breaking changes when we upmerged our fork with Bicep. We ultimately made the decision to stop updating the fork but this meant that as time went on, we were using an old build of Bicep. Even though Radius kept developing, the newest Bicep features were inaccessible to Radius users. 

## How Radius Uses Bicep to Solve Extensibility Now

Enabling Radius to work with Bicep took a collaborative effort. The Bicep project required a way for Radius resources to be processed by the compiler and Radius had to ensure that our resources were serialized in a way that could be understood by the compiler. Bicep recently added support for [`ThirdPartyProviders`](https://github.com/Azure/bicep/tree/main/src/Bicep.Core/TypeSystem/Providers/ThirdParty), giving us a way to define custom resource types that could be understood by the Bicep compiler. We would provide the type definitions for Radius and AWS types in the form of JSON schema files and publish these files to an OCI registry using Bicep. Then, we'd be able to import these types as an "`extension`" and use them in our Bicep templates. This required some work on our end to make Radius and AWS types compatible with this process. 

### Serializing Radius and AWS types

Type definitions in Bicep are compiled into `index.json` and `types.json` files using a reference system. Radius defines its resources and APIs using TypeSpec, then compiles the TypeSpec files into [OpenAPI specs](https://github.com/radius-project/radius/blob/main/typespec/README.md#build-typespec-to-openapi-swagger). The OpenAPI specs are run through a generator that processes the resources and returns `index.json` and `types.json` files containing all the necessary type definitions. Part of the transition work to using Bicep required updating our existing generator. 

Bicep manages a repository called [`bicep-types`](https://github.com/Azure/bicep-types) that exposes a set of tools for generating Bicep types. We now use an updated version of this repo in our generator to help process the OpenAPI specs into the required type definitions. The type definitions get updated any time we make a change to our TypeSpec schemas. The most up-to-date generator code can be found [here](https://github.com/radius-project/radius/tree/main/hack/bicep-types-radius) for Radius and [here](https://github.com/radius-project/bicep-types-aws) for AWS. The schema for AWS is quite different from that of Azure or Radius types, so the generator logic is tailored towards reading AWS CloudControl specs as opposed to OpenAPI specs. 

### Adding Resource Functions 

A key requirement for Radius compatibility with Bicep is a way to serialize resource functions in the `index.json` and `types.json` files. As part of the work for third party providers, Bicep now supports [resource functions](https://github.com/Azure/bicep/commit/0cc1d30854284d25c9a67e31c8660f68d76b2834). This feature allows us to add functions on Radius resources in our generator. We look for resource functions in our OpenAPI specs and add all the needed parameter and output data into the type defintion files. The logic for how we process resource functions can be found [here](https://github.com/radius-project/radius/blob/fb0287389e392f97f8bcb28bc03827420ad8fc8c/hack/bicep-types-radius/src/autorest.bicep/src/type-generator.ts#L141).

### Updating the Deployment Engine  

Radius also maintains a custom builds of the ARM deployment engine that is used for any Radius deployment. A lot of the work during the transition introduced breaking changes to how Radius is used, so we had to make sure that the deployment engine is compatible with both the Bicep compiler and the Radius-Bicep compiler. The addition of resource functions also means that the ARM JSON templates that Bicep builds could have added schema propertues. Updates were made so that the deployment engine could process the new template properties. 

### Publishing and pulling from an OCI registry with a `bicepconfig.json`

The newly generated type defintions for Radius and AWS types have to be uploaded to an OCI registry as an extension that Bicep can pull and read from. This is made possible using [`bicep publish-extension`](https://github.com/Azure/bicep/blob/4139b6c21237c238ca483ebea32e4a463b441d90/docs/experimental/publish-provider-command.md). We run this command as part of our CI/CD pipelines so we have updated type definitions for releases and on edge. 

Bicep pulls from our OCI registry through the use of a [`bicepconfig.json`](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config). This is a newly required file that specifies the configuration needed to use Radius with Bicep and which extensions to enable to use Radius and AWS resources. The key challenge with the `bicepconfig.json` is making it easy for users to understand the file and use it with their applications. To help streamline creating a `bicepconfig.json`, we added the option of automatically generating the file for easy setup during [`rad init`](https://github.com/radius-project/radius/pull/7664). More information on structure and setup of the `bicepconfig.json` can be found in our [docs](https://docs.radapp.io/guides/tooling/bicepconfig/overview/) 

Radius type definitions can be downloaded from `biceptypes.azurecr.io/radius` and AWS type definitions can be downloaded from `biceptypes.azurecr.io/aws`.

## How to Get Started 

### New users
If you're a new user of Radius, please see our [docs](https://docs.radapp.io/getting-started/) about getting started. This will contain all the necessary information about setting up any tooling like the `bicepconfig.json` and the Bicep VSCode extension and using Radius with Bicep.

### Existing users
If you're an existing user of Radius, please see the [release notes](https://github.com/radius-project/radius/releases/tag/v0.37.0) about what updates are needed to move to using the official Bicep compiler. The latest `v0.37` release has a number of breaking changes as a result of this transition. This release of Radius now installs the official Bicep instead of Radius-Bicep, so you'll need to make updates to your setup to ensure that your application deploys as usual. Generally, creating a `bicepconfig.json` and updating your import statements should get you started if you're working on `v0.37`. 

### Contributors 
If you're a contributor of Radius, you may notice some changes to our repository. 

1. A new `bicepconfig.json` file. Now that a configuration file is required to use Radius with Bicep, we also need to have one in our repository so our files can compile locally and be tested in workflow runs. This file follows the same structure as outlined in our docs. 
1. A dependency on the `bicep-types` submodule. As part of updating our generator, we made the decision to use the `bicep-types` repository code as opposed to maintaing our own tools. The `bicep-types` submodule now needs to be initialized during type generation, so there is ongoing work to ensure that our dependency is kept up to date. 
1. Radius and AWS type definitions versioning. We now version our Radius and AWS types in the type definitions as opposed to packaging them within the Radius-Bicep version. Each release will have a point-in-time snapshot of Radius and AWS type defintions associated with it that lives in our OCI registry. Any edge builds of Radius should reference the `latest` tag in the `bicepconfig.json` as opposed to a release-specific tag. 
1. Local testing with resource schema changes. You can now locally test your Bicep type updates without needing to update the Radius-Bicep fork. Instructions for local testing can be found [here](https://github.com/radius-project/radius/tree/main/docs/contributing/contributing-code/contributing-code-schema-changes#testing-schema-changes-locally). 

## Learn More and Contribute 

There are several resources for learning more about using Radius and Bicep together.

1. [Tooling - `bicepconfig.json`](https://docs.radapp.io/guides/tooling/bicepconfig/overview/)
1. [Tooling - VSCode Bicep extension](https://docs.radapp.io/guides/tooling/vscode/overview/)
1. [Getting started with Radius](https://docs.radapp.io/getting-started/)

### Other Community Resources

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.
We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord)