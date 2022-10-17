terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    github = {
      source = "hashicorp/github"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.0"
    }
  }
}
