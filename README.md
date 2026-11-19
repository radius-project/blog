# Radius blog

The Radius blog is a place to share the latest news, updates, features, customer stories, and more about the Radius project. This repository contains the markdown files which generate the Radius blog site at <https://blog.radapp.io/>. Head over there to read the blog and learn more about the latest Radius news! Read on to get up and running with a local environment to contribute to the blog.

## Overview

The Radius blog is built using [Hugo](https://gohugo.io/) with the [Docsy](https://docsy.dev) theme and published to [GitHub Pages](https://pages.github.com/).

The [site](./site) directory contains the hugo project, markdown files, and theme configurations.

## Pre-requisites

- [Hugo extended version](https://gohugo.io/getting-started/installing)
- [Node.js](https://nodejs.org/en/)

## Environment setup

1. Ensure pre-requisites are installed
1. Clone repository
1. Change to site directory: `cd site`
1. Install npm packages: `npm install`

The Docsy theme is pulled in automatically via [Hugo Modules](https://gohugo.io/hugo-modules/) on first build — no git submodule setup required.

## Run local server

1. Make sure you're still in the site directory
1. Run `npm run start:drafts` (or `npm run start` to exclude drafts)
1. Navigate to <http://localhost:1313/> to see the posts list. It is also available at `/posts/`.

## Contributing Blog Posts

Follow the [Contribution Guide](./site/guide/contribution-guide.md) for more details on writing and formatting blog posts.

## Publishing

The [Publish Blog to GitHub Pages workflow](./.github/workflows/blog.yaml) runs on pushes to `main`, daily at 16:00 UTC, and when run manually on `main`. It builds the site once, uploads it as a Pages artifact, and deploys that artifact without rebuilding. Pull requests produce a downloadable preview instead of deploying.

In [Settings > Pages](https://github.com/radius-project/blog/settings/pages), use **GitHub Actions** as the publishing source and leave **Custom domain** empty to preview at <https://radius-project.github.io/blog/> after the first successful deployment.

When ready to cut over, set `blog.radapp.io` as the Pages custom domain, point its DNS CNAME to `radius-project.github.io`, and rerun the workflow on `main` to rebuild with the new URL. Verify HTTPS after the DNS change.
