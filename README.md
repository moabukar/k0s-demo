# K0s with Multipass

k0s is an open source, all-inclusive Kubernetes distribution, which is configured with all of the features needed to build a Kubernetes cluster.

Using Multipass to create the VMs and k0sctl to install k0s on them.

## Prerequisites

- [Multipass](https://multipass.run/install)
- [k0sctl](https://k0sproject.io/docs/installation/k0sctl/)

## Setup

```bash
## Install via Binary

ksctl init > k0sctl.yml

ksctl apply --config k0sctl.yml

ksctl kubeconfig > kubeconfig

kubectl get pods --kubeconfig kubeconfig -A

kubectl --kubeconfig kubeconfig get nodes

##

ksctl kubeconfig --config k0sctl.yml


```
