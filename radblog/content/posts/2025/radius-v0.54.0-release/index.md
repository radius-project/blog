---
date: "2025-12-09T22:58:34+0000"
title: "Announcing Radius v0.54.0"
linkTitle: "Radius v0.54.0"
author: "Radius Team"
type: blog
---

Today, we’re excited to announce the release of Radius v0.54.0! This update brings several improvements and fixes to enhance your experience with Radius. Whether you’re a developer or platform engineer, this release focuses on making your workflows smoother and more reliable. You can find the full release notes on our [GitHub releases page](https://github.com/radius-project/radius/releases/tag/v0.54.0). 

If you’re new to Radius, it’s a cloud-native application platform designed to simplify the deployment and management of Applications. To get started, visit our [getting started guide](https://docs.radapp.io/getting-started/) and learn how to install Radius and create your first app.

## Fixed `rad workspace show` errors when no current workspace exists 
The `rad workspace show` command has been updated to improve usability. Previously, if no workspace was set, the command would return an error, which could be confusing. With this release, the command now logs an informational message to guide you when no current workspace exists. This change ensures a more user-friendly experience when managing workspaces. For more details, refer to the [CLI documentation](https://docs.radapp.io/reference/cli/rad_workspace_show/). 

## Fixed `rad credential show azure` command 
A critical fix has been made to the `rad credential show azure` command. Previously, this command would fail with a nil pointer dereference error when attempting to display Azure Service Principal credentials. This issue has been resolved, and the command now correctly displays the Azure credentials you’ve configured for Radius. 

## Upgrading to Radius v0.54.0 
Upgrading to the latest version is straightforward. First, update your Radius CLI, then run the `rad upgrade kubernetes` command. Note that only incremental version upgrades are supported, so ensure you’re upgrading from the previous version. For detailed instructions, consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/). 

## New contributors 
We’re thrilled to welcome new contributors to the Radius community! A special thanks to **@filipevrevez** for their first contribution in [PR #10749](https://github.com/radius-project/radius/pull/10749). Your contributions help make Radius better for everyone. 

## Learn More and Get Involved 
We would love for you to join us to help build Radius: 
- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/) 
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap) 
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements) 
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord) 
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos 
