resource "digitalocean_kubernetes_cluster" "this" {
  name          = "${var.environment}-kdr-demo"
  region        = "lon1"
  auto_upgrade  = true
  surge_upgrade = true
  version       = "1.25.4-do.0"
  tags          = [var.environment]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }
}

resource "digitalocean_container_registry" "this" {
  name                   = "${var.environment}-kdr-demo"
  subscription_tier_slug = "basic"

  depends_on = [
    digitalocean_kubernetes_cluster.this
  ]
}