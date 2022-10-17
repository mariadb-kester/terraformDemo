resource "digitalocean_container_registry" "this" {
  name                   = "kdrDemo"
  subscription_tier_slug = "basic"
}
