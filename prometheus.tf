# Deploy CRDs
resource "k8s_manifest" "prometheus_crds" {
  for_each = fileset("${path.module}/kubernetes/prometheus/crds/0.58.0/", "*")
  content  = templatefile("${path.module}/kubernetes/prometheus/crds/0.58.0/${each.value}", {})
}

resource "kubernetes_cluster_role" "prometheus" {
  metadata {
    name = "prometheus-${var.monitoring_namespace}"
  }

  rule {
    api_groups = ["", ]
    resources  = ["nodes", "services", "endpoints", "pods", ]
    verbs      = ["get", "watch", "list", ]
  }

  rule {
    api_groups = ["", ]
    resources  = ["configmaps", ]
    verbs      = ["get", ]
  }

  rule {
    non_resource_urls = ["/metrics", ]
    verbs             = ["get", ]
  }
}

# Create service account for prometheus
resource "kubernetes_service_account" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = var.monitoring_namespace
  }
  automount_service_account_token = true
}

# Binding prometheus cluster role, with the prometheus Service account.
resource "kubernetes_cluster_role_binding" "prometheus" {
  metadata {
    name = "prometheus-${var.monitoring_namespace}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.prometheus.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.prometheus.metadata[0].name
    namespace = kubernetes_service_account.prometheus.metadata[0].namespace
  }
}

locals {
  watched_namespaces = concat(var.prometheus_operator_watched_namespaces, [var.monitoring_namespace])
}

# helm release
resource "helm_release" "prometheus" {
  name       = var.prometheus_operator_release_name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.monitoring_namespace
  version    = "39.9.0"

  dynamic "set" {
    for_each = var.prometheus_stack_config
    content {
      name  = set.key
      value = set.value
    }
  }

  set {
    name  = "prometheusOperator.createCustomResource"
    value = "false"
  }

  set {
    name  = "prometheusOperator.logLevel"
    value = var.prometheus_operator_log_level
  }

  set {
    name  = "prometheusOperator.alertmanagerInstanceNamespaces"
    value = "{${join(",", local.watched_namespaces)}}"
  }

  set {
    name  = "prometheusOperator.namespaces.additional"
    value = "{${join(",", local.watched_namespaces)}}"
  }

  set {
    name  = "prometheusOperator.prometheusInstanceNamespaces"
    value = "{${join(",", local.watched_namespaces)}}"
  }

  set {
    name  = "prometheusOperator.thanosRulerInstanceNamespaces"
    value = "{${join(",", local.watched_namespaces)}}"
  }

  set {
    name  = "defaultRules.enable"
    value = "false"
  }

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }
  set {
    name  = "grafana.enabled"
    value = "false"
  }
  set {
    name  = "kubeApiServer.enabled"
    value = "false"
  }
  set {
    name  = "kubelet.enabled"
    value = "false"
  }
  set {
    name  = "kubeControllerManager.enabled"
    value = "false"
  }
  set {
    name  = "coreDNS.enabled"
    value = "false"
  }
  set {
    name  = "kubeEtcd.enabled"
    value = "false"
  }
  set {
    name  = "kubeScheduler.enabled"
    value = "false"
  }
  set {
    name  = "kubeProxy.enabled"
    value = "false"
  }
  set {
    name  = "kubeStateMetrics.enabled"
    value = "false"
  }
  set {
    name  = "prometheus.enabled"
    value = "false"
  }

  depends_on = [k8s_manifest.prometheus_crds]
}

locals {
  prometheus = templatefile(
    "${path.module}/kubernetes/prometheus/prometheus.yaml", {
      pod-monitor-match-label-selector     = var.pod_monitor_match_label_selector
      alert-managers                       = var.alert_managers
      service-monitor-match-label-selector = var.service_monitor_match_label_selector
      rule-match-label-selector            = var.rule_match_label_selector
      service-account-name                 = kubernetes_service_account.prometheus.metadata[0].name
      instance-name                        = var.prometheus_resource_instance_name
      log-level                            = var.prometheus_resource_log_level
      kubernetes_node_selector             = var.kubernetes_node_selector
    }
  )
}

resource "k8s_manifest" "prometheus" {
  content    = local.prometheus
  namespace  = var.monitoring_namespace
  depends_on = [helm_release.prometheus]
}