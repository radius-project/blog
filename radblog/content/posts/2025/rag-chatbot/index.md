---
date: "2025-11-24T08:00:00-08:00"
title: "Deploy a RAG chatbot app using Radius"
linkTitle: "RAG chatbot with Radius"
author: "Will Tsai"
type: blog
---

Agentic AI applications are rapidly becoming a cornerstone of modern software, enabling systems to reason, act, and interact with data in unprecedented ways. As these intelligent applications grow in complexity, managing their infrastructure and governance becomes increasingly challenging. For instance, a Retrieval-Augmented Generation (RAG) chatbot application might require a combination of vector databases, large language models (LLMs), and traditional compute, on top of which considerations like dependency management, security, and compliance are layered. Indeed, when looking at some of the most popular AI sample applications, we see that they often involve multiple components and services that need to be orchestrated outside the bounds of the core application itself before the application can even run. 

We wanted to illustrate how Radius can streamline the building and deploying of these modern AI workloads, ensuring they are portable, secure, and easy to manage. This brings us to the demo that we've built: leveraging Radius to model and deploy the [azure-sql-db-chat-sk](https://github.com/willtsai/azure-sql-db-chat-sk/tree/radius-insurance-chatbot-demo) sample chatbot from the open source [Azure Samples repo](https://github.com/Azure-Samples/azure-sql-db-chat-sk). This demo illustrates how Radius simplifies the deployment and governance enforcement of intelligent applications across multiple environments. You may view a video of this demo in action from this session at [Microsoft Ignite 2025: Cloud Native Innovations with Mark Russinovich](https://ignite.microsoft.com/en-US/sessions/BRK431)

<iframe width="560" height="315" src="https://www.youtube.com/embed/NMNZE22nSQI?si=CYbi7YAOFqnZmGpw&amp;start=1889" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

To try the demo for yourself, follow the Radius deployment [instructions](https://github.com/willtsai/azure-sql-db-chat-sk/tree/radius-insurance-chatbot-demo?tab=readme-ov-file#deployment-with-radius) in the repo.

## Overview of the sample chatbot application

The application is a chatbot designed for insurance claims agents. It uses a SQL Server database to store and retrieve data, leveraging both Retrieval-Augmented Generation (RAG) and Natural-Language-to-SQL (NL2QL) mechanisms. This allows the bot to chat effectively using both structured (tables) and unstructured (vector embeddings) data.

The bot is built using the [Semantic Kernel](https://github.com/microsoft/semantic-kernel) agent orchestration framework and takes advantage of the native vector support in SQL Server.

{{< image src="images/sql-db-chat-sk.png" alt="Architecture diagram of the SQL DB Chatbot application" width="500" >}}

## Modeling the chatbot app using Radius

First, we containerized the chatbot application code using Docker and pushed the container image to a container registry. Then, we used Radius to model the entire application, defining the relationships between the chatbot container and its dependent resources: the SQL database and OpenAI services.

{{< image src="images/sql-db-chat-sk-radius.png" alt="Architecture diagram of the SQL DB Chatbot application with Radius" width="800" >}}

### Radius Resource Types and Recipes for dependencies

We defined [Radius Resource Types](https://github.com/willtsai/azure-sql-db-chat-sk/blob/radius-insurance-chatbot-demo/types/types.yaml) to model the SQL Server database and AI models, which are deployed using Bicep Recipes. These [Recipes](https://github.com/willtsai/azure-sql-db-chat-sk/tree/radius-insurance-chatbot-demo/recipes) encapsulate the provisioning logic for these resources to abstract them away from developers, allowing for dynamic infrastructure decisions at deploy time. For example, the SQL Server database Recipe provisions different Azure SQL Database SKUs based on the target [Radius Environment](https://github.com/willtsai/azure-sql-db-chat-sk/tree/radius-insurance-chatbot-demo/environments). This abstraction allows developers to request these resources without needing to know the underlying infrastructure details. The developer simply requests a "SQL Server database" or an "AI model," and Radius handles the provisioning based on the target Environment's configuration.

### Radius Application definition

As mentioned above, the developer is able to build a declarative application definition that focuses on the application logic and dependencies without worrying about the underlying infrastructure. For our demo chatbot app, the application definition includes a container for the chatbot service, a SQL Server database for the vector store, and AI models for chat and embeddings, all encapsulated in a single [application definition](https://github.com/willtsai/azure-sql-db-chat-sk/blob/radius-insurance-chatbot-demo/app.bicep). Radius builds the application graph dynamically based on the resources that get deployed and [connections](https://docs.radapp.io/concepts/applications/#connections) between resources are automatically established.

{{< image src="images/chatbot-app-graph.png" alt="Screenshot of Radius Application Graph for Chatbot app" width="500" >}}

### Multi-environment deployment

In our demo, we targeted three distinct Radius Environments:

1.  `ACI`: A lightweight environment for quick testing running on Azure Container Instances
2.  `AKS Dev`: A development environment running on Azure Kubernetes Service
3.  `AKS Prod` A production environment with stricter governance running on Azure Kubernetes Service

Radius deploys the exact same application definition to all three environments without requiring any changes to the code or the `app.bicep` file.

{{< image src="images/sql-db-chat-sk-radius-environments.png" alt="Diagram of Radius Resource Types for SQL Database and AI Models" width="800" >}}

## Governance and guardrails using Radius

A key highlight of the demo is leveraging Radius for seamless governance enforcement. We demonstrated how Radius Environments can enforce different policies and configurations for each deployed resource transparently to the application and developer.

Specifically, we implemented separate database configurations (SKUs, disaster recovery, multizone redundancy) for Dev and Prod environments and added AI content filtering to prevent "jailbreak" attempts in Prod.

*   **Dev Environment**: The SQL Database uses a lower SKU and does not have disaster recovery or multizone redundancy enabled for cost savings. The jailbreak content filtering is relaxed or disabled for testing purposes.
*   **Prod Environment**: The SQL Database uses a higher SKU with disaster recovery and multizone redundancy enabled for resilience. The jailbreak content filtering is strictly enforced.

This configuration is managed entirely through Radius Environment parameters. The SQL Server database and AI model Recipes accept parameters configured at the Environment level. When deploying to Prod, the Environment automatically passes the database resiliency and strict content filtering configurations to the Recipes.

{{< image src="images/sql-db-chat-sk-radius-parameters.png" alt="Diagram of Radius Environment parameters for Recipes" width="800" >}}

## Seeing it in action

The platform engineering team sets up the Radius Resource Types, Recipes, and Environments by running the below commands:

```bash
# Create the Resource Types from the types.yaml file
rad resource-type create --from-file ./types/types.yaml
```

```bash
# Deploy each Environment using its respective defintion file 
#   (i.e. aci-dev.bicep, aks-dev.bicep, aks-prod.bicep)
rad deploy ./environments/<env-definition>.bicep --parameters subscriptionId=<subscriptionId> --parameters resourceGroupName=<resourceGroupName>
```

Developers can then deploy the chatbot app to any of the available Environments using the same application definition file and providing the desired chat and embedding model names as parameters:

```bash
# Target the aci-dev environment using gpt-3.5-turbo and text-embedding-ada-002 models
rad deploy app.bicep --environment aci-dev --parameters chatModelName=gpt-35-turbo --parameters embeddingModelName=text-embedding-ada-002

# Target the aks-dev environment using gpt-4 and text-embedding-3-small models
rad deploy app.bicep --environment aks-dev --parameters chatModelName=gpt-4 --parameters embeddingModelName=text-embedding-3-small

# Target the aks-prod environment using gpt-4 and text-embedding-3-small models
rad deploy app.bicep --environment aks-prod --parameters chatModelName=gpt-4 --parameters embeddingModelName=text-embedding-3-small
```

When running the demo, the difference in behavior is observed based on the target environment:
1.  **Deploy to Dev**: We deploy the app to the AKS Dev environment and see the database configured with a lower SKU and no disaster recovery or multizone redundancy. We attempt a jailbreak prompt, and the bot might respond (or the filter is loose).
1.  **Deploy to Prod**: We deploy the same app to the AKS Prod environment and see the database configured with a higher SKU and disaster recovery and multizone redundancy enabled. We attempt the same jailbreak prompt. This time, the Azure OpenAI content filters kick in, and the chatbot refuses to answer, flagging the attempt.

This demonstrates how platform engineers can enforce security and compliance standards (like database SKUs, redundancy, and AI safety) across environments without burdening developers with the details.

{{< image src="images/chatbot-jailbreak.png" alt="Screenshot of chatbot refusing to answer jailbreak prompt in Prod environment" width="800" >}}
<br>

## In summary

This demo showcases the "Write Once, Run Anywhere" promise of Radius, not just for compute, but for the entire application topology including dependencies and configuration. By decoupling the application needs from the infrastructure capabilities, Radius enables developers to move fast while ensuring platform engineers can maintain control and governance.

Check out the [source code](https://github.com/willtsai/azure-sql-db-chat-sk/tree/radius-insurance-chatbot-demo?tab=readme-ov-file#deployment-with-radius) to try it yourself!

## Get Involved with Radius

- **Monthly Community Meetings:** Join the [Radius Google Group](https://groups.google.com/g/radapp_io) for announcements.
- **Discord:** Connect with us and other contributors on the [Radius Discord](https://aka.ms/radius/discord).
- **YouTube:** Watch demos and tutorials on the [Radius YouTube channel](https://www.youtube.com/@radapp_io).