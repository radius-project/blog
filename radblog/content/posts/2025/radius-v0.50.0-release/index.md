---
date: "2025-09-18"
title: "Announcing Radius v0.50.0"
linkTitle: "Radius v0.50.0"
author: "Radius Team"
type: blog
---

Today marks an exciting milestone for the Radius community with the release of **Radius v0.50.0**. This release introduces several significant enhancements designed to improve your experience as a developer or platform engineer. Whether you're upgrading an existing installation or exploring Radius for the first time, this release has something for everyone. You can find the full release notes [here](https://github.com/radius-project/radius/releases/tag/v0.50.0). If you're new to Radius, visit our [getting started guide](https://docs.radapp.io/getting-started/) to learn how to install Radius and create your first app.

## Introducing in-place upgrades

Radius v0.50.0 introduces support for in-place upgrades, making it easier than ever to keep your control plane up to date. With the new `rad upgrade` command, you can upgrade the Radius control plane while preserving your existing Environments and Applications. If something goes wrong, you can roll back to the previous version using the `rad rollback` command. This feature simplifies the upgrade process and reduces downtime. For more details, see the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

Additionally, this release integrates preflight checks into the `rad upgrade kubernetes` command. These checks validate your environment before proceeding with the upgrade, helping you avoid potential issues.

## Enhancements to Radius Resource Types

Radius Resource Types now support arrays of objects as properties, enabling more flexible and complex configurations. You can also define an `enum` type to validate inputs before deployment, ensuring that only valid values are used in your configurations.

However, note that the YAML schema for resource type definitions has changed. The `name` property has been replaced with `namespace`. For example, when creating a new resource type using `rad resource-type create -f types.yaml`, the `types.yaml` file must now include `namespace: Radius.Resources` instead of `name: Radius.Resources` on the first line. Be sure to update your existing resource type definitions to align with this change.

Server-side validation has also been added to ensure that resource data conforms to the type schema, providing an additional layer of reliability during deployments.

## Offline installation

Radius can now be installed in offline Environments, addressing a key requirement for air-gapped deployments. You can Use the `rad install` command or the Helm chart to specify the location of Radius Containers via the `global.imageRegistry` and `global.imageTag` parameters. For private registry authentication, the `global.imagePullSecrets` parameter is also supported. These enhancements make Radius more accessible in restricted Environments.

## Learn more and Get Involved

We would love for you to join us to help build Radius: 
- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/) 
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap) 
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements) 
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord) 
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos 