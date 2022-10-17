# =====================================================================================================================
# This file is responsible for installing the initial flux installation into the cluster.
# =====================================================================================================================

# Create the flux namespace
resource "kubernetes_namespace" "flux" {
  metadata {
    name = "flux"
  }
}

# Deploy the gitlab deploy key into the cluster as a secret in the flux namespace.
resource "kubernetes_secret" "flux_git_deploy_secret" {
  metadata {
    name      = "flux-git-deploy"
    namespace = "flux"
  }

  type = "Opaque"

  data = {
    identity = tls_private_key.deploy_key.private_key_pem
  }

  depends_on = [kubernetes_namespace.flux]
}

# Deploy flux into the cluster using the upstream helm chart.
resource "helm_release" "flux" {
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  version    = "1.6.0"
  name       = "flux"
  namespace  = "flux"

  set {
    name  = "git.url"
    value = "git@github.com:kesterriley/k8s-releases-qtc"
  }

  set {
    name  = "git.branch"
    value = "main"
  }

  set {
    name  = "git.path"
    value = "kustomize/${var.environment}"
  }

  set {
    name  = "git.pollInterval"
    value = "30s"
  }

  set {
    name  = "git.secretName"
    value = "flux-git-deploy"
  }

  set {
    name  = "manifestGeneration"
    value = true
  }

  set {
    name  = "registry.automationInterval"
    value = "2m"
  }

  set {
    name  = "syncGarbageCollection.enabled"
    value = true
  }

  depends_on = [
    kubernetes_namespace.flux,
    kubernetes_secret.flux_git_deploy_secret
  ]
}
