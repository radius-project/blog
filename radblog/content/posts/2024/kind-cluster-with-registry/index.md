---
date: "2024-08-09T00:00:00"
title: "Creating a KinD cluster and a secure Docker image registry"
linkTitle: "Application Graph"
author: "[Yetkin Timocin](https://www.github.com/ytimocin)"
type: blog
---

A few weeks ago, we began working on splitting our functional tests. The goal was to separate tests that utilize cloud resources from those that do not, which consequently do not require access to cloud-related secrets. If you've been following or using Radius, you might be aware that pull requests submitted by contributors require approval from a maintainer or approver before the functional tests can run. The rationale behind this is to review the code and, in the event of malicious intent, prevent potential risks, such as the leaking of secrets.

With this new update, one of our primary goals was to establish a new workflow that does not require approval and automatically starts running functional tests that do not require cloud resources. This approach leads to faster and more efficient PRs.

## Adding the new workflow

We ended up renaming our existing workflow to [functional-test-cloud](https://github.com/radius-project/radius/actions/workflows/functional-test-cloud.yaml) and added another one called [functional-test-noncloud](https://github.com/radius-project/radius/actions/workflows/functional-test-noncloud.yaml).

In this new workflow, we aimed to eliminate any dependency on cloud resources; everything was designed to run within the host machine. This meant that we would no longer run our functional tests on an AKS or EKS cluster, nor would we use any resource groups from Azure. Additionally, no repository or organizational level secrets were to be used.

One of the most important steps in our functional test workflow is building the necessary images and uploading them to [GHCR](https://github.com/orgs/radius-project/packages). However, we decided to exclude this step from our new workflow, as it would consume unnecessary space in our GHCR and require additional permissions, which we wanted to avoid.

The decision was to use a [KinD cluster](https://kind.sigs.k8s.io/) and a secure [Docker registry](https://hub.docker.com/_/registry) for uploading the images specific to each run. Each test would create its own KinD cluster and secure Docker registry on the host machine, and after each run, they would be destroyed. This approach ensured that we wouldn't have any dangling resources in the cloud or leftover images on GHCR. Additionally, we wouldn’t need any secrets for this workflow or approval from a maintainer or approver.

## Creating the secure Docker registry

You may find multiple documentation on how to create an insecure (HTTP) Docker registry but there are not a lot of them for the secure one. [This user guide on creating a KinD cluster and a local registry](https://kind.sigs.k8s.io/docs/user/local-registry/) might be a good place to start if you are experimenting with KinD cluster and Docker registry.

Here are the steps to create a secure Docker registry:

1. Create a directory for the certificates that you will be generating for the HTTPS (HTTP over TLS) communication.
1. Create certificates for the Docker registry. You can see how we did this in Radius here: <https://github.com/radius-project/radius/blob/main/.github/actions/create-local-registry/action.yaml#L39>.
1. Add the certificate to the system trust store in the host machine.
1. If you have a specific registry name, you should add it to `/etc/hosts` so that it can point to the localhost in the host machine.
1. Create the secure Docker registry by running `docker run` command. You need to pass in certificate details to the command.

## Creating the KinD cluster

<https://github.com/radius-project/radius/blob/main/.github/actions/create-kind-cluster/action.yaml>

## References

- <https://kind.sigs.k8s.io/docs/user/local-registry/>
