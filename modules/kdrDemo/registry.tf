resource "digitalocean_container_registry" "this" {
  name                   = "${var.environment}-kdr-demo"
  subscription_tier_slug = "basic"
}
