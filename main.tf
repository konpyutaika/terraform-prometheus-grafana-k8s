resource "kubernetes_namespace" "monitoring_namespace" {
  count = var.create_monitoring_namespace ? 1 : 0

  metadata {
    name = var.monitoring_namespace
    labels = {
    }
  }
}