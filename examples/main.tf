provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "nfsc" {
  source = "../"

  namespace = "nfsc"

  nfs_server = "192.168.178.13"
  nfs_path   = "/mnt/storage"

  image = "quay.io/external_storage/nfs-client-provisioner-arm:latest"
}
