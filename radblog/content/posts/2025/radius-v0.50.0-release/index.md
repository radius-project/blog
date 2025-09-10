---
date: "2025-08-19T19:16:07+0000"
title: "Radius v0.50.0 Released"
linkTitle: "Radius v0.50.0"
author: "Radius Team"
type: blog
---

# Announcing Radius v0.50.0  

We’re pleased to announce the release of Radius v0.50.0, now available for developers and platform engineers. This release introduces several new features, breaking changes, and enhancements to help you build, deploy, and manage cloud-native applications more effectively. Below, we’ll dive into the key highlights, including in-place upgrades, enhancements to Radius resource types, offline installation support, and critical updates to ensure smooth adoption.  

## In-Place Upgrades with `rad upgrade`  

Radius v0.50.0 introduces in-place upgrades, enabling you to seamlessly upgrade your Radius control plane without disrupting existing environments and applications. The new `rad upgrade` command simplifies the upgrade process, making it faster and less error-prone. Additionally, a `rad rollback` command is included, allowing you to revert to a previous version if necessary.  

### Example: Performing an Upgrade  

To upgrade your Radius installation, first ensure your CLI is updated to the latest version. Then, execute the following command:  

```bash  
rad upgrade kubernetes  
```  

The `rad upgrade` command performs preflight checks to validate that your environment meets the requirements for an upgrade. This ensures a smoother upgrade process and reduces the likelihood of encountering issues. For detailed upgrade instructions, consult the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).  

If you encounter issues or need to revert, you can use the `rad rollback` command:  

```bash  
rad rollback kubernetes  
```  

This feature improves operational efficiency for platform engineers tasked with maintaining Radius environments in production.  

---

## Enhancements to Radius Resource Types  

Radius v0.50.0 introduces improved flexibility for defining custom resource types. Key updates include:  

- **Support for Arrays of Objects**: Properties on Radius resource types can now be arrays of objects, enabling more complex and expressive resource definitions.  
- **Input Validation with `enum`**: You can now specify an `enum` type to validate inputs before deployment, ensuring data consistency and reducing runtime errors.  

### Breaking Change: `name` Property Renamed to `namespace`  

The YAML schema for resource type definitions has been updated. The `name` property is now replaced with `namespace`. For example, when creating a resource type using a YAML file, the first line must now use `namespace` instead of `name`:  

#### Old Schema:  

```yaml  
name: Radius.Resources  
properties:  
  myProperty:  
    type: string  
```  

#### New Schema:  

```yaml  
namespace: Radius.Resources  
properties:  
  myProperty:  
    type: string  
```  

If you attempt to use the old schema with `rad resource-type create -f types.yaml`, the command will fail. Update your YAML files to comply with this change to avoid deployment issues.  

---

## Offline Installation Support  

Radius v0.50.0 brings offline installation capabilities, making it possible to deploy Radius in air-gapped or restricted environments.  

### Installation Options  

1. **Using the `rad install` Command**:  
   Configure the `rad install` command to use pre-downloaded container images and dependencies stored in an internal registry.  

2. **Using the Helm Chart**:  
   Configure the Helm chart by specifying the image registry and tag for Radius containers:  

   ```yaml  
   global:  
     imageRegistry: your.private.registry  
     imageTag: v0.50.0  
   ```  

   For private registry authentication, you can also provide pull secrets using the `global.imagePullSecrets` parameter.  

These updates make Radius more accessible to organizations with strict security policies or limited internet connectivity.  

---

## Breaking Changes  

As noted earlier, the `name` property in the YAML schema for resource type definitions has been renamed to `namespace`. This is a breaking change, and you must update existing YAML files for compatibility.  

Additionally, only incremental version upgrades are supported. If you’re upgrading from an older version of Radius, ensure you’ve upgraded to intermediate versions before proceeding to v0.50.0. Refer to the [upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/) for more details.  

---

## Full Changelog  

This release includes a range of additional enhancements and bug fixes. Highlights include:  

- **Enhanced Preflight Checks**: The `rad upgrade kubernetes` command now includes preflight validations to detect potential issues before the upgrade begins ([#9745](https://github.com/radius-project/radius/pull/9745)).  
- **Server-Side Input Validation**: Resource data is now validated against its type schema before deployment to ensure correctness ([#10008](https://github.com/radius-project/radius/pull/10008)).  
- **Improved Resource Type Support**: Arrays and `enum` types are now supported in custom resource definitions ([#10140](https://github.com/radius-project/radius/pull/10140)).  

For a complete list of changes, refer to the [full changelog](https://github.com/radius-project/radius/compare/v0.49.0...v0.50.0).  

---

## Learn more and Get Involved  

We would love for you to join us to help build Radius:  

- Try the [Radius Todo List Application](https://github.com/Reshrahim/todoapp-ai)  
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)  
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)  
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos  

Thank you to all the contributors who made this release possible!
