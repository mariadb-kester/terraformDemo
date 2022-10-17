terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.0"
    }
  }
}
