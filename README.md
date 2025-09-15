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

## Contributing Blog Posts

Follow the [Contribution Guide](./radblog/guide/contribution-guide.md) for more details on writing and formatting blog posts.

