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

> ✏️ **[APP PLACEHOLDER]** Introduce the sample application here: what it does, a link to
> the repository, how many services it has, and the languages it uses. One or two
> sentences on why it is a good example of a multi-tier application.

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

> Explain this application to me.

Radius analyzes the repository and infers the application's structure: its workloads,
the resources they depend on, the connections between them, and the infrastructure the
application needs. It writes that understanding to an application definition in
`.radius/app.bicep`, and Radius Canvas opens with the **Application graph**, a rendering
of that file.

The definition is a regular file in your repository. You can read it, adjust anything
Radius got wrong, commit it, and share it with your team. Instead of every developer
(or every AI agent) rebuilding an understanding of the application from scratch, there
is now one model everyone can start from.

> 🖼️ **[VISUAL 1 — PLACEHOLDER]** The Radius plugin responding to "Explain this
> application to me" in the Copilot app, alongside the generated `.radius/app.bicep`.
> *Screenshot. To be added.*

## Understanding the architecture

This is where day one gets a lot easier. The application graph gives you an
architectural starting point: the whole application on one screen, inferred directly
from the repository.

A few things to look for the first time you open it:

- **Workloads.** Every service in the application, whether it is a front end, an API, or
  a background worker with no ports and no UI.
- **Dependencies.** The databases, caches, message queues, and other resources each
  workload relies on.
- **Connections.** Which workload talks to which, and which resources they share. This
  is often where the surprises are: a service that bridges two halves of the
  application, or a resource that more services depend on than you expected.

> ✏️ **[APP PLACEHOLDER]** Walk through the graph for the sample application. Call out
> the tiers (front end, APIs, background processing, data), and one or two insights
> that are hard to see from the files alone but obvious in the graph, such as a
> critical service in the middle of the flow or a shared dependency.

> 🖼️ **[VISUAL 2 — PLACEHOLDER] — main image of the post.** The Application graph of
> the sample application in Radius Canvas, showing its workloads, dependencies, and the
> connections between them. *Screenshot. To be added.*

## Jumping from the graph to the code

Each node in the graph includes a reference back to the source code it came from, so
the graph also works as a map of the repository. When a connection catches your eye,
select the node and you land on the lines of code where that connection is made.

> ✏️ **[APP PLACEHOLDER]** Pick one interesting node, show where selecting it takes you,
> and include a short code snippet of the connection being made.

None of this is secret. Everything in the graph can be found by reading the repository.
The graph just gives you a place to start and a quick way to get to the lines that
matter, so you can spend your first day learning how the application works instead of
working out what it is made of.

> 🖼️ **[VISUAL 3 — PLACEHOLDER]** A node selected, with its source code reference
> visible, then the click-through landing on the connection in source.
> *Short GIF or clip preferred over a screenshot. To be added.*

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
> sample application: asking Copilot to explain the application, exploring the
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
