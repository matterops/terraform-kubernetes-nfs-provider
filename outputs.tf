output "storage_class_name" {
  value = kubernetes_storage_class.this.metadata[0].name
}

