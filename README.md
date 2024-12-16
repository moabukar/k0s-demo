# K0s Demo

## Setup

```bash
## Install via Binary

ksctl init > k0sctl.yml

ksctl apply --config k0sctl.yml

ksctl kubeconfig > kubeconfig

kubectl get pods --kubeconfig kubeconfig -A
```
