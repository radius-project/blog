---
date: "2025-08-19T19:16:07+0000"
title: "Announcing Radius v0.50.0"
linkTitle: "Radius v0.50.0"
author: "Radius Team"
type: blog
---

Today marks the release of **Radius v0.50.0**, bringing exciting new features and enhancements for developers and platform engineers. This update introduces in-place upgrades, expanded resource type capabilities, and offline installation support, making Radius even more powerful and flexible for managing cloud-native Applications. You can find the full release notes [here](https://github.com/radius-project/radius/releases/tag/v0.50.0). If you're new to Radius, visit [radapp.io](https://radapp.io) to learn more, and check out the [getting started guide](https://docs.radapp.io/getting-started/) to begin building your first application.

## Introducing in-place upgrades

Radius now supports in-place upgrades with the new `rad upgrade` command. This feature allows you to upgrade the Radius control plane while preserving your existing Environments and Applications. Additionally, the `rad rollback` command provides a safety net, enabling you to revert to a previous version if needed. These commands streamline the upgrade process, reducing downtime and ensuring a smoother experience. For detailed instructions, refer to the [Radius upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

As part of this feature, preflight checks have been integrated into the `rad upgrade kubernetes` command. These checks validate your environment before proceeding with the upgrade, helping to identify potential issues early.

## Enhancements to Radius Resource Types

Radius Resource Types have been enhanced to support arrays of objects as properties. This improvement allows for more complex and flexible configurations. Additionally, you can now define an `enum` type to validate inputs before deployment, ensuring data integrity and reducing runtime errors.

It’s important to note a breaking change in the YAML schema for resource type definitions. The `name` property has been replaced with `namespace`. For example, when creating a new resource type using the `rad resource-type create -f types.yaml` command, the `types.yaml` file must now include `namespace: Radius.Resources` instead of `name: Radius.Resources` on the first line. Be sure to update your existing resource type definitions accordingly.

Server-side validation has also been added to ensure that resource data conforms to the defined type schema, providing an additional layer of reliability during deployments.

## Offline installation

Radius can now be installed in offline Environments, making it easier to deploy in air-gapped or restricted network scenarios. You can use the `rad install` command or the Helm chart to specify the location of the Radius containers. This is achieved by setting the `global.imageRegistry` and `global.imageTag` parameters. For private registry authentication, the `global.imagePullSecrets` parameter is also supported. These enhancements provide greater flexibility for organizations with strict network policies.

## Upgrading to Radius v0.50.0

To upgrade to this release, first update your Radius CLI. Then, run the `rad upgrade kubernetes` command to upgrade your control plane. Note that only incremental version upgrades are supported, so ensure you are upgrading from v0.49.0. For detailed upgrade instructions, consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

## Learn More and Get Involved

We would love for you to join us to help build Radius: 
- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/) 
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap) 
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements) 
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord) 
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos 
