---
date: "2025-08-19T19:16:07+0000"
title: "Radius v0.50.0 Released"
linkTitle: "Radius v0.50.0"
author: "Radius Team"
type: blog
---

# Announcing Radius v0.50.0  

Radius v0.50.0 is here, and this release introduces several key features and improvements for developers and platform engineers building cloud-native applications. From in-place upgrades to enhanced resource type functionality and offline installation support, v0.50.0 focuses on making Radius more robust, flexible, and user-friendly. Below, we’ll dive into the major enhancements, breaking changes, and technical details you need to know to start using this version effectively.  

## Key Features and Improvements  

### In-Place Upgrades with `rad upgrade` and `rad rollback`  

Radius v0.50.0 introduces in-place upgrades for the Radius control plane using the new `rad upgrade` command. This feature simplifies the upgrade process by preserving existing environments and applications during the upgrade. To ensure operational stability, a complementary `rad rollback` command is also included to revert to the previous version if needed.  

For example, to upgrade your Kubernetes-based Radius installation, you can now run:  

```bash  
rad upgrade kubernetes  
```  

Preflight checks are integrated with the upgrade process to validate your environment before initiating the upgrade. This ensures a smoother and more predictable experience. If an issue occurs during or after the upgrade, you can execute:  

```bash  
rad rollback kubernetes  
```  

For detailed steps on upgrading and rollback procedures, refer to the [Radius upgrade documentation](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/).  

---

### Enhancements to Radius Resource Types  

Radius resource types now support more powerful schemas, providing developers with tools to model cloud-native resources more effectively:  

- **Support for Arrays of Objects**: Properties within resource type definitions can now be defined as arrays of objects. This enhancement allows for more complex and flexible resource modeling.  
- **Enum Type Validation**: You can now specify an `enum` type to validate input values prior to deployment. This ensures that invalid values are caught early in the development process.  

#### Breaking Change: `name` Property Replaced by `namespace`  

The `name` property in resource type definition YAML files has been replaced by `namespace`. If you’re creating resource types using YAML files, ensure your definitions are updated to reflect this change.  

For example, the first line of your `types.yaml` file should now read:  

```yaml  
namespace: Radius.Resources  
```  

instead of:  

```yaml  
name: Radius.Resources  
```  

If you attempt to use the old `name` property, your resource type creation will fail. Update your YAML files accordingly before running:  

```bash  
rad resource-type create -f types.yaml  
```  

For more details on resource type definitions, refer to the [Radius documentation](https://docs.radapp.io/).  

---

### Offline Installation Support  

Radius v0.50.0 makes it easier to use Radius in air-gapped or offline environments. You can now configure the `rad install` command or the Helm chart to reference a private image registry.  

#### Configuration Options for Helm Chart  

To enable offline installation using the Helm chart, specify the following parameters:  

- `global.imageRegistry`: The private container registry URL where Radius images are stored.  
- `global.imageTag`: The specific version tag for the Radius images.  

For example, your Helm configuration might look like this:  

```yaml  
global:  
  imageRegistry: my-private-registry.io  
  imageTag: v0.50.0  
```  

If you are using a private registry that requires authentication, you can also configure:  

- `global.imagePullSecrets`: A reference to Kubernetes secrets for authenticating with the private registry.  

This ensures that Radius can be deployed even in environments without direct internet access.  

---

## Breaking Changes  

This release includes a critical breaking change to the YAML schema for resource type definitions:  

- The `name` property in resource type YAML files has been replaced by `namespace`. All resource type definitions must be updated accordingly.  

Be sure to review your existing resource type definitions and update them before upgrading to v0.50.0. Refer to the Radius resource type documentation for guidance.  

---

## Full Changelog  

A detailed list of changes, fixes, and improvements in this release is available in the [full changelog](https://github.com/radius-project/radius/compare/v0.49.0...v0.50.0). Highlights include:  

- Integration of preflight checks with the `rad upgrade kubernetes` command.  
- Enhanced resource type definitions to support arrays and enums.  
- Server-side validation for resource data against type schemas.  
- Implementation of the `rad rollback kubernetes` command.  
- Offline installation support through private image registry configuration.  

---

## Learn more and Get Involved  

We would love for you to join us to help build Radius:  

- Try the [Radius Todo List Application](https://github.com/Reshrahim/todoapp-ai)  
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)  
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)  
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos  

Radius v0.50.0 brings significant improvements to the way developers and platform engineers build, manage, and operate cloud-native applications. Dive into the release today and explore the new capabilities!  
