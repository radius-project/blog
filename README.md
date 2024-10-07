# Radius blog 

The Radius blog is a place to share the latest news, updates, features, customer stories, and more about the Radius project. This repository contains the markdown files which generate the Radius blog site at https://blog.radapp.io/. Head over there to read the blog and learn more about the latest Radius news! Read on to get up and running with a local environment to contribute to the blog.

## Overview

The Radius blog is built using [Hugo](https://gohugo.io/) with the [Docsy](https://docsy.dev) theme, hosted on an [Azure static web app](https://docs.microsoft.com/en-us/azure/static-web-apps/overview).

The [radblog](./radblog) directory contains the hugo project, markdown files, and theme configurations.

## Pre-requisites

- [Hugo extended version](https://gohugo.io/getting-started/installing)
- [Node.js](https://nodejs.org/en/)

## Environment setup

1. Ensure pre-requisites are installed
1. Clone repository
1. Change to radblog directory: `cd radblog`
1. Add Docsy submodule: `git submodule add https://github.com/google/docsy.git themes/docsy`
1. Update submodules: `git submodule update --init --recursive`
1. Install npm packages: `npm install`

## Run local server

1. Make sure you're still in the radblog directory
1. Run `hugo server --disableFastRender`
1. Navigate to `http://localhost:1313/posts`

## Update blog

1. Create new branch
1. Commit and push changes to content
1. Submit pull request to `main`
1. Staging site will automatically get created and linked to PR to review and test

## Location and structure of post content

Create a new markdown file for each blog post in the appropriate year directory under `radblog/content/posts`. The file name should be the title of the blog post, with hyphens in place of spaces. For example, the file name for a blog post titled "Hello world" would be `hello-world.md`.

The content of the blog post markdown file should be in the following format:

```md
---
date: "YYYY-MM-DDT07:00:00-07:00"
title: "Blog post title"
linkTitle: "Shorter blog post title in links pane"
author: Radius project maintainers
type: blog
---

Blog post content here.
```
## Style guide

Follow the [style guide](radblog/guide/style-guide.md) to write blog posts.