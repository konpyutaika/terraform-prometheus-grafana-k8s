output "wait_for_provisioned" {
  description = "Addons"
  value       = [k8s_manifest.grafana_addon, k8s_manifest.grafana_cm_addon]
}

output "prometheus_release_namespace" {
  description = "Prometheus namespace"
  value       = helm_release.prometheus.namespace
}

output "prometheus_release_name" {
  description = "Prometheus release name"
  value       = helm_release.prometheus.name
}