---
date: "2025-06-16"
title: "Introducing Radius Resource Types"
linkTitle: "Introducing Radius Resource Types"
author: "[Zach Casper](https://www.linkedin.com/in/zcasper/)"
type: blog
---

The Radius maintainers and community have been hard at work enabling platform engineers to build internal developer platforms that are application-centric with a great developer experience. This week Radius  launched [Radius Resource Types](https://docs.radapp.io/tutorials/create-resource-type/) reinforcing Radius's core mission to decouple application definitions from underlying infrastructure.

Enterprises integrating Radius into their internal developer platform tell us they need to customize the API for common resource types such as a PostgreSQL database to simplify the developer experience (allowing developers to select T-shirt sizes, for example). Others want to create abstract resource types such as a web service that may have a reverse proxy, an application container, and an in-memory cache all encapsulated in one single type. Radius Resource Types enable platform engineers to accomplish these exact scenarios. 

Platform engineers now have complete flexibility in defining the resources developers use in their applications and, separately, the implementation of those resources using Terraform configurations or Bicep templates (referred to generally as Recipes in Radius).

This is a major step forward for platform engineering. Platform engineers gain greater control over the implementation and deployment of cloud resources. Ensuring security, compliance, and cost management best practices are followed is significantly easier. Developers can now work with higher-level, familiar abstractions defined by their organization, simplifying their workflow and reducing cognitive load. They no longer need to learn multiple infrastructure as code languages.

## Resource Types: The developer's interface

Radius ships with a catalog of common resource types. This includes core types such as Containers, Gateways, Secrets, and Volumes, but also open-source resource types including MongoDB, Redis, RabbitMQ, and others. Each resource type has a set of properties developers can specify when defining their application.

For example, the MongoDB resource type has properties for the database name, the host name, the port, and the username. These properties are the interface between the application and the internal developer platform. They constitute the contract between developers and platform engineers.

This interface insulates developers from the infrastructure implementation. They no longer need know how to deploy their containers to Kubernetes and their database to AWS or Azure. They no longer need to learn Helm and Bicep, CloudFormation, or Terraform.

However, until today, these resource types were predefined, immutable, and built into Radius. All this changes with Radius Resource Types that enable platform engineers to create new resource types with custom APIs, opening up a wide array of new capabilities. For example, platform engineers can now:

* Create resource types for application components that do not ship with Radius. For example, a resource type could be created for an OpenAI model.
* Simplify the API for existing resource types. In the MongoDB example above, the API could be simplified so the developer only needs to provide a T-shirt size (S, M, L) for the database with no other properties needed.
* Create more abstract resource types such as a web service, or a functions-based application that only requires the developer to provide a container image for a full application to be deployed.

Radius Resource Types are modeled using an OpenAPI schema in a YAML file. If you have created a Kubernetes Custom Resource Definition before, Radius Resource Types will look familiar. For example, here is resource type definition for an OpenAI model:

**`types.yaml`**:

```yaml
namespace: Radius.Resources
types:   
  openAIModels:
    apiVersions:
      '2023-10-01-preview':
        schema: 
          type: 'object'
          properties: 
            environment:
              type: string
              description: The Radius environment, typically set by the rad CLI
            application:
              type: string
              description: The application which the resource is associated with
            capacity:
              type: string
              description: The capacity of the API, valid values are S, M, or L
            apiKey: 
              type: string
              description: The key that can be used to connect to the API
              readOnly: true
            apiVersion:
              type: string
              description: The version of the OpenAI API
              readOnly: true
            deployment:
              type: string
              description: The deployment name, used by the OpenAI SDK to connect to the API
              readOnly: true
            endpoint:
              type: string
              description: The endpoint URL of the OpenAI API
              readOnly: true
          required:
              - environment
              - capacity  
```

Let's walkthrough this resource type definition. By convention, resource type definitions are stored in a file named `types.yaml`.

```yaml
namespace: Radius.Resources
```

The namespace is just a namespace for the resource type. In practice, it is recommended to use `Radius.Resources` for all resource types. For advanced users, the namespace can be any string in the format `Parent.Child` (Radius uses `Applications.Core` for the built-in resource types).

```yaml
types:   
  openAIModels:
```

Multiple resource types can be listed under `types`. `openAIModels` is the name of the resource type. By convention, Radius Resource Types are camel-case and plural. 

```yaml
    apiVersions:
      '2023-10-01-preview':
        schema: 
          type: 'object'
          properties: 
```

This defines our API version. API versions in Radius are in date form with an optional `-preview` suffix. Today, resource types can only have a single version, but in the future, adding additional versions with a different schema will be possible. Note than when developers add resources to the application definition, the API version must always be specified.

```yaml
            environment:
              type: string
              description: The Radius environment, typically set by the rad CLI
            application:
              type: string
              description: The application which the resource is associated with
```

These two properties are Radius-specific and should be on every resource type. The `environment` property is typically set by the Radius CLI when the application is deployed. The `application` property is set by the developer in the application definition.

```yaml
            capacity:
              type: string
              description: The capacity of the API. Valid values: 'S', 'M', 'L'
```

`capacity` is the only property that the developer needs to set. Later you will see that `capacity` is a required property. 

{{< image src="images/vscode.png" alt="Screenshot of VS Code showing Intellisense type ahead assistance with Radius Resource Types" width="100%">}}

When the developer is adding an OpenAI model to their application using VS Code, the developer sees the description of the `capacity` property.

```yaml
            apiKey: 
              type: string
              description: The key that can be used to connect to the API
              readOnly: true
            apiVersion:
              type: string
              description: The version of the OpenAI API
              readOnly: true
            deployment:
              type: string
              description: The deployment name, used by the OpenAI SDK to connect to the API
              readOnly: true
            endpoint:
              type: string
              description: The endpoint URL of the OpenAI API
              readOnly: true
```

The `apiKey`, `apiVersion`, `deployment`, and `endpoint`, are all read-only properties meaning the developer cannot set these properties in the resource definition (notice they are not in the screen shot above). 

These read-only properties are set by the Recipe after the resource gets deployed. The developer can, however, reference these properties in the application definition. For example, this container has environment variables set using properties from an `openAIModels` resource.

**`todolist.bicep`**:

```bicep
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    ...
    container: {
      ...
  		env: {
        CONNECTION_AI_ENDPOINT: {
          value: openai.properties.endpoint
        }
        CONNECTION_AI_DEPLOYMENT: {
          value: openai.properties.deployment
        }
        CONNECTION_AI_APIKEY:{
          value: openai.properties.apiKey
        }
        CONNECTION_AI_APIVERSION:{
          value: openai.properties.apiVersion
        }
...
```

Finally, the remainder of the resource type definition YAML file is:

```yaml
          required:
              - environment
              - capacity  
```

This specified that only the `environment` and `capacity` properties are required to be set by the developer.

## Recipes: The platform engineer's implementation

The resource type definition discussed above is only the interface for a resource type. The implementation for deploying this resource is completely separate and not exposed to developers. If you are familiar with Radius, you know that Radius uses Recipes and Environments to determine how to deploy a resource. Radius Resource Types uses the same concepts.

{{< image src="images/openai.png" alt="Diagram showing the OpenAI resource type schema for developers separate from the Environment and Recipe" width="100%" >}}

In this example, the `openAIModels` resource type is used by developers in their application definitions on the left. On the right, the platform engineer has created two Radius Environments. Notice that the same Terraform configuration for deploying the OpenAI model is used for both the test and production environments. While the same configuration file is used, it uses the parameters passed by Radius to determine the proper deployment configuration. The Terraform configuration has several variables set by Radius automatically, but platform engineers can add additional parameters such as `production=TRUE` in this example.

### Composite Recipes

Radius Resource Types also introduces a powerful new concept of composite Recipes. In the previous OpenAI example, the recipe deployed a single resource. But recipes are much more powerful than that. With composite Recipes, platform engineers can model abstract resource types then define a Recipe that is composed of multiple resources. 

{{< image src="images/composite.png" alt="Diagram showing the web service resource type being created by a composite Recipe with two resources implemented by a Terraform and Bicep recipe" width="100%" >}}

The resources defined in the composite Recipe can be any type that Radius is aware of including:

* Radius core types including Containers, Gateways, Secrets, and Volumes
* Resource types built into Radius such as MongoDB, Redis, Dapr Configuration Store, and Dapr State Store
* Radius Resource Types defined by the platform engineer
* Azure resource types
* AWS resource types

For a hands-on example of using a composite Recipe, see the *[Create a composite Recipe](https://docs.radapp.io/tutorials/create-composite-recipe/)* tutorial in the Radius documentation.

## Learn More

There are several resources available to learn more about Radius Resource Types.

* Mark Russinovich, the Azure CTO and sponsor of the Radius project introduced and demoed Radius Resource Types at the [June Radius Community Call](https://www.youtube.com/watch?v=MNuoMSIs4Jo).
* There are two tutorials in the Radius documentation, one for [creating a PostgreSQL resource type](https://docs.radapp.io/tutorials/create-resource-type/) and a [second for creating a composite recipe for a web service resource type](https://docs.radapp.io/tutorials/create-composite-recipe/).

## Get Involved

We would love for you to join us to help build Radius:

- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos