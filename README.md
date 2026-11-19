# Radius blog

The Radius blog is a place to share the latest news, updates, features, customer stories, and more about the Radius project. This repository contains the markdown files which generate the Radius blog site at <https://blog.radapp.io/>. Head over there to read the blog and learn more about the latest Radius news! Read on to get up and running with a local environment to contribute to the blog.

## Overview

The Radius blog is built using [Hugo](https://gohugo.io/) with the [Docsy](https://docsy.dev) theme and published to [GitHub Pages](https://pages.github.com/).

The Hugo project lives at the repository root. Post sources and images are in [content/posts](./content/posts), and theme overrides are in [layouts](./layouts) and [assets](./assets).

## Prerequisites

- [Node.js](https://nodejs.org/en/) as specified in [`.node-version`](./.node-version)
- [Go](https://go.dev/dl/) as specified in [`go.mod`](./go.mod), for Hugo Modules

## Environment setup

Clone the repository and run `npm ci` from its root. The npm dependencies include Hugo Extended. Hugo fetches the Docsy theme via [Hugo Modules](https://gohugo.io/hugo-modules/) on the first build; no Git submodules are required.

## Run local server

1. From the repository root, run `npm run start:drafts` (or `npm run start` to exclude drafts).
1. Navigate to <http://localhost:1313/> to see the posts list. It is also available at `/posts/`.

## Contributing Blog Posts

Follow the [Contribution Guide](./guide/contribution-guide.md) for more details on writing and formatting blog posts.

## Publishing

Run `npm run build` from the repository root to generate the site in Hugo's [default `public/` directory](https://gohugo.io/getting-started/directory-structure/#directories). This output is ignored by Git.

The [Publish workflow](./.github/workflows/publish.yaml) runs on pushes to `main`, daily at 16:00 UTC, and when run manually on `main`. It builds the site once, uploads only `public/` as a Pages artifact, and deploys that artifact without rebuilding. Pull requests produce a downloadable preview instead of deploying.

In [Settings > Pages](https://github.com/radius-project/blog/settings/pages), use **GitHub Actions** as the publishing source and leave **Custom domain** empty to preview at <https://radius-project.github.io/blog/> after the first successful deployment.

When ready to cut over, set `blog.radapp.io` as the Pages custom domain, point its DNS CNAME to `radius-project.github.io`, and rerun the workflow on `main` to rebuild with the new URL. Verify HTTPS after the DNS change.
