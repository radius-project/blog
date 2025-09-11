---
date: "2025-08-19T19:16:07+0000"
title: " Announcing Radius v0.50.0"
linkTitle: "Radius v0.50.0"
author: "Radius Team"
type: blog
---

Today, we’re excited to announce the release of Radius v0.50.0! This release introduces several powerful new features and enhancements designed to streamline your workflows and improve your experience as a developer or platform engineer. You can find the full release notes [here](https://github.com/radius-project/radius/releases/tag/v0.50.0). Below, we’ll dive into the highlights of this release, including in-place upgrades, enhanced resource types, and offline installation support.

## Introducing in-place upgrades

Managing upgrades in distributed systems can often be a complex and error-prone process. With Radius v0.50.0, we’re introducing in-place upgrades to simplify this critical task. You can now upgrade your Radius control plane directly using the new `rad upgrade` command. This command updates the control plane while preserving your existing environments and applications, ensuring minimal disruption to your workflows.

For example, to upgrade Radius on Kubernetes, you can use the following command:

```bash
rad upgrade kubernetes
```

Additionally, if you encounter issues during an upgrade, you can now roll back to the previous version using the new `rad rollback` command:

```bash
rad rollback kubernetes
```

This feature also includes integrated preflight checks to validate your environment before proceeding with the upgrade. These checks help ensure that your system is ready for the upgrade, reducing the risk of errors. For more details, refer to the [Radius upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

## Enhancements to Radius resource types

Radius v0.50.0 introduces significant improvements to resource type definitions, making them more flexible and robust. Properties on Radius resource types can now be defined as arrays of objects, enabling more complex configurations. Additionally, you can now specify an `enum` type to validate inputs before deployment, ensuring that only valid values are accepted.

Here’s an example of how you might use the new `enum` type in a resource type definition:

```yaml
namespace: Radius.Resources
properties:
  - name: size
    type: string
    enum:
      - small
      - medium
      - large
```

This schema ensures that the `size` property can only accept one of the predefined values: `small`, `medium`, or `large`.

It’s important to note that the YAML schema for resource type definitions has changed in this release. The `name` property has been renamed to `namespace`. For example, if you previously used the following in your `types.yaml` file:

```yaml
name: Radius.Resources
```

You will now need to update it to:

```yaml
namespace: Radius.Resources
```

This change applies when creating new resource types using the `rad resource-type create` command. Be sure to update your existing resource type definitions to align with this new schema.

## Offline installation

Radius v0.50.0 introduces support for offline installations, enabling you to deploy Radius in environments without internet access. This feature is particularly useful for air-gapped environments or scenarios where external network access is restricted.

To install Radius offline, you can use the `rad install` command or deploy it via the Helm chart. When using the Helm chart, you can specify the location of the Radius container images by setting the `global.imageRegistry` and `global.imageTag` parameters. For example:

```bash
helm install radius radius-chart \
  --set global.imageRegistry=<YOUR-PRIVATE-REGISTRY> \
  --set global.imageTag=<YOUR-IMAGE-TAG>
```

Additionally, if your private registry requires authentication, you can configure it using the `global.imagePullSecrets` parameter.

This enhancement ensures that Radius can be deployed and managed in a wider range of environments, providing greater flexibility for platform engineers and operators.

## Upgrading to Radius v0.50.0

To upgrade to Radius v0.50.0, start by updating your Radius CLI to the latest version. Once updated, you can execute the `rad upgrade kubernetes` command to perform the upgrade. Note that only incremental version upgrades are supported, so ensure that you are upgrading from v0.49.0. For detailed instructions, consult the [Radius upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

---

Radius v0.50.0 is a significant step forward in simplifying application and platform management for developers and platform engineers. With in-place upgrades, enhanced resource type capabilities, and offline installation support, this release continues to deliver on Radius’s mission to make cloud-native application development and operations more accessible and efficient.

## Learn more and Get Involved

We would love for you to join us to help build Radius:

- Try the [Radius Todo List Application](https://github.com/Reshrahim/todoapp-ai)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
