---
date: "2026-09-21T07:00:00-07:00"
title: "Day One in an Unknown Repo"
linkTitle: "Day One in an Unknown Repo"
author: "[Nithya Subramanian](https://github.com/nithyatsu)"
type: blog
draft: true
---

Earlier this month, the Radius team shared the public preview of
[Radius Canvas for the GitHub Copilot app](https://techcommunity.microsoft.com/blog/azuredevcommunityblog/introducing-radius-canvas-visualize-review-and-deploy-applications-in-the-github/4549760).
Radius Canvas gives you an application graph: a picture of your application's workloads,
the resources they depend on, and the connections between them, drawn from an
application model that lives in your repository.

We have been using it on our own projects, and we want to share what that looks like
across the whole developer journey. So this post is the first in a series. Each post
follows a developer through one stage of working with an application: getting to know
it, reviewing changes to it, and taking it all the way to the cloud.

We are starting at the very beginning, with **day one in an unknown repository**:
discovering the application, generating an application model, and understanding its
architecture before writing a single line of code.

## Getting to know a new repository

Joining a new team, picking up an open source project, or taking over a service from a
colleague usually starts the same way. You clone the repository and spend the first
morning figuring out what the application is actually made of. Which folders are
services? What do they talk to? Which databases, caches, and queues are involved, and
who depends on whom?

In this post we will use
[Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo), a sample
e-commerce application where visitors browse products, add them to a cart, and check
out. It has ten services written in Go, C#, Node.js, Python, and Java, plus a Redis
cache for shopping carts. The front end, the business services behind it, and the data
store make it a good example of a multi-tier application.

The answers are rarely in one place. They are spread across Dockerfiles, compose files,
Kubernetes manifests, configuration, and the source code itself, each describing a
slice of the application for a different purpose. None of these files is hard to read,
but you have to read many of them, and hold them in your head at once, to get the full
picture. It is easy to read one service end to end and never learn about a database two
hops away that it quietly depends on.

Some repositories include an architecture diagram to help. Many don't, and the ones that
do have to remember to keep it up to date.

## Generating the application model

After installing the **Radius** plugin in the GitHub Copilot app (open **Customize**,
select **Plugins**, and search for `radius`), open the repository and ask Copilot:

> Show me the application graph.

Radius analyzes the repository and infers the application's structure: its workloads,
the resources they depend on, the connections between them, and the infrastructure the
application needs. It writes that understanding to an application definition in
`.radius/app.bicep`, and Radius Canvas opens with the **Application graph**, a rendering
of that file.

The definition is a regular file in your repository. You can read it, adjust anything
Radius got wrong, commit it, and share it with your team. Instead of every developer
(or every AI agent) rebuilding an understanding of the application from scratch, there
is now one model everyone can start from.

{{< image src="images/chat-and-graph.png" alt="The GitHub Copilot app with a summary of the generated application definition in chat and the Application graph in Radius Canvas" width="100%" >}}

## Understanding the architecture

The application graph is an architectural starting point for understanding the
application. It shows the workloads, dependencies, and connections that Radius inferred
from the repository.

A few things to look for the first time you open it:

- **Workloads.** Every service in the application, whether it is a front end, an API, or
  a background worker with no ports and no UI.
- **Dependencies.** The databases, caches, message queues, and other resources each
  workload relies on.
- **Connections.** Which workload talks to which, and which resources they share. This
  is often where the surprises are: a service that bridges two halves of the
  application, or a resource that more services depend on than you expected.

For Online Boutique, the graph has four levels:

- **Entry point.** `frontend-route` exposes the application, and it connects only to
  `frontend`.
- **Front end.** `frontend`, the Go web server, connects to seven of the other nine
  services.
- **Business services.** `checkoutservice` connects to six services: cart, currency,
  email, payment, product catalog, and shipping. `adservice` and
  `recommendationservice` sit beside it and are called by the front end.
- **Data.** `redis` is the only data store in the application, and only `cartservice`
  uses it. The other services keep no state of their own.

Two things are easier to see in the graph than in the files. First, `checkoutservice`
is where a single order touches most of the application, so a problem in any of its six
dependencies shows up at checkout. Second, `emailservice` and `paymentservice` are
only reached through `checkoutservice`, so you will not find them by reading the front
end.

{{< image src="images/application-graph.png" alt="The Modeled Application graph for Online Boutique, showing frontend-route, frontend, ten services, and Redis" width="100%" >}}

## Jumping from the graph to the code

Each node in the graph includes a reference to the source code it was inferred from.
Selecting a node opens the file and lines where that workload or connection is defined.

Each node has two links: **View source code**, which opens the code the node was
inferred from, and **View app definition**, which opens the matching resource in
`.radius/app.bicep`.

For `checkoutservice`, the source code link opens `src/checkoutservice/main.go`. A few
lines below it, the service reads the address of each service it calls:

```go
mustMapEnv(&svc.shippingSvcAddr, "SHIPPING_SERVICE_ADDR")
mustMapEnv(&svc.productCatalogSvcAddr, "PRODUCT_CATALOG_SERVICE_ADDR")
mustMapEnv(&svc.cartSvcAddr, "CART_SERVICE_ADDR")
mustMapEnv(&svc.currencySvcAddr, "CURRENCY_SERVICE_ADDR")
mustMapEnv(&svc.emailSvcAddr, "EMAIL_SERVICE_ADDR")
mustMapEnv(&svc.paymentSvcAddr, "PAYMENT_SERVICE_ADDR")
```

These six environment variables are the six connections the graph shows for
`checkoutservice`. In `.radius/app.bicep`, each one is set from the service it points
to, which is how Radius records the connection.

Everything in the graph comes from the repository, so you could find the same
information by reading the files. The graph collects it in one view and links each part
back to its source.

{{< image src="images/source-reference.png" alt="The paymentservice node selected in the Application graph, showing links to src/paymentservice/index.js and .radius/app.bicep" width="100%" >}}

## A few things to keep in mind

**The graph is only as current as the definition.** Because the picture is drawn from
`.radius/app.bicep`, keeping it accurate means keeping that file up to date. The nice
part is that this is the same file you change when you add a cache or a queue to the
application, so updating the diagram becomes part of making the change rather than a
separate chore.

**The preview has a focused scope.** Today Radius Canvas works with containerized
applications that have a Dockerfile, one application per repository. You can see what
is planned next on the
[Radius Canvas roadmap](https://github.com/orgs/radius-project/projects/27/views/1).

## See it in action

> 🎬 **[DEMO — PLACEHOLDER]** A short (2–3 minute) demo of the day-one flow on the
> sample application: asking Copilot to show the application graph, exploring the
> Application graph, and clicking through from a node to the source code.
> *Embed a YouTube video with the `{{</* youtube VIDEO_ID */>}}` shortcode. To be added.*

If you have a repository you have been meaning to get to know, give it a try and let us
know how the graph looks. We would love to hear what works well and what doesn't.

## Up next

Now that you understand the application, it is time to start changing it. These days,
many of those changes are written with the help of AI, and they can touch a lot of the
application at once. In the next post, we will look at how the application graph helps
you review AI-generated changes and see what they mean for your architecture. Stay
tuned!

## Learn More

- [GitHub Copilot app integration](https://edge.docs.radapp.io/integrations/github-copilot-app/) in the Radius documentation
- [Introducing Radius Canvas](https://techcommunity.microsoft.com/blog/azuredevcommunityblog/introducing-radius-canvas-visualize-review-and-deploy-applications-in-the-github/4549760), the public preview announcement
- [Radius Canvas in the GitHub Copilot app](https://www.youtube.com/watch?v=TU1cEIMMIAA), a video walkthrough
- [Radius Canvas roadmap](https://github.com/orgs/radius-project/projects/27/views/1), where you can vote on what comes next

## Get Involved

We would love for you to join us to help build Radius:

- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
