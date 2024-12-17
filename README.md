# terraform-kubernetes-nfs-provider

Terraform module which deploys a nfs-client-provisioner to Kubernetes

## Usage

```terraform
provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "nfsc" {
  source = "github.com/matterops/terraform-kubernetes-nfs-provider?ref=1.0.0"

  namespace = "nfsc"

  nfs_server = "192.168.178.13"
  nfs_path   = "/mnt/storage"

  image = "quay.io/external_storage/nfs-client-provisioner-arm:latest"
}
```

### Inputs

| Name         | Type     | Required |
|--------------|:--------:|:--------:|
| `namespace`  | `String` | `true`   |
| `nfs_server` | `String` | `true`   |
| `nfs_path`   | `String` | `true`   |
| `image`      | `String` | `true`   |

### Outputs

| Name                 | Type     |
|----------------------|:--------:|
| `storage_class_name` | `String` |
