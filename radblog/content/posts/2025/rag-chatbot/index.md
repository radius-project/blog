---
date: "2025-11-24T08:00:00-08:00"
title: "Deploy a RAG chatbot app using Radius"
linkTitle: "RAG chatbot with Radius"
author: "Will Tsai"
type: blog
---

Agentic AI applications are rapidly becoming a cornerstone of modern software, enabling systems to reason, act, and interact with data in unprecedented ways. As these intelligent applications grow in complexity, managing their infrastructure and governance becomes increasingly challenging. For instance, a Retrieval-Augmented Generation (RAG) chatbot application might require a combination of vector databases, large language models (LLMs), and traditional compute, on top of which considerations like dependency management, security, and compliance are layered. Indeed, when looking at some of the most popular AI sample applications, we see that they often involve multiple components and services that need to be orchestrated outside the bounds of the core application itself before the application can even run. 

We wanted to illustrate how Radius can streamline the building and deploying of these modern AI workloads, ensuring they are portable, secure, and easy to manage. This brings us to the demo that we've built: leveraging Radius to model and deploy the [azure-sql-db-chat-sk](https://github.com/willtsai/azure-sql-db-chat-sk/tree/radius-insurance-chatbot-demo) sample chatbot from the open source [Azure Samples repo](https://github.com/Azure-Samples/azure-sql-db-chat-sk). This demo illustrates how Radius simplifies the deployment and governance enforcement of intelligent applications across multiple environments.

https://github.com/willtsai/azure-sql-db-chat-sk/tree/radius-insurance-chatbot-demo?tab=readme-ov-file#deployment-with-radius

## Overview of the sample chatbot application

The application is a chatbot designed for insurance claims agents. It uses SQL Server Database to store and retrieve data, leveraging both Retrieval-Augmented Generation (RAG) and Natural-Language-to-SQL (NL2QL) mechanisms. This allows the bot to chat effectively using both structured (SQL tables) and unstructured (vector embeddings) data.

The bot is built using the [Semantic Kernel](https://github.com/microsoft/semantic-kernel) agent orchestration framework and takes advantage of the native vector support in SQL Server Database.

{{< image src="images/sql-db-chat-sk.png" alt="Architecture diagram of the SQL DB Chatbot application">}}

## Modeling the chatbot app using Radius

We used Radius to model the entire application, defining the relationships between the chatbot container and its dependent resources: the SQL database and OpenAI services.

{{< image src="images/sql-db-chat-sk-radius.png" alt="Architecture diagram of the SQL DB Chatbot application with Radius">}}

### Radius Resource Types for Dependencies

We defined custom **Radius Resource Types (RRTs)** for the SQL Database and OpenAI models. This abstraction allows developers to request these resources without needing to know the underlying infrastructure details.

{{ < image src="images/resource-types.png" alt="Screenshot of Radius Resource Types for SQL Database and AI Models"> }}

### Radius Recipes for Infrastructure

Instead of hardcoding infrastructure details, we utilized **Radius Recipes** for the SQL database and OpenAI resources. This allows the application definition to remain environment-agnostic. The developer simply requests a "SQL Database" or an "OpenAI Model," and Radius handles the provisioning based on the environment's configuration.

### Multi-Environment Deployment

The power of Radius shines when deploying to different environments. In this demo, we targeted three distinct Radius Environments:

1.  **ACI (Azure Container Instances)**: A lightweight environment for quick testing.
2.  **AKS Dev (Azure Kubernetes Service)**: A development environment on Kubernetes.
3.  **AKS Prod (Azure Kubernetes Service)**: A production environment with stricter governance.

Radius deploys the exact same application definition to all three environments without requiring any changes to the code or the application model.

## Governance and Guardrails: The Jailbreak Scenario

A key highlight of the demo is **governance enforcement**. We demonstrated how Radius Environments can enforce different policies and configurations transparently to the application.

Specifically, we implemented **AI content filtering** to prevent "jailbreak" attempts—where users try to manipulate the LLM into ignoring its instructions.

*   **Dev Environment**: The jailbreak content filtering is relaxed or disabled for testing purposes.
*   **Prod Environment**: The jailbreak content filtering is strictly enforced.

This configuration is managed entirely through **Radius Environment parameters**. The AI Model Recipes accept parameters configured at the Environment level. When deploying to Prod, the Environment automatically passes the strict content filtering configuration to the Recipe.

## Seeing it in Action

When running the demo, we can see the difference in behavior:

1.  **Deploy to Dev**: We deploy the app to the AKS Dev environment. We attempt a jailbreak prompt, and the bot might respond (or the filter is loose).
2.  **Deploy to Prod**: We deploy the same app to the AKS Prod environment. We attempt the same jailbreak prompt. This time, the Azure OpenAI content filters kick in, and the chatbot refuses to answer, flagging the attempt.

This demonstrates how platform engineers can enforce security and compliance standards (like database SKUs, encryption, and AI safety) across environments without burdening developers with the details.

## Conclusion

This demo showcases the "Write Once, Run Anywhere" promise of Radius, not just for compute, but for the entire application topology including dependencies and configuration. By decoupling the application needs from the infrastructure capabilities, Radius enables developers to move fast while ensuring platform engineers can maintain control and governance.

Check out the [source code](https://github.com/willtsai/azure-sql-db-chat-sk/tree/radius-insurance-chatbot-demo) to try it yourself!
