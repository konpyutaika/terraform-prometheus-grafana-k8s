locals {
  grafana_cm_manifests = split("\n---\n",
    templatefile(
      "${path.module}/kubernetes/grafana/grafana-configmap.yaml", {
        root_url            = "%{if var.grafana_subpath != ""}root_url = %(protocol)s://%(domain)s:%(http_port)s${var.grafana_subpath}%{endif}"
        serve_from_sub_path = "%{if var.grafana_subpath != ""}serve_from_sub_path = true%{endif}"
        configmaps          = var.grafana_configmaps
        prometheus-hostname = "${var.prometheus_resource_instance_name}-operated"
      }
    )
  )

  grafana_svc_manifests = templatefile(
    "${path.module}/kubernetes/grafana/grafana-svc.yaml", {
      annotations  = var.grafana_svc_annotations
      target-port  = var.grafana_container_port
      service-type = var.grafana_service_type
      port         = var.grafana_svc_port
    }
  )

  grafana_dp_manifests = templatefile(
    "${path.module}/kubernetes/grafana/grafana-deployment.yaml", {
      container-port           = var.grafana_container_port
      configmaps               = var.grafana_configmaps
      kubernetes_node_selector = var.kubernetes_node_selector
    }
  )

  grafana_manifests = split("\n---\n", file("${path.module}/kubernetes/grafana/grafana.yaml"))
}

resource "k8s_manifest" "grafana_cm_addon" {
  count     = length(local.grafana_cm_manifests)
  content   = local.grafana_cm_manifests[count.index]
  namespace = var.monitoring_namespace
}

resource "k8s_manifest" "grafana_addon" {
  count      = length(local.grafana_manifests)
  content    = local.grafana_manifests[count.index]
  namespace  = var.monitoring_namespace
  depends_on = [k8s_manifest.grafana_cm_addon]
}

resource "k8s_manifest" "grafana_svc_addon" {
  content    = local.grafana_svc_manifests
  namespace  = var.monitoring_namespace
  depends_on = [k8s_manifest.grafana_addon]
}

resource "k8s_manifest" "grafana_dp_addon" {
  content    = local.grafana_dp_manifests
  namespace  = var.monitoring_namespace
  depends_on = [k8s_manifest.grafana_addon]

}

