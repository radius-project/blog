---
date: "2026-09-21T07:00:00-07:00"
title: "Day One in an Unknown Repo"
linkTitle: "Day One in an Unknown Repo"
author: "[Nithya Subramanian](https://github.com/nithyatsu)"
type: blog
draft: true
---

Joining a new team usually starts the same way: clone the repository, then spend the
first morning working out what the application is actually made of. Developers piece it
together from Dockerfiles and configuration. Operators are often handed the same
repository and asked what infrastructure it needs before anyone can tell them.

Consider a concrete example: the
[Docker voting app](https://github.com/dockersamples/example-voting-app), a small
distributed application with five top-level folders — `vote`, `result`, `worker`,
`seed-data`, and `healthchecks` — written in three different languages. The listing
tells you those folders exist. It does not tell you how they fit together.

The answer is spread across five Dockerfiles, `docker-compose.yml`, `docker-stack.yml`,
and the manifests in `k8s-specifications/`, each a partial view written for a different
target. The cost is not the reading time. It is that you can read all of `vote/` end to
end and still not know that Postgres is part of this application at all.

This post walks through modeling that repository with Radius and reading the result as an
application graph.

## Model the repository with the Radius plugin

Install the **Radius plugin** for the GitHub Copilot app, open the repository, and ask:

> Explain this application to me.

Radius Canvas opens with the **Application graph** in the Modeled view: the application's
workloads, the resources they depend on, and the connections between them.

Behind the scenes, Radius has analyzed the repository and written an application
definition to `.radius/app.bicep` describing those workloads, dependencies, connections,
and the infrastructure the application needs. The graph is a rendering of that file.

The definition sits in your repository like any other source file. You can read it,
correct it, commit it, and review it in a pull request. It is also the same model Radius
uses later to plan and deploy the application.

> 🖼️ **[VISUAL 1 — PLACEHOLDER]** The Radius plugin responding to "Explain this
> application to me" in the Copilot app, alongside the generated `.radius/app.bicep`
> for the voting app. *Screenshot. To be added.*

## What the Application graph shows

The voting app has three services and two backing resources:

- `vote`, the Python front end, writes to Redis.
- `result`, the Node.js dashboard, reads from Postgres.
- `worker`, the .NET service, connects to both.

The graph makes it easy to see that `worker` is a critical dependency. It is the only
path between Redis and Postgres, so votes collected by `vote` only reach the dashboard
if `worker` is running. If `worker` stops, the site stays up and the results page keeps
serving the last numbers it read, while votes accumulate in Redis.

> 🖼️ **[VISUAL 2 — PLACEHOLDER] — main image of the post.** The Modeled Application
> graph of the voting app in Radius Canvas, showing the three services, Redis, Postgres,
> and the connections between them. *Screenshot. To be added.*

## Following a node back to the source

Every node in the graph carries a source code reference, which makes the graph an index
into the repository rather than a separate diagram alongside it.

Click the `worker` node and you land in `worker/Program.cs`, on the two lines that open
its connections:

```csharp
var pgsql = OpenDbConnection("Server=db;Username=postgres;...");
var redisConn = OpenRedisConnection("redis");
```

Both connections are opened in the first few lines of `Main`. Further down, `worker`
pops each vote off a Redis list and writes it to Postgres, which is the dependency the
graph showed.

All of this is discoverable by reading the repository. The graph shortens the path to
it.

> 🖼️ **[VISUAL 3 — PLACEHOLDER]** The `worker` node selected, with its source code
> reference visible, then the click-through landing on the connection in source.
> *Short GIF or clip preferred over a screenshot. To be added.*

## The Modeled graph is what is declared

The Modeled graph shows the application as declared — not what actually runs in a given
environment. Radius covers that with the Planned and Deployed graphs, which are a story
for another post.

## The diagram comes from the definition

The picture is drawn from `.radius/app.bicep` — the same definition that deploys the
application. Add a cache and you declare it there to get one, and the graph picks it up
on the next render. Keeping the picture current is part of shipping the change rather
than a separate task, so the repository carries an architecture diagram that keeps pace with
the application.

## Reviewing changes to the application

The same model works on a pull request. Radius can compare the application graph across
branches, so a change that adds a queue or a second database shows up as a change in
shape rather than as more lines in a diff.

## Try it on a repository

Install the [Radius plugin for the GitHub Copilot app](https://edge.docs.radapp.io/integrations/github-copilot-app/), open a repository, and ask:

> Explain this application to me.

## Learn More

- [GitHub Copilot app integration](https://edge.docs.radapp.io/integrations/github-copilot-app/) — set up the Radius plugin
- [Introducing Radius Canvas](https://techcommunity.microsoft.com/blog/azuredevcommunityblog/introducing-radius-canvas-visualize-review-and-deploy-applications-in-the-github/4549760) — the announcement
- [Radius Canvas walkthrough](https://www.youtube.com/watch?v=TU1cEIMMIAA) — video
- [Radius Canvas roadmap](https://github.com/orgs/radius-project/projects/27/views/1) — vote on what comes next
- Join the [Radius Discord](https://aka.ms/radius/discord), the
  [Radius Google Group](https://groups.google.com/g/radapp_io), or the
  [Radius YouTube channel](https://www.youtube.com/@radapp_io)
