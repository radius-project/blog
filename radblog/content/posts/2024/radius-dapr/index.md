---
date: "2024-06-27T08:00:00-08:00"
title: "Radius plus Dapr for Portable Cloud Apps"
linkTitle: "Radius plus Dapr"
author: "[Jonathan Smith](https://www.github.com/jonvsm)"
type: blog
---

# Prerequisites

This post assumes you understand Radius and have at least completed the Radius "Getting Started Guide."  If you are not familiar with Radius you can get an introduction and complete the getting started guide at [https://docs.radapp.io/](https://docs.radapp.io/getting-started/). This post does not assume you are familiar with Dapr but that familiarity is helpful.  To learn about Dapr, please see [https://docs.dapr.io/](https://docs.dapr.io/).

# Summary

Many enterprise applications teams prioritize the ability to build portable applications that can run on-premise or on their public cloud of choice. Enabling such application portability requires solving two basic problems: 1) your application code itself must be compatible with each of those environments; and 2) your application definition and deployment must be compatible as well. As you have learned, Radius addresses #2, defining and deploying applications in a consistent manner compatible across on-premise, Azure and AWS. This post shows how you can use Dapr's cloud-agnostic building blocks to help address #1, making your application runtime code portable. 

# Portability is needed in both the application deployment and runtime

Let's assume you are a developer who is very familiar with building applications on AWS. You are experimenting with Radius to make your application and its infrastructure deployable to your on-premise cloud and to Azure, in addition to AWS. You have described a simple Radius application per the snippet below. That application includes a front end container connected to AWS DynamoDB for state storage. Given this Radius application definition, the application can successfully deploy to AWS, Azure and on-premise via Radius, which is great!  However, because the application depends on DynamoDB, a proprietary AWS service, the application can only run successfully on AWS. That is, the application and infrastructure definition and deployment are portable via Radius, but the application runtime code is not.  

```
import radius as radius
import aws as aws

param environment string
param application string
param table string = 'myTable'

//Parameters for your AWS account
@secure()
param aws_access_key_id string

@secure()
param aws_secret_access_key string
param aws_region string = 'us-west-2'

//Create an DynamoDB statestore
resource statestore 'AWS.DynamoDB/Table@default' = {
  alias: 'statestore'
  properties: {
    TableName: table
  }
}

// Create a Radius application
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myApp'
  properties: {
    environment: environment
  }
}

//Create a frontend container resource
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: myApp
    container: {
      env: {
        TABLE_NAME: statestore.properties.TableName
        AWS_ACCESS_KEY_ID: aws_access_key_id
        AWS_SECRET_ACCESS_KEY: aws_access_key
        AWS_DEFAULT_REGION: aws_region
      }
      image: 'myImage'
    }
  }
}

```
## How do you make the application's runtime code portable?  

That's where Dapr comes in.  Dapr provides a set of cloud-agnostic building blocks that enable you to leverage common cloud application patterns like Publish and Subscribe, Secret Management, State Management and more. By referencing Dapr building blocks instead of a proprietary services like DynamoDB, in your Radius application, you can make your application code portable across on-premise and public clouds.  Radius has deep integration with Dapr so it's easy to add Dapr building blocks to your Radius application.  

# What exactly is Dapr?

Dapr is a portable, event-driven runtime that makes it easy for developers to build resilient, stateless and stateful applications that run on the cloud and edge and embraces the diversity of languages and developer frameworks. Leveraging the benefits of a sidecar architecture, Dapr helps developers tackle the challenges that come with building microservices and keeps application code platform-agnostic. Dapr provides a set of building blocks that encapsulate best practices for common cloud application patterns like state management, pub/sub messaging, service-to-service, invocation, and more.  For more information about Dapr see https://docs.dapr.io/.

{{< image src="images/DaprOverview.png" alt="Dapr Overview Diagram" width="600" >}}

# How to use Dapr Building Blocks in Radius applications

The following code shows how the same Radius application above can reference the Dapr State Store building block instead of DynamoDB.  In addition to adding the Dapr state store to your application definition, you'll need to change your application code to call the Dapr state store API vs the DynamoDB API.  With that work complete, and with the Radius application definition below, your application code will be fully portable across on-premise and public clouds.  

```
//You still import Radius, but not AWS
import radius as radius

param environment string
param application string

//Create an Dapr statestore via Applications.Dapr, instead of creating a DynamoDB state store
resource statestore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: application
  }
}

// Create a Radius application
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'MyApp'
  properties: {
    environment: environment
  }
}

//create a container resource that includes a dapr sidecard extension and a connection between the statestore and the container 
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: application
    container: {
      image: 'myImage'
      }
      extensions: [
        {
          kind: 'daprSidecar'
          appId: 'MyApp'
          appPort: 3000
    
        }    
      ]
      connections: {
        redis: {
          source: statestore.id
      
        }
      }    
    }  
  }    

```

# What if I need application portability, but I still want or need to use DynamoDB or some other technology?

By default, Dapr uses Redis as the backing store for its State Store building block.  But, the Dapr State Store building block supports a range of other storage technologies.  See this guide for options and guidance - https://docs.dapr.io/reference/components-reference/supported-state-stores/

## Tutorial

If you'd like to learn more, the following tutorial provides a hands on end-end experience of adding a Dapr state store to a Radius application then deploying and testing that application - https://docs.radapp.io/tutorials/dapr/.

## How-To Guides

These How-To Guides walk you through targeted, common steps you will complete whenever using Dapr with Radius. 
Overview - https://docs.radapp.io/guides/author-apps/dapr/overview/
Add a Dapr sidecar to a container in your Radius application - https://docs.radapp.io/guides/author-apps/dapr/how-to-dapr-sidecar/
Add a Dapr Building Block to your Radius application - https://docs.radapp.io/guides/author-apps/dapr/overview/ 

# Learn more and Contribute 

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We’re looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).
