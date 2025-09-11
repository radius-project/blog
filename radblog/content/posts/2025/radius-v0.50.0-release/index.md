---
date: "2025-08-19T19:16:07+0000"
title: " Announcing Radius v0.50.0"
linkTitle: "Radius v0.50.0"
author: "Radius Team"
type: blog
---

Today, we’re excited to announce the release of Radius v0.50.0! This release introduces several powerful features and enhancements designed to improve developer workflows and streamline platform operations. You can find the full release notes and changelog [here](https://github.com/radius-project/radius/compare/v0.49.0...v0.50.0). 

Let’s dive into the key highlights of this release and explore how they can help you build and manage cloud-native applications more effectively.

## Introducing in-place upgrades

Radius v0.50.0 introduces in-place upgrades, a highly requested feature that simplifies the process of upgrading the Radius control plane. With the new `rad upgrade` command, you can now upgrade your Radius installation while preserving existing environments and applications. This eliminates the need for manual migrations or downtime, making upgrades faster and more reliable.

For example, to upgrade your Radius control plane on Kubernetes, simply run:

```bash
rad upgrade kubernetes
```

In addition, the new `rad rollback` command allows you to revert to the previous version if needed, providing a safety net during upgrades. These commands are designed to integrate seamlessly into your CI/CD pipelines or operational workflows.

For more details on how to perform an upgrade, refer to the [Radius upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

## Enhancements to Radius resource types

Radius resource types have been enhanced to support more flexible and robust configurations. Properties on resource types can now be defined as arrays of objects, enabling you to model complex data structures directly in your resource definitions. Additionally, you can now specify an `enum` type to validate inputs prior to deployment, ensuring that your configurations meet predefined constraints.

Here’s an example of the updated YAML schema for resource type definitions:

```yaml
namespace: Radius.Resources
properties:
  - name: exampleProperty
    type: array
    items:
      type: object
      properties:
        - name: key
          type: string
        - name: value
          type: string
  - name: status
    type: enum
    values:
      - active
      - inactive
```

**Breaking change:** The `name` property in resource type definition YAML files has been renamed to `namespace`. If you’re using the `rad resource-type create -f types.yaml` command, ensure that your YAML files are updated accordingly. For example, replace `name: Radius.Resources` with `namespace: Radius.Resources` on the first line of your file.

These enhancements make it easier to define, validate, and manage custom resource types, reducing errors and improving consistency across deployments.

## Offline installation

Radius v0.50.0 introduces support for offline installations, enabling you to deploy Radius in environments without internet access. This is particularly useful for air-gapped environments or organizations with strict network security policies.

To install Radius offline, you can use the `rad install` command or the Radius Helm chart. When using the Helm chart, you can specify the location of the Radius container images by setting the `global.imageRegistry` and `global.imageTag` parameters. For example:

```bash
helm install radius radius/radius \
  --set global.imageRegistry=<YOUR-PRIVATE-REGISTRY> \
  --set global.imageTag=<YOUR-IMAGE-TAG>
```

Additionally, you can configure private registry authentication by setting the `global.imagePullSecrets` parameter. This ensures that Radius can pull container images securely from your private registry.

Offline installation support makes Radius more accessible to organizations operating in restricted environments, while maintaining the same powerful features available in connected deployments.

## Upgrading to Radius v0.50.0

To upgrade to Radius v0.50.0, start by updating your Radius CLI to the latest version. Once updated, run the following command to upgrade your Kubernetes-based control plane:

```bash
rad upgrade kubernetes
```

Note that only incremental version upgrades are supported. If you’re upgrading from an older version, ensure that you upgrade incrementally through each intermediate version. For detailed instructions, consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).

## Learn more and Get Involved

We would love for you to join us to help build Radius:  
- Try the [Radius Todo List Application](https://github.com/Reshrahim/todoapp-ai)  
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)  
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)  
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos  
