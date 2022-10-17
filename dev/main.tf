terraform {

  required_version = "= 1.3.2"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.3.0"
    }
    github = {
      source  = "hashicorp/github"
      version = "4.1.0"
    }
  }
}

provider "digitalocean" {
  alias = "terraform-runner"
  token = var.digital_ocean_token
}

provider "github" {
  alias = "terraform-runner"
  token = var.github_token
}

module "qtc" {
  source = "../modules/kestersMariaDBDemo"

  providers = {
    digitalocean = digitalocean.terraform-runner
    github       = github.terraform-runner
  }

  environment = "dev"
}
