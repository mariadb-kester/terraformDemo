terraform {

  required_version = "= 1.3.2"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.3.0"
    }
  }
}

provider "digitalocean" {
  alias = "terraform-runner"
  token = var.demo_digital_ocean_token
}
