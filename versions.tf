terraform {
  required_providers {
    k8s = {
      version = ">= 0.9.0"
      source  = "banzaicloud/k8s"
    }
    kubernetes = {
      version = ">= 2.0.2"
      source  = "hashicorp/kubernetes"
    }
    helm = {
      version = ">= 2.0.2"
      source  = "hashicorp/helm"
    }
  }
  required_version = ">= 0.13"
}