---
date: "2024-07-29T00:00:00"
title: "Learn how to fork, build, and contribute to Radius"
linkTitle: "Contributing to Radius"
author: "[Will Smith](https://www.github.com/willdavsmith)"
type: blog
---

Hello future Radius contributor! This blog post will guide you through the process of contributing to the Radius project. Contributions can come in many forms, such as code contributions, documentation updates, bug reports, feature requests, and more. We welcome contributions from developers of all skill levels, so don't hesitate to get involved! For example, here are some non-code contributions you can make to the project:

- **Radius Roadmap**: Help shape the future of Radius by upvoting or commenting on the features in our [public roadmap](https://github.com/orgs/radius-project/projects/8).

- **Documentation**: Help improve the [Radius documentation](https://docs.radapp.io/) by fixing typos, adding examples, or suggesting new content. If you see anything that can be improved, check out the menu on the right side of the page and use the *New docs issue* link to suggest changes or *Edit this page* link to make changes directly.

- **Bug reports**: If you encounter a bug while using Radius, please report it on the [Radius GitHub repository](https://github.com/radius-project/radius/issues/new?assignees=&labels=bug&projects=&template=bug.yaml&title=%3CBUG+TITLE%3E).

- **Feature requests**: If you have an idea for a new feature or improvement, please share it with the community by opening a [feature request](https://github.com/radius-project/radius/issues/new?assignees=&labels=feature&projects=&template=feature.yaml&title=%3CFEATURE+TITLE%3E).

- **Everything else**: Any questions, comments, or feedback? Feel free to reach out to us on the [Radius Discord](https://aka.ms/radius/discord)!

We also welcome contributions to our codebase. Since Radius encompasses multiple components, we'll cover how to contribute to the Radius control plane, CLI, dashboard, and recipes. If you are interested in one of these areas specifically, feel free to jump to the corresponding section!

- [Contributing to the Radius CLI](#contributing-to-the-radius-cli)

- [Contributing to the Radius Dashboard](#contributing-to-the-radius-dashboard)

- [Contributing to the Radius control plane](#contributing-to-the-radius-control-plane)

- [Contributing to Radius Recipes](#contributing-to-radius-recipes)

## Getting started

Here are a few tips and things you'll need to get started with contributing to Radius.

- Radius has adopted the [Contributor Covenant](https://www.contributor-covenant.org/) as its code of conduct. For more information see [CODE_OF_CONDUCT.md](https://github.com/radius-project/community/blob/main/CODE-OF-CONDUCT.md) in the main Radius repository.

- Radius is composed of multiple components and repositories. You can find the main Radius repository [here](https://github.com/radius-project/radius) and the other repositories in the [radius-project GitHub organization](https://github.com/radius-project). It may help to consult our [contributing guide](https://github.com/radius-project/radius/tree/main/docs/contributing/contributing-code) to understand the different components of the project and how to contribute to each.

- Radius uses [GitHub forks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) for contributions. This means that you will need to fork the Radius repository to your GitHub account before making any changes. Please see the [documentation](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-first-commit/first-commit-06-creating-a-forked-repo/index.md) for instructions and best practices for using forks with Radius.

- If you want to contribute but don't know where to start, feel free to reach out to the community on the [Radius Discord](https://aka.ms/radius/discord) or look for issues labeled as [good first issues](https://github.com/radius-project/radius/labels/good%20first%20issue). We are happy to help and we appreciate your interest in contributing to the project, so no question is too small!

## Contributing to the Radius CLI
Contributing to the Radius CLI is a great way to get started with the project, and we recommend it for anyone starting out with Radius.

### Prerequisites
- General knowledge of the [Go programming language](https://golang.org/)
- A fork of the [radius-project/radius](https://github.com/radius-project/radius) repository (please see the [documentation](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-first-commit/first-commit-06-creating-a-forked-repo/index.md) for instructions and best practices for using forks with Radius)
- A local clone of your forked repository

### Getting started
We have authored a guide to help you get started with contributing to the Radius CLI. You can find it [here](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-first-commit/first-commit-00-prerequisites.md). This guide will walk you through the process of setting up your development environment, building the CLI, running tests, and submitting a pull request to the Radius repo.

You can also get started using [GitHub Codespaces](https://github.com/features/codespaces) to develop and test the Radius CLI without setting up a local development environment.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=340522752&skip_quickstart=true&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Fcontributor%2Fdevcontainer.json&geo=UsWest)

[Here](https://github.com/radius-project/radius/labels/good%20first%20issue) is a list of good first issues to get you started. Look for the issues that specify commands (`rad <command>`) or the CLI in general.

## Contributing to the Radius Dashboard
If you're interested in front-end development, contributing to the Radius Dashboard is a great way to get involved with the project. The Radius Dashboard is built on [Backstage](https://backstage.io/), an open-source platform for building developer portals. 

### Prerequisites
- General knowledge of front-end development with React
- A fork of the [radius-project/dashboard](https://github.com/radius-project/dashboard) repository (please see the [documentation](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-first-commit/first-commit-06-creating-a-forked-repo/index.md) for instructions and best practices for using forks with Radius)
- A local clone of your forked repository

### Getting started

The Radius Dashboard is a new part of Radius, and as a result, there is lots to do! We have authored a guide to help you get started with contributing to the Radius Dashboard. You can find it [here](https://github.com/radius-project/dashboard/tree/main/docs/contributing/contributing-code/contributing-code-building).

[Here](https://github.com/radius-project/dashboard/labels/good%20first%20issue) is a list of good first issues to get you started.

## Contributing to Radius Recipes

If you or your organization have authored custom [Radius Recipes](https://docs.radapp.io/guides/recipes/overview/), we would love to see what you have built! So far, we have authored some recipes for our [supported resources](https://docs.radapp.io/guides/recipes/supported-resources/), but we are always looking for more contributions and examples for our community.

### Prerequisites
- A fork of the [radius-project/dashboard](https://github.com/radius-project/dashboard) repository (please see the [documentation](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-first-commit/first-commit-06-creating-a-forked-repo/index.md) for instructions and best practices for using forks with Radius)
- A local clone of your forked repository

### Getting started

We have authored a guide to help you get started with contributing to Radius Recipes. You can find it [here](https://github.com/radius-project/recipes/blob/main/docs/contributing/contributing-recipes.md). In the [radius-project/recipes](https://github.com/radius-project/recipes) repo, there are many examples of recipes that you can use as a starting point for your own contributions. For example, a custom [Azure Service Bus](https://github.com/radius-project/recipes/blob/main/azure/extender-servicebus.bicep) recipe or an [AWS Redis](https://github.com/radius-project/recipes/blob/main/aws/rediscaches.bicep) recipe that leverages AWS MemoryDB.

## Contributing to the Radius control plane

Most of the Radius functionality exists within the control plane, which is a set of services that exist as part of your Radius installation. 

### Prerequisites
- General knowledge of the [Go programming language](https://golang.org/)
- Prerequisites mentioned [here](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-prerequisites/README.md#basic-prerequisites), including Go, Make, Docker, and so on
- A [supported Kubernetes cluster](https://docs.radapp.io/guides/operations/kubernetes/overview)
- A fork of the [radius-project/radius](https://github.com/radius-project/dashboard) repository (please see the [documentation](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-first-commit/first-commit-06-creating-a-forked-repo/index.md) for instructions and best practices for using forks with Radius)
- A local clone of your forked repository

### Getting started

To get started with contributing to the Radius control plane, the general flow is as follows:
1. Install Radius onto your Kubernetes cluster
1. Make changes to the control plane code
1. Build the control plane images (applications-rp, ucp)
1. Push the images to a registry that you own
1. Update the installed Radius control plane to use the new images

We have written a more detailed guide to help you get started with contributing to the Radius control plane. You can find it [here](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-control-plane/generating-and-installing-custom-build.md).

### Advanced Inner-Loop Development

If you want to run the control plane locally, we have a guide for that as well. You can find it [here](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-control-plane/running-controlplane-locally.md). This is useful for debugging and testing changes to the control plane, but comes with some additional setup requirements.

## What's next?
Thanks for reading this guide on how to contribute to Radius! We hope you found it helpful and that you are excited to get started. If you have any questions or need help, please don't hesitate to reach out to the community on the [Radius Discord](https://aka.ms/radius/discord). We are here to help and we look forward to your contributions!
