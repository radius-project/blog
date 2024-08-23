---
date: "2024-09-10T00:00:00"
title: "Running functional tests that use cloud and non-cloud resources for open-source projects"
linkTitle: "Cloud and Non-Cloud Functional Tests"
author: "[Yetkin Timocin](https://www.github.com/ytimocin)"
type: blog
---

## Description of the challenge

External and internal contributors to open-source projects can sometimes face challenges when contributing to the main repository. One such challenge identified by the Radius development team is the need to check pull requests from forked repositories for attempts to expose sensitive data, such as cloud credentials, other secrets, or configurations. After an initial review of the pull request by a team member, a maintainer or approver of the main repository must approve and initiate the functional test check. If all tests pass, the pull request can be marked as good-to-go.

This process can sometimes slow down pull request turnover, so we knew we needed to improve the efficiency of our pull request process. By doing so, we aimed to provide a smoother experience for our internal and, most importantly, external contributors. At Radius, we are always striving to enhance the experience for our users and all types of contributors.

With this in mind, we started working on splitting our functional tests into those that use cloud resources and those that don't.

### What is a functional test that uses cloud resources?

Radius helps you define and deploy your cloud-native applications across different clouds and your private infrastructure. For functional tests, we have added several tests that create resources on different clouds, such as Azure and AWS. You can see our functional tests at this [link](https://github.com/radius-project/radius/tree/main/test/functional-portable).

## Solution

As discussed above, the Radius development team decided to split the functional tests into those that use cloud resources and those that don't. The tests that don't use cloud resources wouldn't require approval from an internal member of Radius and would start as soon as a pull request is opened. This would improve the time it takes to run all the functional tests.

The tests that use cloud resources would still require approval from an internal member of Radius. However, by reducing the number of tests that require approval, the overall testing time decreases. This means that pull requests can be ready for merging faster than before, provided all checks have passed.

### Description of the old workflow

The workflow we had before the split has been renamed to [`functional-test-cloud.yaml`](https://github.com/radius-project/radius/blob/main/.github/workflows/functional-test-cloud.yaml). It remains largely the same, with a few changes. Before running the functional tests, we need to create the necessary images with the changes introduced in the pull request and push them to a container registry that can be accessed by the host machine created by the workflow.

{{< image src="images/functional-tests-cloud-ghcr.png" alt="Simple representation of how functional tests cloud use GHCR" width="600" >}}

In the new workflow that runs functional tests that don't use cloud resources, we wanted to avoid the need for all pull requests to build and push images to the Radius GHCR. This requirement was something we specifically wanted to eliminate to make it easier for external contributors to work from their forks without unnecessary complications. Additionally, we didn't want to clutter our container registry, as this could easily become a security and resource issue.

### Adding the new workflow

As mentioned above, we ended up renaming our existing workflow to [functional-test-cloud](https://github.com/radius-project/radius/actions/workflows/functional-test-cloud.yaml) and added another one called [functional-test-noncloud](https://github.com/radius-project/radius/actions/workflows/functional-test-noncloud.yaml).

In this new workflow, we aimed to eliminate any dependency on cloud resources; everything was designed to run within the host machine. This meant that we would no longer run our functional tests on an AKS or EKS cluster, nor would we use any resource groups from Azure or any other resource from AWS. Additionally, no repository or organizational level secrets were to be used.

The decision was to use a [KinD cluster](https://kind.sigs.k8s.io/) and a secure [Docker registry](https://hub.docker.com/_/registry) for uploading the images specific to each run. Each test would create its own KinD cluster and secure Docker registry on the host machine, and after each run, they would be destroyed. This approach ensured that we wouldn't have any dangling resources in the cloud or leftover images on GHCR. Additionally, we wouldn’t need any secrets for this workflow or approval from a maintainer or approver.

{{< image src="images/functional-tests-noncloud-arch.png" alt="Simple representation of how functional tests noncloud workflow works" width="600" >}}

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
