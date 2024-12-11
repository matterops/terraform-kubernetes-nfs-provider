# terraform-kubernetes-nfs-provider

Terraform module which deploys a nfs-client-provisioner to Kubernetes

## Usage

```terraform
provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "nfsc" {
  source = "github.com/o0th/terraform-kubernetes-nfs-provider?ref=1.0.0"

  namespace = "nfsc"

  nfs_server = "192.168.178.13"
  nfs_path   = "/mnt/storage"

  image = "quay.io/external_storage/nfs-client-provisioner-arm:latest"
}
```

### Inputs

| Name         | Type     |
|--------------|----------|
| `namespace`  | `String` |
| `nfs_server` | `String` |
| `nfs_path`   | `String` |
| `image`      | `String` |

### Outputs

| Name                 | Type     |
|----------------------|----------|
| `storage_class_name` | `String` |
