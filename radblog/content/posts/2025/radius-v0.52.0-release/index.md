---
date: "2025-10-14T16:29:59+0000"
title: "Announcing Radius v0.52.0"
linkTitle: "Radius v0.52.0"
author: "Radius Team"
type: blog
---

Today marks the release of Radius v0.52.0, bringing usability improvements and refinements to enhance your experience with the Radius platform. This release focuses on making key commands more intuitive and user-friendly, while also addressing several important updates under the hood. You can find the full release notes on the [Radius GitHub repository](https://github.com/radius-project/radius/releases/tag/v0.52.0).

If you’re new to Radius, it’s a powerful platform for building and managing cloud-native Applications. To get started, visit the [Radius website](https://radapp.io) for an overview, or check out the [getting started guide](https://docs.radapp.io/getting-started/) to install Radius and create your first app.

## Usability improvements to `rad uninstall kubernetes`

The `rad uninstall kubernetes` command has been enhanced to provide a more transparent and secure experience. When you run this command, it now lists all the Kubernetes resources that will be deleted and prompts you for confirmation before proceeding. This ensures that you have full visibility into the impact of the operation.

Additionally, the `--purge` flag has been improved to perform a thorough cleanup of all Kubernetes resources created by Radius. This makes it easier to ensure that your cluster is left in a clean state after uninstalling Radius. For more details, refer to the [CLI documentation](https://docs.radapp.io/reference/cli/rad_uninstall_kubernetes/).

## Usability improvements to `rad group delete`

The `rad group delete` command now includes a confirmation prompt that lists all resources associated with the group before deletion. This safety measure helps prevent accidental deletions by giving you a clear overview of the impact of the operation. For more information, see the [CLI documentation](https://docs.radapp.io/reference/cli/rad_group_delete/).

## Upgrading to Radius v0.52.0

Upgrading to Radius v0.52.0 is straightforward. First, update your Radius CLI to the latest version. Then, run the `rad upgrade kubernetes` command to upgrade your Kubernetes environment. Note that only incremental version upgrades are supported, so ensure you are upgrading from v0.51.0. For detailed instructions, consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

## Learn More and Get Involved

We would love for you to join us to help build Radius: 
- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/) 
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap) 
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements) 
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord) 
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos 
