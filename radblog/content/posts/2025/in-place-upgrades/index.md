---
date: "2025-09-04T08:00:00-08:00"
title: "In-place upgrades now available"
linkTitle: "In-place upgrades"
author: "[Will Tsai](https://www.github.com/willtsai)"
type: blog
---

Up until now, upgrading a Radius installation meant manually redeploying the control plane. This was cumbersome and risked downtime for your internal platform. **Beginning with Radius v0.50, we're excited to announce support for in-place upgrades of the Radius control plane.** Using the new `rad upgrade` command, platform engineers can now upgrade a running Radius control plane to a new version without rebuilding their environments or disrupting running applications. This enhancement makes it much easier to keep up with new Radius releases in production, thanks to built-in safety checks and a rollback capability.

In this post, we'll walk through how the new in-place upgrade feature works and how to use the `rad upgrade` and `rad rollback` commands to upgrade safely. For a more detailed step-by-step guide, check out the official [How-To: Upgrade Radius on Kubernetes](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/) and [How-To: Rollback Radius on Kubernetes](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-rollback/) in the documentation.

## Upgrading Radius control plane in-place with `rad upgrade`

Performing an in-place [upgrade](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/) of Radius is straightforward. Here's a high-level overview of the process:

1. **Upgrade your Radius CLI:** First, ensure you have the latest `rad` CLI (v0.50 or later) installed on your machine. The new CLI version includes the `rad upgrade` and `rad rollback` commands. You can verify your CLI version by running:  
   ```bash
   $ rad version 
   ```  
   Make sure it shows **0.50.0 or later** as the version. If not, update the CLI before proceeding.

2. **Run the upgrade command:** Once your CLI is up to date, initiate the control plane upgrade with:  
   ```bash
   $ rad upgrade kubernetes
   ```  
   This will upgrade the Radius control plane in your Kubernetes cluster to the latest version matching your CLI. The CLI will first run a series of preflight checks (more on this below) to ensure your cluster and current Radius installation are ready to upgrade. If all checks pass, `rad upgrade` will proceed to perform the upgrade. Under the hood, this triggers a Helm-based upgrade of the Radius components running in the cluster. The upgrade is applied as a rolling update to minimize downtime - Radius's pods will be updated to the new version one by one, preserving the system's state and all your environment configurations.

   Alternatively, if you want to upgrade explicitly to a specific version, you can use the `--version` flag. For instance, to upgrade to v0.50.0:  
   ```bash
   $ rad upgrade kubernetes --version 0.50.0 
   ```  
   (If you omit `--version`, the CLI upgrades to the same version as the CLI itself.)

3. **Verify the upgrade:** After the command finishes, you should verify that the control plane is running the new version and everything is healthy. You can check the Radius version again, which should now reflect the upgraded version:  
   ```bash
   $ rad version
   CLI Version Information:
   RELEASE   VERSION   BICEP     COMMIT
   0.50.0    v0.50.0   0.37.4    42e20ccab9001f54cc9c3074fd20016260a37792

   Control Plane Information:
   STATUS     VERSION
   Installed  0.50.0
   ```

> **Important:** Radius currently supports *incremental upgrades* only. That means you should upgrade one version at a time (e.g. from v0.49 to v0.50). Skipping directly over a version is not supported by `rad upgrade` and will be blocked by the version check. Always upgrade sequentially and consult the release notes if you are coming from older versions.

### Preflight Checks for Safe Upgrades

One of the great things about `rad upgrade` is that it includes built-in preflight checks to catch any issues before making changes to your cluster. When you run the upgrade command, Radius will automatically validate a number of conditions, such as:
- **Kubernetes connectivity and permissions**: Verifies connection to the cluster and required RBAC permissions
- **Helm connectivity and installation status**: Confirms Radius is installed via Helm and can be upgraded
- **Version compatibility validation**: Ensures the target version is compatible with your current version
- **Cluster resource availability**: Checks for sufficient resources (optional warning)
- **Custom configuration validation**: Validates any custom Helm values

If any of these checks fail or raise an issue, the CLI will stop the process and inform you what needs to be fixed. No changes will be made to your cluster unless all preflight checks pass. This gives you confidence that once the upgrade proceeds, it won't hit a surprise error halfway through.

## Rolling Back if Something Goes Wrong

What if you perform an upgrade and encounter an unexpected problem with the new version? In previous releases, you would have been stuck trying to reinstall the old version manually. Beginning with Radius v0.50, along with upgrades, we've introduced a [rollback mechanism](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-rollback/) for fast recovery.

If an upgrade doesn't go as planned, you can simply run:  
```bash
$ rad rollback kubernetes
```

This command will revert the Radius control plane back to the last deployed version. Under the hood, `rad rollback` uses Helm's built-in rollback capability to restore the previous release of Radius. Essentially, it redeploys the prior version's containers and settings, so your control plane goes back to the state it was in before the upgrade was attempted.

A successful rollback means your environments and applications should continue working under the old version, just as before. No reconfiguration should be needed — the aim is to quickly get you back to a known good state. 

It's worth noting that `rad rollback` will target the immediate previous release (the one you just upgraded from). If you had made several upgrades sequentially and needed to roll back further, you would potentially need to run the command multiple times or re-upgrade to the desired version. In practice, you'll typically detect any issues right after an upgrade and use rollback once.

We also **recommend backing up** your Radius environment definitions before any upgrade, as an extra safety measure. For example, you can export your environment configurations to a file:  
```bash
$ rad env show <env-name> -o yaml > <env-name>-backup.yaml
```

Do this for each environment. In the unlikely event that something goes really wrong, having these definitions backed up means you could recreate the environments if needed. (However, in most cases, the rollback command will handle restoration without any manual intervention.)

## Upgrading or installing with custom container images

If you want to use custom-built or predownloaded container images for Radius, you can specify them during installation or upgrade. This is useful for air-gapped environments or when using private registries to store container images that have been pre-approved or scanned. We have added `global.imageRegistry`, `global.imageTag`, and `global.imagePullSecrets` properties that may be used with commands like `rad install kubernetes`, `rad upgrade kubernetes`, and `rad init`. For example, to upgrade using a private image registry and tag, you can run:

```bash
$ rad upgrade kubernetes --set global.imageRegistry=myregistry.com/radius --set global.imageTag=v0.50.0 --set global.imagePullSecrets=my-pull-secret
```

## Learn more
For more details on in-place upgrades and rollbacks, check out the following resources in the documentation:
- [How-To: Upgrade Radius on Kubernetes](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-upgrade/)
- [How-To: Rollback Radius on Kubernetes](https://docs.radapp.io/guides/operations/kubernetes/kubernetes-rollback/)

## Get involved

We would love for you to join us to help build Radius:

- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos