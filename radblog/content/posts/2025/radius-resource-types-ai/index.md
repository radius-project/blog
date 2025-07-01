---
date: "2025-07-07"
title: "Introducing AI capabilities to Developer teams with Radius Resource Types"
linkTitle: "Radius Resource Types and AI"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: "blog"
---

## Platform Engineering in the AI Era

Platform engineering teams today grapple with a complex challenge: how do you enable developers to build AI powered applications while maintaining organizational security and compliance practices. The challenge extends beyond simply deploying AI services, teams must provide developers with standardized interfaces to AI resources while preserving the flexibility to switch between AI services from providers without rewriting application code. Radius Resource Types addresses this complexity by enabling platform engineers to create new resource abstractions that encapsulate cloud-specific AI implementations behind developer-friendly APIs.

Traditional approaches to AI integration require developers to learn provider-specific APIs and manage complex infrastructure configurations. This creates vendor lock-in and increases cognitive load on development teams. When organizations decide to migrate between cloud providers, or adopt multi-cloud strategies, the effort required to refactor applications becomes significant. Platform engineering teams are in need of solutions that separate the application definition from the underlying infrastructure implementation, enabling developers to focus on building features rather than managing AI service configurations.

## Radius Resource types for AI Integration

Radius provides a foundational platform for building internal developer platforms by introducing an application-centric model that abstracts infrastructure complexity. The platform enables organizations to define applications and their resource dependencies without coupling them to specific cloud providers. Through its Environment and Recipe concepts, Radius enables platform engineers to configure how resources are deployed across different environments while maintaining consistent developer interfaces. This separation of concerns enables developer teams to have self-serve paved paths without having to understand the underlying infrastructure details.

The introduction of Radius Resource Types extends this foundation by allowing platform engineers to define custom resource types specific to their organization's needs. This capability transforms how teams approach AI integration by enabling the creation of AI resource types that abstract the complexity of deploying the AI model of their choice to the hosting provider of their choice. Platform engineers can define the developer interface through while implementing the actual infrastructure through Terraform or Bicep Recipes. This approach ensures that switching between cloud providers requires no changes to application code—only updates to the underlying Recipe configuration.

## TodoList Application sample

The [TodoList Application](https://github.com/Reshrahim/todoapp-ai) sample application demonstrates how Radius Resource Types can be used to integrate AI capabilities.

The application defines a custom `feedbackAI` resource type that provides AI capabilities for task feedback. The resource type definition specifies a simple interface requiring only a `model` parameter from developers. 

```
name: Radius.Resources
types:
  feedbackAI:
    capabilities: ["SupportsRecipes"]
    apiVersions:
      '2023-10-01-preview':
        schema: 
          type: 'object'
          properties: 
            environment:
              type: string
              description: "Required: The Radius environment; typically set by the rad CLI"
            application:
              type: string
              description: "Optional: The application which the resource is associated with"
            model:
              type: string
              description: "Required: The model name, used by the AI service to connect to the API."
            apiKey: 
              type: string
              description: "Read-only: The key that can be used to connect to the API."
              readOnly: true
            apiVersion:
              type: string
              description: "Read-only: The version of the OpenAI API."
              readOnly: true
            endpoint:
              type: string
              description: "Read-only: The endpoint URL of the OpenAI API."
              readOnly: true
            region:
              type: string
              description: "Read-only: The region where model is deployed"
              readOnly: true
          required:
              - environment 
```         
Below is how developers can use this resource type in their application definition:

{{< image src="images/developer-interface.png" alt="Screenshot of developer interface in VSCode" width="70%">}}

Behind this interface, we have implemented Recipes for both Azure OpenAI and AWS Bedrock that handle the complexity of service provisioning, authentication, and configuration management.

<insert Recipes diagram that shows portability>

The application structure demonstrates cloud portability in practice. The Bicep application definition remains identical regardless of the target cloud provider.

{{< image src="images/application.png" alt="Screenshot of application definition in VSCode" width="70%">}}

When developers reference the `feedbackAI` resource, they do not know the underlying implementation details. They simply specify the model they want to use, such as `anthropic.claude-3-sonnet` or `GPT4` and the Radius platform handles the rest including injecting the environment variables via connections for their application to access the AI service.

{{< image src="images/connections.png" alt="Screenshot of Connections to container" width="70%">}}

The [Azure Recipe](https://github.com/Reshrahim/todoapp-ai/tree/main/recipes/azure-openai) deploys an Azure Cognitive Services account with OpenAI capabilities and configures For e.g.: Open AI GPT model of choice from developer. You can use any existing Terraform configuration or Bicep template as a Radius Recipe. To convert an existing Terraform configuration into a Radius Recipe, you simply need to ensure that it adheres to the Radius Recipe format which includes defining the `context` and `outputs`. The `context` parameter has all the properties that developers provide when defining the resource type in the application definition, while the `outputs` section defines the values that will be returned to the application after provisioning the resource.

```tf
variable "context" {
  description = "This variable contains Radius Recipe context."
  type = any
}
```

```tf 
output "result" {
  value = {
    values = {
      model = "model_name"
      endpoint ="https://example.openai.azure.com/" 
    }
  }
}
```

The [AWS Recipe](https://github.com/Reshrahim/todoapp-ai/tree/main/recipes/aws-bedrock) provisions IAM users with Bedrock permissions and configures access to For e.g. : Anthropic's Claude 3 Sonnet model. Despite these significant implementation differences, the developer experience remains consistent.

Radius Resource Types represents a fundamental shift in how organizations approach platform engineering in the AI era. By providing the tools to create custom abstractions that separate application logic from infrastructure implementation, platform engineering teams can deliver AI capabilities to developers while ensuring consistent security configurations, cost controls and preserving the operational flexibility that modern cloud strategies require. The combination of standardized developer interfaces with cloud-agnostic implementations enables organizations to embrace AI innovation while maintaining architectural flexibility and operational consistency.

## Learn more and Contribute 

We would love for you to join us to help build Radius:

- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
