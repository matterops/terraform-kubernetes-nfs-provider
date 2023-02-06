# terraform-kubernetes-nfs-provider

![GitHub tag](https://img.shields.io/github/v/tag/o0th/terraform-kubernetes-nfs-provider?style=for-the-badge)

Terraform module which deploys a nfs-client-provisioner to Kubernetes

## Requirements

* Terraform 0.13+
* NFS Server
* Kubernetes cluster

## Usage

Configuration

```terraform
provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "nfsc" {
  source = "github.com/o0th/terraform-kubernetes-nfs-provider"

  namespace = "nfsc"

  nfs_server = "192.168.178.13"
  nfs_path   = "/mnt/storage"

  image = "quay.io/external_storage/nfs-client-provisioner-arm:latest"
}
```

Terraform

```bash
terraform init
terraform plan
terraform apply
```

---

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/o0th/terraform-kubernetes-nfs-provider?style=for-the-badge)
