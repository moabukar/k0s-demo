# K0s Demo

k0s is an open source, all-inclusive Kubernetes distribution, which is configured with all of the features needed to build a Kubernetes cluster.

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
