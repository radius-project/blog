---
date: "2025-08-19T19:16:07+0000"
title: "Announcing Radius v0.50.0"
linkTitle: "Radius v0.50.0"
author: "Radius Team"
type: blog
---

Today marks an exciting milestone for developers and platform engineers as Radius v0.50.0 is now available! This release introduces several key features and enhancements designed to improve your experience with Radius, a cloud-native application platform. Whether you're new to Radius or a seasoned user, this update brings powerful new capabilities to streamline your workflows. For a complete list of changes, check out the [release notes](https://github.com/radius-project/radius/releases/tag/v0.50.0). If you're just getting started, visit the [getting started guide](https://docs.radapp.io/getting-started/) to learn how to install Radius and create your first app.

## Introducing in-place upgrades

Radius v0.50.0 introduces in-place upgrades, enabling you to upgrade the Radius control plane without disrupting your existing Environments and Applications. With the new `rad upgrade` command, you can seamlessly transition to the latest version while preserving your configurations. Additionally, the new `rad rollback` command provides a safety net, allowing you to revert to the previous version if needed. For detailed instructions, refer to the [Radius upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

This feature also includes preflight checks to validate your environment before proceeding with an upgrade, ensuring a smoother and more reliable process. To upgrade, simply update your Radius CLI and run `rad upgrade kubernetes`. Note that only incremental version upgrades are supported, so ensure you're upgrading from v0.49.0.

## Enhancements to Radius Resource Types

Radius Resource Types now support arrays of objects as properties, providing greater flexibility in defining your resources. Additionally, you can now specify an `enum` type to validate inputs before deployment, reducing errors and improving consistency.

As part of these enhancements, the YAML schema for resource type definitions has been updated. The `name` property has been replaced with `namespace`. For example, when creating a new resource type using the `rad resource-type create -f types.yaml` command, the first line of your `types.yaml` file should now include `namespace: Radius.Resources` instead of `name: Radius.Resources`. Be sure to update your existing resource type definitions to align with this change.

Server-side validation has also been added to ensure resource data conforms to the defined type schema, further enhancing reliability during deployments.

## Offline installation

Radius can now be installed in offline Environments, making it more accessible for air-gapped or restricted networks. You can use the `rad install` command or the Helm chart to specify the location of Radius container images. To configure this, set the `global.imageRegistry` and `global.imageTag` parameters in your Helm values file. For private registry authentication, you can also use the new `global.imagePullSecrets` parameter.

This feature ensures that Radius can be deployed in Environments with strict network constraints, expanding its usability across diverse infrastructure setups.

## Learn More and Get Involved

We would love for you to join us to help build Radius: 
- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/) 
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap) 
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements) 
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord) 
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos 
