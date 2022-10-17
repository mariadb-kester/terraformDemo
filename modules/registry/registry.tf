resource "digitalocean_container_registry" "this" {
  name                   = "kestersmariadbdemo"
  subscription_tier_slug = "basic"
}
