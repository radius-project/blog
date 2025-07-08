---
date: "2025-07-07"
title: "Building AI applications with Radius Resource Types"
linkTitle: "Radius Resource Types and AI"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: "blog"
---

## Building Applications in AI Era

Imagine you're a developer tasked with building an AI-powered application. You start with Azure OpenAI, write your application code, configure authentication, and deploy successfully. Three months later, your organization decides to migrate to use another model like Anthropic Claude for better results or for cost optimization. Suddenly, you're facing weeks of refactoring—updating API calls, reconfiguring authentication, and testing across environments.

This scenario plays out daily in organizations embracing AI. The rapid evolution of AI services means today's technical decisions may not align with tomorrow's business requirements. Developers need applications that can adapt to changing AI providers and models without requiring extensive rewrites. Platform teams need solutions that provide governance and standardization while maintaining flexibility.

The challenge isn't just technical—it's architectural. How do you build AI applications that remain portable across clouds while providing developers with a consistent, simple interface?

## The Application Contract: Separating What from How

The solution lies in establishing a clear contract that separates what developers need from how infrastructure teams provide it. This contract defines a stable interface that remains consistent regardless of the underlying AI provider or model. Radius resource types enable this by enabling developers to declare their intent without worrying about implementation details.

{{< image src="images/dev-pe-graphic.png" alt="Screenshot of AI resource interface in VSCode" width="70%">}}

This separation enables developers to focus on building features while platform teams maintain infrastructure consistency and governance. When business requirements change—new compliance rules, cost optimization, or cloud migration—platform teams can update recipes without disrupting application development.

### The Developer Experience: Simple Interface, Powerful Flexibility

Picture this: A developer sits down Monday morning with a simple goal to add an AI service to their application. Instead of diving into cloud provider documentation, wrestling with authentication flows, or configuring service endpoints, they can just declare their intent like this:

{{< image src="images/ai-interface.png" alt="Screenshot of AI resource interface in VSCode" width="70%">}}

They can connect the AI service to their application using Radius connections that seamlessly injects the necessary credentials and endpoints as environment variables, creating a universal interface that works regardless of the underlying provider. 

{{< image src="images/connections-interface.png" alt="Screenshot of AI resource interface in VSCode" width="70%">}}

That's it. No Azure-specific configurations. No AWS IAM policies. No Google Cloud service accounts. Just a clean declaration of intent: "I need to add AI capabilities to my application"

Whether your platform team provisions this using Azure's Cognitive Services, AWS Bedrock's Claude models, or tomorrow's next-generation AI provider, this application contract never changes. The developer experience remains constant while the infrastructure beneath evolves freely.

```sh
rad deploy todolist.bicep --environment azure
```
or

```sh
rad deploy todolist.bicep --environment aws
```

Developers can experiment with cutting-edge models like GPT-4, Claude 3.5, or emerging open-source alternatives by changing a single parameter. The platform handles the complexity of authentication, rate limiting, and service configuration automatically.

Imagine telling your team: "We're switching from Azure OpenAI to AWS Bedrock for cost optimization." Instead of groans and sprint planning for migration work, you get nods and updated environment configurations. The applications continue running, the developers keep building features, and the business adapts to changing requirements without friction.

### The Platform Engineering Experience: Orchestrating the Magic Behind the Scenes

While developers enjoy the simplicity of a single interface, platform engineers work behind the curtain as the architects of this seamless experience. They craft Recipes—intelligent infrastructure templates that transform abstract developer requests into concrete cloud/platform resources while maintaining the sacred contract.

Think of it as culinary artistry: developers order "AI capabilities" from the menu, but platform engineers are the master chefs who know exactly how to prepare the Recipe using Azure's ingredients, AWS's techniques, or Google Cloud's flavors—all 

**The Kubernetes Recipe** - When a developer requests a Tiny Llama model, the Kubernetes Recipe springs into action. It deploys a containerized service that runs the `tinyllama` model, configures authentication, and outputs the necessary values needed for the application to connect seamlessly

**The Azure Recipe** - When a developer requests GPT-4, the Azure Recipe springs into action. It deploys Cognitive Services, configures authentication, and outputs the necessary values needed for the application to connect seamlessly:

**The AWS Recipe** - Now with AWS, The AWS Recipe handles the entirely different world of IAM roles and Bedrock permissions and injects the needed environment values needed for the application to connect seamlessly

When the next breakthrough AI service emerges or when new compliance requirements arise or when cost optimization opportunities appear from hosting providers, platform engineers can implement the requirements at the Recipe level without disrupting development workflows.

The [AI-Enhanced Todo Application](https://github.com/Reshrahim/todoapp-ai) demonstrates this approach in practice. The application includes task feedback powered by AI, but the implementation showcases true cloud portability.

## Looking Forward

The AI landscape will continue evolving rapidly. New providers will emerge, existing services will change, and organizational requirements will shift. The contract-based approach with Radius Resource Types provides the architectural foundation to navigate this evolution successfully.

By separating the developer interface from infrastructure implementation, organizations can embrace AI innovation while maintaining operational flexibility. The contract ensures consistency for developers while enabling platform teams to optimize, migrate, and evolve infrastructure independently.

This approach represents more than a technical solution—it's a new way of thinking about AI integration that prioritizes adaptability, simplicity, and long-term sustainability.

## Learn More and Get Started

Ready to build future-proof AI applications? Explore the complete tutorial and examples:

- Try the [AI-Enhanced Todo Application tutorial](https://github.com/Reshrahim/todoapp-ai) for hands-on experience
- Join our monthly community meeting for demos and updates ([Radius Google Group](https://groups.google.com/g/radapp_io))
- Get help and discuss on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
