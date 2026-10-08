---
date: "2026-10-14T07:00:00-07:00"
title: "Architecture Changes and Pull Request Review"
linkTitle: "Architecture Changes and Pull Request Review"
author: "[Nithya Subramanian](https://github.com/nithyatsu)"
type: blog
draft: true
---

In the [first post of this series](https://blog.radapp.io/posts/2026/09/30/day-one-in-an-unknown-repo/),
we opened an unfamiliar repository, generated an application model, and used the
application graph to get to know
[Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo). Now the
application needs to change.

Say the team wants shoppers to see their past orders. You ask Copilot to build the
feature, and a few minutes later you have a pull request with 43 changed files and more
than 7,000 new lines: protocol buffer definitions, generated client code, a new Go
service, changes to two existing services, an HTML template, and Kubernetes manifests,
a Helm chart, and Kustomize overlays.

Every one of those files deserves a review. But before anyone reads them line by line,
the team needs to agree on what the change does to the application as a whole. Which
services are new? Which existing services changed? What do they depend on now? Is that
what we meant to build? That is what the application graph diff in the pull request
helps with.

## About this series

This post is the second in a series about
[Radius Canvas for the GitHub Copilot app](https://docs.radapp.io/integrations/github-copilot-app/).
Each post follows a developer through one stage of working with an application: getting
to know it, changing and reviewing it, and taking it all the way to the cloud. This one
is about **architecture changes and pull request review**: following the application as
its architecture evolves, and using the graph diff to understand and validate a proposed
change before it is merged.

## Changing the architecture

Starting from the repository and application model from the first post, we asked Copilot

> Add an order history page so shoppers can see their past orders.

Copilot added a new `orderhistoryservice` written in Go, backed by a PostgreSQL
database. It updated `checkoutservice` to record each completed order, and `frontend`
to show an **Orders** page that reads from the new service. It also updated the
application model in `.radius/app.bicep` to describe the new service, the database, and
the new connections.

Updating the model is part of making the change. The application graph is drawn from
`.radius/app.bicep`, so as the architecture evolves, the model evolves with it, in the
same pull request.

## The graph diff in the pull request

When Copilot opens the pull request, it adds an application graph diff to the top of
the pull request description. The diff compares the application model on the base
branch and the pull request branch, and draws one graph with every resource marked by
what happened to it:

- **Green** resources were added.
- **Yellow** resources were modified.
- **Red** resources were removed.
- **Grey** resources did not change.

Because the diff is part of the pull request description, everyone reviewing the change
sees it on GitHub, including teammates who are not using the GitHub Copilot app. It is
the first thing they see, before the list of changed files.

> 🖼️ **[IMAGE PLACEHOLDER]** The pull request on GitHub, with the application graph
> diff at the top of the description.

In the GitHub Copilot app, the same diff opens in Radius Canvas, where you can select
nodes and follow them to the code. To open it for any pull request, ask Copilot

> Show me the application graph diff for this pull request.

> 🖼️ **[IMAGE PLACEHOLDER]** The graph diff in Radius Canvas, with
> `orderhistoryservice`, `postgres`, and `postgres-client-credentials` in green and
> `checkoutservice` and `frontend` in yellow.

## Understanding the change

For the order history change, the diff shows:

- **Added:** `orderhistoryservice`, a PostgreSQL database called `postgres`, and
  `postgres-client-credentials`, the secret that holds the database password.
- **Modified:** `checkoutservice` and `frontend`, which now both connect to
  `orderhistoryservice`.
- **Unchanged:** the other ten resources, including `cartservice`, `paymentservice`,
  and `redis`.

Seen this way, a 43-file pull request is one new service with its own database, called
from two existing services. The architecture grew by three resources and four
connections, and the rest of the application stayed as it was.

## Validating the change

With that picture, the review can start with a few questions the whole team can
answer, whether or not they know the code:

- **Is this what we asked for?** One new service that stores orders, a page that shows
  them, and checkout recording each order. Yes.
- **Did anything change that shouldn't have?** The payment, shipping, and cart services
  are untouched, and the change does not use the existing Redis cache.
- **Are the new pieces the right ones?** A new PostgreSQL database is a real decision:
  it is one more thing to run, back up, and secure. This is the moment to agree on it,
  before the code is merged rather than after it is deployed.

One connection is worth a closer look: `checkoutservice` now calls
`orderhistoryservice`. In the first post, we saw that `checkoutservice` is where a single
order touches most of the application, and that a problem in any of its dependencies
shows up at checkout. Now it has a seventh dependency. Before approving, it is worth
asking what happens to checkout if order history is slow or unavailable.

## From the graph to the code

Selecting `checkoutservice` in the graph and choosing **View source code** opens
`src/checkoutservice/main.go`. The new call is in `PlaceOrder`, after the confirmation
email is sent:

```go
if err := cs.recordOrderHistory(ctx, req.UserId, req.Email, orderResult, &total); err != nil {
    log.Warnf("failed to record order %q in order history: %+v", orderResult.OrderId, err)
}
```

If the call fails, checkout logs a warning and the order still goes through, which is
what we want. But the call is made while the shopper waits, and it has no timeout of
its own, so a slow order history service makes checkout slow too. That is a good
comment to leave on the pull request, or a follow-up to ask Copilot for: give the call
a short timeout, or record the order without blocking the response.

The graph did not find that for us. Reading the code did. What the graph did was point
us at the one connection where a small detail matters, out of 43 files.

> 🖼️ **[IMAGE PLACEHOLDER]** `checkoutservice` selected in the graph diff, with the
> link to `src/checkoutservice/main.go`.

## A few things to keep in mind

**The diff compares application models.** Both branches need a committed
`.radius/app.bicep`, and the diff is only as accurate as those files. If a pull request
changes the architecture without updating the model, the graph will not show it. Asking
Copilot to update the model as part of the change, as we did here, keeps them in step.

**The graph shows architecture, not logic.** It tells you which services and resources
changed and how they connect. It does not replace reading the code; it helps you decide
where to read first.

**Not every resource is drawn.** The diff focuses on workloads, data stores, and the
connections between them. Some supporting resources in `.radius/app.bicep`, such as
container image builds, do not appear in the graph.

## See it in action

> 🎬 **[DEMO PLACEHOLDER]** A short demo of the order history pull request: the graph
> diff in the pull request description, the same diff in Radius Canvas, and following
> `checkoutservice` to the code.

If you have a pull request open on an application of your own, try asking for the
graph diff and let us know how it looks. We would love to hear what works well and what
doesn't.

## Up next

The change is reviewed and merged. In the next post, we will take it to the cloud:
planning the rollout, deploying with Radius, and watching each resource's status live
in the graph as the deployment runs. Stay tuned!

## Learn More

- [GitHub Copilot app integration](https://edge.docs.radapp.io/integrations/github-copilot-app/) in the Radius documentation
- [Day One in an Unknown Repo](https://blog.radapp.io/posts/2026/09/30/day-one-in-an-unknown-repo/), the first post in this series
- [Introducing Radius Canvas](https://techcommunity.microsoft.com/blog/azuredevcommunityblog/introducing-radius-canvas-visualize-review-and-deploy-applications-in-the-github/4549760), the public preview announcement
- [Radius Canvas roadmap](https://github.com/orgs/radius-project/projects/27/views/1), where you can vote on what comes next
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
