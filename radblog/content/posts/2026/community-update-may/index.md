---
date: "2026-05-29T08:00:00-08:00"
title: "Radius Community Update: May 2026"
linkTitle: "Community Update May 2026"
author: "Radius Community"
type: blog
---

Welcome to the May 2026 Radius community update! This month was packed with two releases, new features, important fixes, and exciting community contributions. Here's a summary of what happened across the Radius project.

## Releases

### Radius v0.57.1 (patch release)

Released on May 12, this patch release addressed several critical issues:

- Pinned the Deployment Engine image to `0.56` to work around a bug in Deployment Engine `0.57.0`
- Pinned the Bicep CLI to `v0.42.1` to work around a breaking change in Bicep `v0.43+` that rejects local registry targets
- Pinned the Terraform version to avoid surprise breaking changes

For full details, see the [v0.57.1 release notes](https://github.com/radius-project/radius/releases/tag/v0.57.1).

### Radius v0.58.0

Released on May 26, this is the latest major release of Radius. Key highlights include:

- **Breaking change:** `rad init` no longer creates `.rad/rad.yaml`, and the rad CLI no longer uses `.rad/rad.yaml` to implicitly determine the current application. Commands that previously relied on this file may now require the `--application <name>` flag or a positional argument.
- **New `--preview` flag for `rad app graph` and `rad app status`** — Preview your application graph and status before deployment ([#11983](https://github.com/radius-project/radius/pull/11983))
- **`rad app show/list/delete --preview`** — Manage preview applications with the rad CLI ([#11935](https://github.com/radius-project/radius/pull/11935))
- **`rad workspace create --preview`** — Create preview workspaces ([#11905](https://github.com/radius-project/radius/pull/11905))
- **`rad install` now creates default resource group and environment** — Streamlined setup experience ([#11870](https://github.com/radius-project/radius/pull/11870))
- **Hydrate Radius.Core schemas from OpenAPI** — Improved type system alignment ([#11881](https://github.com/radius-project/radius/pull/11881))
- **Fix Helm chart pre-mounted Terraform binary path mismatch** ([#11880](https://github.com/radius-project/radius/pull/11880))
- **Fix resource types missing from `rad resource-type list`** with per-type manifest files ([#11933](https://github.com/radius-project/radius/pull/11933))
- **MySQL type added to default recipe pack** ([#11913](https://github.com/radius-project/radius/pull/11913))
- **Automated default resource type registration** from resource-types-contrib ([#11911](https://github.com/radius-project/radius/pull/11911))
- **Multi-file merge support for manifest-to-bicep generate command** ([#11914](https://github.com/radius-project/radius/pull/11914))
- **Controller-runtime v0.24 upgrade** and scheme.Builder deprecation migration ([#11861](https://github.com/radius-project/radius/pull/11861))

For full details, see the [v0.58.0 release notes](https://github.com/radius-project/radius/releases/tag/v0.58.0).

## Across the project

Activity spanned multiple repositories this month:

- **radius-project/resource-types-contrib**: Fixed fully qualified environment IDs in deploy-recipe-pack and improved Azure validation checks for PRs
- **radius-project/docs**: Migrated to cspell for spell checking and updated auto-generated CLI documentation to reflect new commands
- **radius-project/dashboard**: Fixed Docker configuration for development environments
- **radius-project/blog**: Published the [Headlamp plugin blog post](https://blog.radapp.io/posts/2026/03/19/how-i-built-a-radius-plugin-for-headlamp/) and migrated to cspell

## New contributors

A warm welcome to the new contributors who merged their first PRs in the v0.58.0 release:

- **@officialasishkumar** — [#11557](https://github.com/radius-project/radius/pull/11557)
- **@sethficke** — [#11680](https://github.com/radius-project/radius/pull/11680)
- **@AkashKumar7902** — [#11764](https://github.com/radius-project/radius/pull/11764)

Thank you for your contributions! 🎉

## Community spotlight

We'd like to highlight a community member contribution by [rios.engineer](https://rios.engineer/project-radius/) who wrote about their experience with Project Radius. Community-authored content like this helps spread awareness and provides real-world perspectives on using Radius. Thank you for sharing your journey with the community!

## Get involved

We would love for you to join us to help build Radius:

- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/)
- Check out the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
