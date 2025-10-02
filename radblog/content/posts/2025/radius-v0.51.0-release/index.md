---
date: "2025-10-02"
title: "Announcing Radius v0.51.0"
linkTitle: "Radius v0.51.0"
author: "Radius Team"
type: blog
---

Today, we’re excited to announce the release of Radius v0.51.0! This update introduces several enhancements to improve usability, streamline workflows, and address key user concerns. Whether you’re a developer or platform engineer, this release brings meaningful updates to help you manage your cloud-native Applications more effectively. You can find the full release notes [here](https://github.com/radius-project/radius/releases/tag/v0.51.0). 

If you’re new to Radius, visit [radapp.io](https://radapp.io) to learn more about the platform and its capabilities. To get started, check out the [getting started guide](https://docs.radapp.io/getting-started/) for step-by-step instructions on installing Radius and deploying your first application.

## Purge behavior updated for uninstall command 

Radius v0.51.0 introduces an update to the `--purge` flag for the `rad uninstall kubernetes` command. When this flag is specified, all Kubernetes resources created by Radius—including resources generated during application deployments—will now be deleted. This enhancement ensures a more thorough cleanup process when uninstalling Radius from your Kubernetes environment. For detailed usage instructions, refer to the [CLI documentation](https://docs.radapp.io/reference/cli/rad_uninstall_kubernetes/). 

## Progress status feedback added to application deletion command 

The `rad app delete` command has been improved to provide real-time progress status and a confirmation summary during application deletion. This update addresses a common usability issue where longer deletion operations could appear unresponsive. With this enhancement, you’ll now have clear visibility into the deletion process, ensuring a smoother experience. Learn more about this feature in the [CLI documentation](https://docs.radapp.io/reference/cli/rad_application_delete/). 

## ACI deployments now use dynamic resource group location 

Radius has updated its Azure Container Instances (ACI) deployment process to dynamically retrieve and use the resource group’s location. Previously, deployments defaulted to the hardcoded WestUS3 region due to early support for ACI NGroups. This improvement ensures that Radius adapts to your resource group’s location, simplifying ACI Environment creation and resource deployment. For more information, see the [how-to guide](https://docs.radapp.io/guides/author-apps/azure/azure-container-instances/). 

## Contour ingress controller installation disabled 

Radius v0.51.0 disables the automatic installation of the Contour ingress controller during `rad install kubernetes` and `rad init`. This change is due to [Bitnami’s deprecation](https://community.broadcom.com/tanzu/blogs/beltran-rueda-borrego/2025/08/18/how-to-prepare-for-the-bitnami-changes-coming-soon) of their public container registry, which impacts the availability of Contour images. 

If your Applications rely on Radius Gateway resources for ingress functionality, you’ll need to manually install and configure a Contour ingress controller before deploying Gateway resources. For installation guidance, consult the [Contour documentation](https://projectcontour.io/getting-started/#install-contour-and-envoy). Additionally, you may find helpful insights in the [Contour community discussion](https://github.com/projectcontour/community/issues/48). 

This change is temporary while Radius evaluates alternative ingress controller options and repository sources. 

## Upgrading to Radius v0.51.0 

To upgrade to Radius v0.51.0, first update your Radius CLI, then run `rad upgrade kubernetes`. Note that only incremental version upgrades are supported. For detailed upgrade instructions, consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/). 

## Learn More and Get Involved 

We would love for you to join us to help build Radius: 
- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/) 
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap) 
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements) 
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord) 
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos 
