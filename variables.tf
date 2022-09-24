variable "monitoring_namespace" {
  description = "Namespace name"
  type        = string
  default     = "monitoring-system"
}

variable "create_monitoring_namespace" {
  description = "Create namespace or use existing one"
  type        = bool
  default     = true
}

variable "grafana_subpath" {
  description = "Grafana subpath"
  type        = string
  default     = ""
}

variable "grafana_container_port" {
  description = "grafana container port"
  type        = number
  default     = 3000
}

variable "grafana_svc_port" {
  description = "grafana service port"
  type        = number
  default     = 3000
}

variable "grafana_svc_annotations" {
  description = "Map of string(string) containing a set of annotations to add to the grafana's service"
  type        = map(string)
  default = {
    "cloud.google.com/load-balancer-type" = "Internal"
  }
}

variable "grafana_configmaps" {
  description = "Map of configmaps for grafana dasboard"
  type        = map(any)
  default     = {}
}

variable "grafana_service_type" {
  description = "Service type for the grafana"
  type        = string
  default     = "ClusterIP"

  validation {
    condition     = contains(["ClusterIP", "LoadBalancer", "NodePort"], var.grafana_service_type)
    error_message = "Allowed values for grafana_service_type are \"ClusterIP\", \"LoadBalancer\", or \"NodePort\"."
  }
}

variable "prometheus_operator_log_level" {
  description = "Log level for prometheus operator"
  type        = string
  default     = "info"
}

variable "prometheus_operator_watched_namespaces" {
  description = "List of namespaces watched by the operator"
  type        = list(string)
  default     = []
}

variable "prometheus_operator_release_name" {
  description = "Release name for the prometheus operator"
  type        = string
  default     = "prometheus"
}

variable "prometheus_resource_instance_name" {
  description = "Name of the prometheus resource instance"
  type        = string
  default     = "prometheus"
}

variable "prometheus_resource_log_level" {
  description = "Log level for prometheus resource instance"
  type        = string
  default     = "info"
}

variable "pod_monitor_match_label_selector" {
  description = "Map for label selector used to select pod to watch"
  type        = map(string)
  default     = {}
}

variable "service_monitor_match_label_selector" {
  description = "Map for label selector used to select service monitors to watch"
  type        = map(string)
  default     = {}
}

variable "rule_match_label_selector" {
  description = "Map for label selector used to select prometheus rules to watch"
  type        = map(string)
  default     = {}
}

variable "alert_managers" {
  description = "List of service for alerts management"
  type = list(object({
    namespace = string,
    name      = string,
    port      = string
  }))
  default = []
}

variable "kubernetes_node_selector" {
  description = "Node selector to control where pods are deployed"
  type        = map(string)
  default     = {}
}

variable "prometheus_stack_config" {
  description = "prometheus stack chart helm configuration"
  type        = map(string)
  default     = {}
}
