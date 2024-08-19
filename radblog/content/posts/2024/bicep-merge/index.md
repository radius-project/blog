---
date: "2024-08-15T08:00:00-08:00"
title: "Using Radius with Bicep"
linkTitle: "Radius and Bicep"
author: "[Shruthi Kumar](https://www.github.com/sk593)"
type: blog
---

## Radius and Bicep 

Radius uses Bicep for defining applications and Recipes and validating that these templates are able to be compiled. Up until now, Radius has used a temporary fork of Bicep to add support for resources that are unique to Radius. We did so to address the challenge of integrating Radius types with Bicep. Bicep is a great tool for defining and deploying resources, but it mainly supports Azure-specific resources. Radius, however, is designed to be a cloud-agnostic platform, which means we needed to handle a variety of resource types beyond just those used by Azure. 

To solve this, we turned to Bicep extensibility—a feature developed by the ARM and Bicep teams to allow the definition and deployment of types outside of the standard ARM resource framework. This capability is facilitated through custom type definitions and can be explored further in the [Bicep extensibility repository on GitHub](https://github.com/azure/bicep-extensibility). Bicep typically uses type definitions to handle Azure resources, as outlined in the [Azure Bicep types repository](https://github.com/Azure/bicep-types-az). These definitions provide information about the properties and configurations of resources. With Bicep extensibility, we now had a way to create custom definitions for Radius and AWS types that could be compiled by Bicep. 

However, our situation required more than just creating type definitions. We also needed to define resource function for our Radius resources that would allow users to access properties like secrets, connection strings, passwords, etc. Bicep supports method definitions for Azure resources through their built-in [Azure type provider](https://github.com/Azure/bicep/tree/main/src/Bicep.Core/TypeSystem/Providers/Az), but it would not have built-in support for resource functions on Radius resources. Because of this limitation, relying solely on the Bicep compiler did not meet all our requirements.

We decided to create and maintain our own version of Bicep, called Radius-Bicep, as a temporary workaround. We could create custom type defintitions for Kubernetes, Radius, and AWS types and customize the compiler to be able to process resource functions. This way, we had a way to process and compile Radius types while working alongside the Bicep team on supporting third party providers. The goal was that once support for third party providers was complete, we could remove the use of our fork in favor of the official Bicep compiler. 

[Question -- should we mention Kubernetes here? I know we built the k8s provider and now they maintain it but wondering how relevant it is to the post]

## How Maintaining a Radius-Bicep Forked Help Solve Extensibility Challenges (and Not)

Bicep uses a [`TypeSystem`](https://github.com/Azure/bicep/tree/main/src/Bicep.Core/TypeSystem) to manage resources for different providers, such as Azure and Kubernetes. At the time, it didn't support custom providers like Radius or AWS. By forking Bicep, we were able to create our own providers for [Radius and AWS](https://github.com/radius-project/bicep/tree/bicep-extensibility/src/Bicep.Core/TypeSystem). This allowed us to add features such as [method support](https://github.com/radius-project/bicep/blob/8af459c1d59eae9c2f5289b3d203df66288704cf/src/Bicep.Core/TypeSystem/Radius/RadiusResourceTypeProvider.cs#L50) and special behaviors on [properties](https://github.com/radius-project/bicep/commit/e5bcc4f3f21ba3ce8243f3814fb687738467246e). Similar to how Bicep uses Azure type defintions mentioned earlier, we implemented a [generator](https://github.com/radius-project/radius/commit/e77b87838d3886a761c01725ad9fe491a2f0d5b7) that serialized Radius and AWS type definitions so they could be consumed by the Radius-Bicep compiler.

While the Radius-Bicep fork was the best way to ensure that Radius and Bicep were compatible given the current state of each projects, it wasn't without its challenges. We had to maintain a separate Radius-Bicep VS Code extension and publish a new version every release. It was a pain to keep the fork up to date, and we ran into a lot of merge conflicts and breaking changes when we upmerged our fork with Bicep. At some point, we made the decision to stop updating the fork [need more context here]. But as Radius kept developing, the Radius-Bicep fork stayed stagnant. We were using an old build of Bicep, meaning a lot of the newest Bicep features were inaccessible to the team and to our users. 

## How Radius Uses Bicep to Solve Extensibility Now

Enabling Radius to work with Bicep took a collaborative effort from both teams. The Bicep team had to enable a way for Radius resources to be processed by the compiler and Radius had to ensure that our resources were serialized in a way that could be understood by the compiler [REWORD?? sounds confusing to me even though I know what I'm saying]. The Bicep team added support for [`ThirdPartyProviders`](https://github.com/Azure/bicep/tree/main/src/Bicep.Core/TypeSystem/Providers/ThirdParty), giving us a way to define custom resource types that could be understood by the Bicep compiler. We would provide the type definitions for Radius and AWS types in the form of JSON schema files and publish these files to an OCI registry using Bicep. Then, we'd be able to import these types as an "`extension`" and use them in our Bicep templates. This required some work on our end to make Radius and AWS types compatible with this process. 

### Serializing Radius and AWS types

Type definitions in Bicep are compiled into `index.json` and `types.json` files using a reference system. Radius defines its resources and APIs using TypeSpec, then compiles the TypeSpec files into [OpenAPI specs](https://github.com/radius-project/radius/blob/main/typespec/README.md#build-typespec-to-openapi-swagger). The OpenAPI specs are run through a generator that processes the resources and returns `index.json` and `types.json` files containing all the necessary type definitions. Part of the transition work to using Bicep required updating our existing generator. 

The Bicep team manages a repository called [`bicep-types`](https://github.com/Azure/bicep-types) that exposes a set of tools for generating Bicep types. We now use an updated version of this repo in our generator to help process the OpenAPI specs into the required type definitions. The type definitions get updated anytime we make a change to our TypeSpec schema. The most up-to-date generator code can be found [here](https://github.com/radius-project/radius/tree/main/hack/bicep-types-radius) for Radius and [here](https://github.com/radius-project/bicep-types-aws) for AWS. The schema for AWS is quite different from that of Azure or Radius types, so the generator logic is tailored towards reading AWS CloudControl specs. 

### Adding Resource Functions 

A key requirement for Radius compatibility with Bicep is a way to serialize resource functions in the `index.json` and `types.json` files. As part of the work for third party providers, the Bicep team now supports [resource functions](https://github.com/Azure/bicep/commit/0cc1d30854284d25c9a67e31c8660f68d76b2834). This feature allows us to add functions on Radius resources in our generator. We look for resource functions in our OpenAPI specs and add all the needed parameter and output data into the type defintion files. The logic for how we process resource functions can be found [here](https://github.com/radius-project/radius/blob/fb0287389e392f97f8bcb28bc03827420ad8fc8c/hack/bicep-types-radius/src/autorest.bicep/src/type-generator.ts#L141).

### Updating the Deployment Engine  

Radius also maintains a custom builds of the ARM deployment engine that is used for any Radius deployment. A lot of the work during the transition introduced breaking changes to how Radius is used, so we had to make sure that the deployment engine is compatible with both the Bicep compiler and the Radius-Bicep compiler. The addition of resource functions also means that the ARM JSON templates that Bicep builds could have added schema propertues. Updates were made so that the deployment engine could process the new template properties. 

### Publishing and pulling from an OCI registry with a `bicepconfig.json`

The newly generated type defintions for Radius and AWS types have to be uploaded to an OCI registry as an extension that Bicep can pull and read from. This is made possible using [`bicep publish-extension`](https://github.com/Azure/bicep/blob/4139b6c21237c238ca483ebea32e4a463b441d90/docs/experimental/publish-provider-command.md). We run this command as part of our CI/CD pipelines so we have updated type definitions for releases and on edge. 

Bicep pulls from our OCI registry through the use of a [`bicepconfig.json`](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config). This is a newly required file that specifies the configuration needed to use Radius with Bicep and which extensions to enable to use Radius and AWS resources. The key challenge with the `bicepconfig.json` is making it easy for users to understand the file and use it with their applications. To help streamline creating a `bicepconfig.json`, we added the option of automatically generating the file for easy setup during [`rad init`](https://github.com/radius-project/radius/pull/7664). More information on structure and setup of the `bicepconfig.json` can be found in our docs [TBD --- add link] 

## How to Get Started 
[open question here -- for the first two sections, the docs have information on what to do. should we rehash or just link to there? my thought is to link there since it'll already be defined]

### New users
If you're a new user of Radius, please see our docs about getting started [TBD -- add link]. This will contain all the necessary information about setting up any tooling like the `bicepconfig.json` and the Bicep VSCode extension and using Radius with Bicep

### Existing users
If you're an existing user of Radius, please see this page about what updates are needed to move to using the official Bicep compiler. The latest `v0.37` release has a number of breaking changes as a result of this transition. The `v0.37` release of Radius now installs the official Bicep instead of Radius-Bicep, so you'll need to make updates to your setup to ensure that your application deploys as usual. Generally, creating a `bicepconfig.json` and updating your import statements should get you started if you're working on `v0.37`. 

### Contributors 
If you're a contributor of Radius, you may notice some changes to our repository. 

1. A new `bicepconfig.json` file. Now that configuration file is required to use Radius with Bicep, we also need to have one in our repository so our files can compile and be tested in workflow. This file follows the same structure as outlined in our docs. 
1. A dependency on the `bicep-types` submodules. As part of updating our generator, we made the decision to use the `bicep-types` repository code as opposed to maintaing our own tools. There is ongoing work to ensure that our dependency is kept up to date. 
[should we add info here on how to use the module and generate? the docs in the repo are updated so I'm not sure it's needed]

## Learn More and Contribute 

There are several resources for learning more about using Radius and Bicep together.

[TODO -- add links]

### Other Community Resources

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.
We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord)


### Appendix [will be deleted, keeping for now as notes]
What problem were we trying to solve?
1. Since we were using Bicep as our templating language, we needed a way to define Radius types in Bicep files. 
2. However, Bicep only guarantees first-class support for defining and deploying Azure resources declaratively.
3. Radius is designed to be a cloud-agnostic platform and so we need more types than just those of the typical ARM resource
4. This is where Bicep extensibility came in. Bicep extensibility is an effort by the ARM and Bicep team to allow for types outside of the typical ARM resources to be defined in Bicep and deployed as part of the Deployment Engine. The source code lives in https://github.com/azure/bicep-extensibility. 
5. Bicep relies on type definitions to define resources and properties. An example for Azure resources lives in https://github.com/Azure/bicep-types-az. These are schemas that contain the properties and metadata about resources in Bicep.
6. If all we needed to do was create type definitions for Radius and AWS resources, we may have been okay relying on the Bicep compiler. However, we also needed to be able to call on methods on our resources, things like getting sensitive date like connectionStrings and 
7. Bicep does allow method definitions on Azure resources, but they didn't provide a way to do this for Radius resources. 
8. Because of this, having our own fork that we could maintain and define methods on made most sense. 

How Maintaining a Radius-Bicep Forked Help Solve Extensibility Challenges
1. Bicep processes resources using a [`TypeSystem`](https://github.com/Azure/bicep/tree/main/src/Bicep.Core/TypeSystem) with different providers. There is currently support for Azure, Kubernetes, etc but not custom providers like Radius or AWS.
2. With a fork, we could define our own providers for [Radius and AWS](https://github.com/radius-project/bicep/tree/bicep-extensibility/src/Bicep.Core/TypeSystem). 
3. The structure of our providers is based off of the structure of the supported providers in Bicep. The difference is that we could now customize these providers to fit our needs, implementing logic like [method support](https://github.com/radius-project/bicep/blob/8af459c1d59eae9c2f5289b3d203df66288704cf/src/Bicep.Core/TypeSystem/Radius/RadiusResourceTypeProvider.cs#L50) and special behaviors on [properties](https://github.com/radius-project/bicep/commit/e5bcc4f3f21ba3ce8243f3814fb687738467246e)