# Create a new container registry
resource "digitalocean_container_registry" "this" {
  name                   = "${var.environment}-kdr-demo"
  subscription_tier_slug = "starter"
}
