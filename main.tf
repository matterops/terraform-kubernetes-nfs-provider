resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "${kubernetes_namespace.this.metadata[0].name}-service-account"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  secret {
    name = kubernetes_secret.this.metadata.0.name
  }
}

resource "kubernetes_secret" "this" {
  metadata {
    name = "${kubernetes_namespace.this.metadata[0].name}-secret"
  }
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "${kubernetes_namespace.this.metadata[0].name}-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch", "update"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "update", "patch"]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "${kubernetes_cluster_role.this.metadata[0].name}-role-binding"
  }

  role_ref {
    kind      = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
    name      = kubernetes_cluster_role.this.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_role" "this" {
  metadata {
    name      = "${kubernetes_namespace.this.metadata[0].name}-role"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }
}

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = "${kubernetes_namespace.this.metadata[0].name}-role-binding"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.this.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_storage_class" "this" {
  metadata {
    name = "${kubernetes_namespace.this.metadata[0].name}-storage-class"
  }

  storage_provisioner = "ff1.dev/nfs"

  parameters = {
    "archiveOnDelete" = "false"
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = "${kubernetes_namespace.this.metadata[0].name}-deployment"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        "app" = "${kubernetes_namespace.this.metadata[0].name}-deployment"
      }
    }

    replicas = 1

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          "app" = "${kubernetes_namespace.this.metadata[0].name}-deployment"
        }
      }

      spec {

        service_account_name = kubernetes_service_account.this.metadata[0].name

        container {
          name  = "${kubernetes_namespace.this.metadata[0].name}-pod"
          image = var.image

          resources {
            limits = {
              "cpu"    = 1
              "memory" = "1Gi"
            }
          }

          volume_mount {
            name       = "storage"
            mount_path = "/persistentvolumes"
          }

          env {
            name  = "PROVISIONER_NAME"
            value = "ff1.dev/nfs"
          }

          env {
            name  = "NFS_SERVER"
            value = var.nfs_server
          }

          env {
            name  = "NFS_PATH"
            value = var.nfs_path
          }
        }

        volume {
          name = "storage"
          nfs {
            server = var.nfs_server
            path   = var.nfs_path
          }
        }

      }
    }
  }
}
