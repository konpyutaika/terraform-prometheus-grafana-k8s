<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.2 |
| <a name="requirement_k8s"></a> [k8s](#requirement\_k8s) | >= 0.9.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.2 |
| <a name="provider_k8s"></a> [k8s](#provider\_k8s) | >= 0.9.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [k8s_manifest.grafana_addon](https://registry.terraform.io/providers/banzaicloud/k8s/latest/docs/resources/manifest) | resource |
| [k8s_manifest.grafana_cm_addon](https://registry.terraform.io/providers/banzaicloud/k8s/latest/docs/resources/manifest) | resource |
| [k8s_manifest.grafana_dp_addon](https://registry.terraform.io/providers/banzaicloud/k8s/latest/docs/resources/manifest) | resource |
| [k8s_manifest.grafana_svc_addon](https://registry.terraform.io/providers/banzaicloud/k8s/latest/docs/resources/manifest) | resource |
| [k8s_manifest.prometheus](https://registry.terraform.io/providers/banzaicloud/k8s/latest/docs/resources/manifest) | resource |
| [k8s_manifest.prometheus_crds](https://registry.terraform.io/providers/banzaicloud/k8s/latest/docs/resources/manifest) | resource |
| [kubernetes_cluster_role.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.monitoring_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_managers"></a> [alert\_managers](#input\_alert\_managers) | List of service for alerts management | <pre>list(object({<br>    namespace = string,<br>    name      = string,<br>    port      = string<br>  }))</pre> | `[]` | no |
| <a name="input_create_monitoring_namespace"></a> [create\_monitoring\_namespace](#input\_create\_monitoring\_namespace) | Create namespace or use existing one | `bool` | `true` | no |
| <a name="input_grafana_configmaps"></a> [grafana\_configmaps](#input\_grafana\_configmaps) | Map of configmaps for grafana dasboard | `map(any)` | `{}` | no |
| <a name="input_grafana_container_port"></a> [grafana\_container\_port](#input\_grafana\_container\_port) | grafana container port | `number` | `3000` | no |
| <a name="input_grafana_service_type"></a> [grafana\_service\_type](#input\_grafana\_service\_type) | Service type for the grafana | `string` | `"ClusterIP"` | no |
| <a name="input_grafana_subpath"></a> [grafana\_subpath](#input\_grafana\_subpath) | Grafana subpath | `string` | `""` | no |
| <a name="input_grafana_svc_annotations"></a> [grafana\_svc\_annotations](#input\_grafana\_svc\_annotations) | Map of string(string) containing a set of annotations to add to the grafana's service | `map(string)` | <pre>{<br>  "cloud.google.com/load-balancer-type": "Internal"<br>}</pre> | no |
| <a name="input_grafana_svc_port"></a> [grafana\_svc\_port](#input\_grafana\_svc\_port) | grafana service port | `number` | `3000` | no |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | Node selector to control where pods are deployed | `map(string)` | `{}` | no |
| <a name="input_monitoring_namespace"></a> [monitoring\_namespace](#input\_monitoring\_namespace) | Namespace name | `string` | `"monitoring-system"` | no |
| <a name="input_pod_monitor_match_label_selector"></a> [pod\_monitor\_match\_label\_selector](#input\_pod\_monitor\_match\_label\_selector) | Map for label selector used to select pod to watch | `map(string)` | `{}` | no |
| <a name="input_prometheus_operator_log_level"></a> [prometheus\_operator\_log\_level](#input\_prometheus\_operator\_log\_level) | Log level for prometheus operator | `string` | `"info"` | no |
| <a name="input_prometheus_operator_release_name"></a> [prometheus\_operator\_release\_name](#input\_prometheus\_operator\_release\_name) | Release name for the prometheus operator | `string` | `"prometheus"` | no |
| <a name="input_prometheus_operator_watched_namespaces"></a> [prometheus\_operator\_watched\_namespaces](#input\_prometheus\_operator\_watched\_namespaces) | List of namespaces watched by the operator | `list(string)` | `[]` | no |
| <a name="input_prometheus_resource_instance_name"></a> [prometheus\_resource\_instance\_name](#input\_prometheus\_resource\_instance\_name) | Name of the prometheus resource instance | `string` | `"prometheus"` | no |
| <a name="input_prometheus_resource_log_level"></a> [prometheus\_resource\_log\_level](#input\_prometheus\_resource\_log\_level) | Log level for prometheus resource instance | `string` | `"info"` | no |
| <a name="input_prometheus_stack_config"></a> [prometheus\_stack\_config](#input\_prometheus\_stack\_config) | prometheus stack chart helm configuration | `map(string)` | `{}` | no |
| <a name="input_rule_match_label_selector"></a> [rule\_match\_label\_selector](#input\_rule\_match\_label\_selector) | Map for label selector used to select prometheus rules to watch | `map(string)` | `{}` | no |
| <a name="input_service_monitor_match_label_selector"></a> [service\_monitor\_match\_label\_selector](#input\_service\_monitor\_match\_label\_selector) | Map for label selector used to select service monitors to watch | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_prometheus_release_name"></a> [prometheus\_release\_name](#output\_prometheus\_release\_name) | Prometheus release name |
| <a name="output_prometheus_release_namespace"></a> [prometheus\_release\_namespace](#output\_prometheus\_release\_namespace) | Prometheus namespace |
| <a name="output_wait_for_provisioned"></a> [wait\_for\_provisioned](#output\_wait\_for\_provisioned) | Addons |
<!-- END_TF_DOCS -->