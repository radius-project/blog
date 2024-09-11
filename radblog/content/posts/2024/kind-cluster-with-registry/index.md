---
date: "2024-09-10T00:00:00"
title: "Separating Cloud and Non-Cloud Functional Tests in PR Workflows"
linkTitle: "Cloud and Non-Cloud Functional Tests"
author: "[Yetkin Timocin](https://www.github.com/ytimocin)"
type: blog
---

## Functional Testing in Radius

In Radius, we have both unit tests and functional tests. As you may know, unit tests check the functionality of individual units, such as a function. On the other hand, functional tests check the integration and interaction of multiple components of Radius to ensure they work together as expected.

Functional tests in Radius create resources in Kubernetes clusters that are spun up specifically for the tests. These clusters are destroyed at the end of each test run. Additionally, some functional tests create cloud resources on Azure and AWS, which are also deleted after the tests finish.

The functional tests that use cloud resources require some sensitive data, such as provider secrets, to be used in the tests. For example, when one of our functional tests creates a Radius environment, that environment needs credentials to create cloud resources on Azure or AWS. Some of this sensitive information is stored at the organization level in GitHub, while other sensitive data is kept at the repository level.

Because we are dealing with sensitive information in the functional tests and need to run these tests for each pull request opened by our contributors, we implemented a process where a Radius maintainer or approver must approve the functional test run. This approval occurs after reviewing the code to ensure there is nothing malicious, such as attempts to extract sensitive information.

### Challenges with Functional Testing in Radius

As discussed above, in Radius, we have two types of functional tests: those that create and use cloud resources, and those that do not require any cloud resources. You can see our functional tests by visiting this [link](https://github.com/radius-project/radius/tree/main/test/functional-portable). For functional tests that create and use cloud resources, we have added several tests that create resources on different clouds, such as Azure and AWS.

One of the most important challenges identified by the Radius development team with the functional testing workflow is the need to validate pull requests from forked repositories for attempts to expose sensitive data, such as cloud credentials, other secrets, or configurations. After an initial review of the pull request, a maintainer or approver of the main repository must approve and initiate the functional test check. If all tests pass, the pull request can be marked as good-to-go.

This process can sometimes slow down pull request turnaround (the time it takes from PR creation to merging into the main branch). We knew we needed to improve the efficiency of our pull request process to provide a smoother experience for our contributors. At Radius, we are always striving to enhance the experience for our users and all types of contributors.

**In brief, the challenge was to separate the functional tests that use cloud resources from those that don't, reducing the number of tests requiring maintainer approval.**

### Description of the Old Workflow

Previously, we ran all the functional tests together in a single workflow. That workflow, now renamed to [`functional-test-cloud.yaml`](https://github.com/radius-project/radius/blob/main/.github/workflows/functional-test-cloud.yaml), remains largely the same with a few changes. The most important change, as you can guess, is that now it only runs the functional tests that create and use cloud resources. Before running the functional tests, we need to create the necessary images with the changes introduced in the pull request and push them to a container registry accessible by the host machine created by the workflow. Radius uses GHCR as the container registry and pushes all the images used by the tests there.

{{< image src="images/functional-tests-cloud-ghcr.png" alt="Simple representation of how functional tests cloud use GHCR" width="500" >}}

In the new workflow that runs functional tests that don't use cloud resources, we wanted to avoid the need for all pull requests to build and push images to the Radius GHCR. This requirement was something we specifically wanted to eliminate to make it easier for contributors to work from their forks without unnecessary complications. Additionally, we didn't want to clutter our container registry, as this could easily become a security and resource issue.

In the new workflow for functional tests that don't use cloud resources, we aimed to eliminate the need for all pull requests to build and push images to the Radius GHCR. This change simplifies the process for contributors of Radius working from their forks and helps avoid cluttering our container registry, which could lead to security and resource issues.

## Our Solution

To improve the efficiency of our pull request process, the Radius development team decided to separate the functional tests into those that use cloud resources and those that don't. The tests that don't use cloud resources start as soon as a pull request is opened, without requiring approval from a maintainer or approver of Radius. This change significantly reduces the time it takes to run all the functional tests.

### Adding the New Workflow

As mentioned above, we ended up renaming our existing workflow to [functional-test-cloud](https://github.com/radius-project/radius/actions/workflows/functional-test-cloud.yaml) and added another one called [functional-test-noncloud](https://github.com/radius-project/radius/actions/workflows/functional-test-noncloud.yaml). The new workflow runs functional tests that don't use cloud resources without requiring approval from a maintainer or approver of Radius.

In this new workflow, we aimed to eliminate any dependency on cloud resources; everything was designed to run within the host machine. This meant that we would no longer run our functional tests on an AKS or EKS cluster, nor would we use any resource groups from Azure or any other resource from AWS. Additionally, no repository or organizational level secrets were to be used.

The decision was to use a [KinD cluster](https://kind.sigs.k8s.io/) and a secure [Docker registry](https://hub.docker.com/_/registry) for uploading the images specific to each run. Each test would create its own KinD cluster and secure Docker registry on the host machine, and after each run, they would be destroyed. This approach ensured that we wouldn't have any dangling resources in the cloud or leftover images on GHCR. Additionally, we wouldn’t need any secrets for this workflow or approval from a maintainer or approver.

{{< image src="images/functional-tests-noncloud-arch.png" alt="Simple representation of how functional tests noncloud workflow works" width="700" >}}

### Creating the Secure Docker Registry

Documentation on how to create an unsecured (HTTP) Docker registry is widely available, but there are not a lot of geared towards creating secure (HTTPS) ones. [This user guide on creating a KinD cluster and a local registry](https://kind.sigs.k8s.io/docs/user/local-registry/) is a good place to start if you are experimenting with KinD cluster and Docker registry.

Here are the steps to create a secure Docker registry:

1. Create a directory for the certificates that you will be generating for the HTTPS (HTTP over TLS) communication.
1. Create certificates for the Docker registry. You can see how we did this in Radius [here](https://github.com/radius-project/radius/blob/main/.github/actions/create-local-registry/action.yaml#L39).
1. Add the certificate to the system trust store in the host machine.
1. If you have a specific registry name, you should add it to `/etc/hosts` so that it can point to the localhost in the host machine.
1. Create the secure Docker registry by running `docker run` command. You need to pass in certificate details to the command.

### Creating the KinD Cluster

After setting up the secure Docker registry on the host machine, the next step is to create the Kubernetes cluster for running the functional tests. We chose KinD (Kubernetes in Docker) for managing these clusters. Here is an example of how you can create a KinD cluster:

```bash
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
    - containerPath: "/etc/containerd/certs.d/${{ inputs.registry-name }}"
      hostPath: "${{ inputs.temp-cert-dir }}/certs/${{ inputs.registry-server }}"
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry]
    config_path = "/etc/containerd/certs.d"
EOF
```

As you can see, the script mounts the directory from the host machine containing certificates into the container at a specified path. These certificates are the certificates of the secure Docker registry. They need to be recognized by the cluster to enable communication between the cluster and the registry.

You can find the details of the action we created, which sets up a KinD cluster with or without a secure Docker registry, [here](https://github.com/radius-project/radius/blob/main/.github/actions/create-kind-cluster/action.yaml).

## Summary

As a frequent contributor to Radius, I think separating these tests has made the pull request process smoother for me. I know that I still need approval to kick-start some of the functional tests, but the set of functional tests that require approval is now smaller. This change has significantly reduced the time it takes to get feedback on my pull requests, allowing me to iterate more quickly and efficiently.

Additionally, this separation has made it easier for all contributors to get involved without facing delays. By running non-cloud tests immediately, we can catch issues earlier in the development process. This not only improves the overall quality of the code but also fosters a more collaborative and inclusive environment for all contributors.

Overall, the new workflow has streamlined our development process, reduced bottlenecks, and enhanced the contributor experience.

We are always looking to improve our process, so please let us know what you think about this addition to Radius.

## Learn more and contribute

The Radius maintainers are excited to continue collaborating with the open-source community to grow its feature set and welcome all contributions from the community.

We're looking for people to join us! To get started with Radius today, please see:

- Learn more from the [documentation](https://radapp.io/).
- Explore the open-source [code repositories](https://github.com/radius-project).
- Engage with the [community](https://aka.ms/radius/discord).

## References

- <https://kind.sigs.k8s.io/docs/user/local-registry/>
