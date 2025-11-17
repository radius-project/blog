---
date: "2025-11-12T04:12:56+0000"
title: "Announcing Radius v0.53.0"
linkTitle: "Radius v0.53.0"
author: "Radius Team"
type: blog
---

Radius v0.53.0 is here! This latest release brings exciting updates to improve your experience with Radius, whether you're deploying cloud-native Applications or managing internal developer platforms. You can explore the full release notes at [Radius v0.53.0 Release Notes](https://github.com/radius-project/radius/releases/tag/v0.53.0). If you're new to Radius, visit [radapp.io](https://radapp.io) to learn more about the platform and check out the [getting started guide](https://docs.radapp.io/getting-started/) to install Radius and create your first app.

## Contour ingress controller installation re-enabled

Radius v0.53.0 reintroduces support for installing the Contour ingress controller during `rad install kubernetes` or `rad init`. This enhancement is made possible by the availability of the [Contour Helm Charts](https://github.com/projectcontour/helm-charts/releases/tag/contour-0.1.0). With this update, you no longer need to manually install and configure a Contour ingress controller before deploying Gateway resources. This streamlines the setup process and ensures a smoother deployment experience for your Applications.

## Improved environment deletion experience

The `rad env delete` command has been enhanced to make Environment cleanup safer and more transparent. This update introduces differentiated prompts for deleting empty versus populated Environments, helping you understand the scope of deletion before proceeding. Additionally, progress messages have been added to provide clearer feedback during deletion operations. For more details, refer to the [CLI documentation](https://docs.radapp.io/reference/cli/rad_environment_delete/).

## New contributors

Radius v0.53.0 welcomes new contributors to the project. Special thanks to:

- **@koksay** for their first contribution in [PR #10614](https://github.com/radius-project/radius/pull/10614)
- **@DariuszPorowski** for their first contribution in [PR #10771](https://github.com/radius-project/radius/pull/10771)

Your contributions help make Radius better for everyone!

## Upgrading to Radius v0.53.0

To upgrade to Radius v0.53.0, update your Radius CLI and run `rad upgrade kubernetes`. Note that only incremental version upgrades are supported. For detailed instructions, consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

## Learn More and Get Involved

We would love for you to join us to help build Radius: 
- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/) 
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap) 
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements) 
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord) 
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos 
