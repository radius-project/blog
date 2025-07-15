---
date: "2025-07-14"
title: "Future proofing AI applications via Radius Resource Types "
linkTitle: "Radius Resource Types and AI"
author: "[Reshma Abdul Rahim](https://github.com/Reshrahim)"
type: "blog"
---

## Building Applications in the AI Era

Imagine you’re an enterprise developer building your first AI-powered application. You start with Anthropic’s Claude, ramp on the APIs, write your application code, configure authentication, test the application and successfully deploy it to production. Everything is working great but, three months later, your organization migrates to an entirely different AI model, such as Google Gemini, for better results or for cost optimization. Suddenly, you’re facing days or weeks of refactoring and testing across environments before redeploying the same application using the different model. 

This scenario plays out daily in organizations embracing AI. The rapid evolution of AI means today’s technical decisions may not align with tomorrow’s AI requirements and capabilities. So, platform engineers must provide Internal Developer Platforms that make it easy to develop AI applications while enabling them to adapt to changing AI providers and models without extensive rewrites. This challenge isn’t just technical, it’s architectural. How does an IDP enable developers to build applications that remain loosely coupled to an underlying AI model, while providing developers a consistent, simple interface in cases where the underlying models change? 

## The Application Contract: Separating What from How

The solution lies in establishing a clear contract with developers, a contract that separates developers’ infrastructure requirements from the implementation details of how that infrastructure is configured and deployed. Such an application contract must define a stable interface that remains consistent regardless of the underlying AI provider or model. 

Radius Resource Types enable this contract: Platform engineers use Radius to define custom application resources, including AI models. They enable configuration and deployment of those resources via Radius Recipes, which are infrastructure templates in Bicep or Terraform. Developers simply reference the required resources in their application via simple, high-level abstractions. Infrastructure Recipes, in turn, handle all the implementation details and execution of infrastructure configuration and deployment.

{{< image src="images/dev-platformeng-graphic.png" alt="Screenshot of Developer and Platform engineer workflow" width="70%">}}

This separation enables developers to focus on building applications while platform teams focus on maintaining infrastructure consistency and governance. When business requirements change - a new AI strategy, new compliance rules, cost optimization, or cloud migration - platform teams simply update Recipes without disrupting application development or compatibility. 

### The Developer Experience: Simple and Consistent Interface

For a developer, that means adding an AI service to their Radius application is as simple as adding a reference to the AI resource provided by their IDP and then setting a few parameters. Instead of diving into cloud provider documentation, wrestling with authentication flows, or configuring service endpoints, a developer just declares their intent with this simple syntax:

{{< image src="images/ai-interface.png" alt="Screenshot of AI resource interface in VSCode" width="70%">}}

The developer has access to an AI model catalog, curated by their platform engineering team - from lightweight `TinyLlama` for quick prototyping to production-ready `GPT 3.5 Turbo` and `Claude 3 Sonnet` for enterprise features. When developers need to experiment with different models, they simply change one parameter.

The best part is that Radius makes it simple to connect a given container in your application to an AI service. No more wrestling with API keys, endpoints, or different authentication schemes—everything gets injected as environment variables.

{{< image src="images/connections.png" alt="Screenshot of connections" width="70%">}}

And deploy the application with a single command to the environment of choice

```sh
rad deploy todolist.bicep --environment azure
```
or

```sh
rad deploy todolist.bicep --environment aws
```

For production deployments, teams typically embrace GitOps workflows. Radius seamlessly integrates into these existing workflows, supporting [GitOps tools](https://docs.radapp.io/guides/deploy-apps/gitops/overview/) like Flux and with planned support for Argo CD in the future. This means your AI applications can be deployed and managed through the same CI/CD processes your team already uses, maintaining consistency with your broader deployment strategy.

Whether your platform team provisions this using Azure’s Cognitive Services, AWS Bedrock’s Claude models, or tomorrow’s next-generation AI provider, this application contract never changes. The developer experience remains constant while the infrastructure beneath evolves freely. Radius recipes handle the complexity of authentication, rate limiting, and service configuration automatically.

While Radius mitigates developer exposure to the complexity of infrastructure configuration and deployment, some changes in application runtime may still be necessary. For instance, switching from GPT 3.5 Turbo to Claude 3 Sonnet will require modifying how your runtime code interacts with the model. To abstract your runtime code, use [Dapr’s conversation building block](https://docs.dapr.io/developing-applications/building-blocks/conversation/conversation-overview/), which provides a single API for calling underlying LLMs. It can be used alongside Radius Resource Types to ensure both infrastructure deployments and the application runtime code is LLM agnostic.

### The Platform Engineering Experience: Orchestrating the Experience Behind the Scenes

To enable the developer experience described above, platform engineers work behind the scenes crafting the resource catalog and Recipes that transform abstract developer requests into concrete cloud/platform resources while maintaining the application contract. 

{{< image src="images/platformeng-interface.png" alt="Screenshot of platform engineering experience" width="70%">}}

Platform engineers define the schema definition for the `aiModels` resource type, specifying the parameters developers can use to request AI services. They then implement Recipes using Bicep or Terraform that deploy the infrastructure. Recipes use the input context provided by the developer to provision the necessary resources and return output values in a standardized format that Radius can inject into the application.

**The Kubernetes Recipe** - When a developer requests a `TinyLlama` model, the Kubernetes Recipe deploys a containerized service that downloads the TinyLlama model binary, configures authentication, and outputs the necessary values needed for the application to connect.

**The Azure Recipe** - When a developer requests `GPT 3.5 Turbo` model, the Azure Recipe deploys Cognitive Services, configures authentication, and outputs the necessary values needed for the application to connect.

**The AWS Recipe** - When a developer requests `Claude 3 Sonnet` model, the AWS Recipe handles the entirely different world of IAM roles and Bedrock permissions and injects the needed environment values needed for the application to connect seamlessly.

When the next breakthrough AI service emerges or when new compliance requirements arise or when cost optimization opportunities appear from hosting providers, platform engineers can implement the requirements at the Recipe level without disrupting development workflows. 

Check out the [Radius Todo List Application](https://github.com/Reshrahim/todoapp-ai) which includes an AI feedback feature, demonstrating this approach in practice.

## Get Involved

We would love for you to join us to help build Radius:

- Try the [Radius Todo List Application](https://github.com/Reshrahim/todoapp-ai)
- Check out the [Radius Resource types tutorial](https://docs.radapp.io/tutorials/create-resource-type/)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
