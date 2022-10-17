# Terraform Demo to build MariaDB Enterprise in Containers

This project is designed to create a containerised Kubernetes infrastructure on DigitalOcean, and deploy the following
using automation:

- [MariaDB Enterprise Server]([https://mariadb.com])
- MaxScale
- PHP test application

For this demonstration to work, you will require various [third party accounts](#third-party-accounts).

As this is a demonstration of Enterprise MariaDB you will also require
an [Enterprise Customer Download Token](https://customers.mariadb.com/downloads/token/?_ga=2.26935487.388521418.1665738866-1398472177.1665738866)
.

---

## Terms of use

**Nothing in this demonstration is designed to be used in production and this is not supplied, supported or endorsed by
MariaDB.**
---

## Prerequisites

### Your Computer

You require a certain level of technical knowledge to complete this, as you are required to install some tools to your
computer.

The demonstration is designed to run on a MacBook, but, you can easily modify this to run from a Linux based computer as
well. On a Mac you can use brew to ensure your packages are updated and installed.

    brew upgrade
    brew update --auto-update
    brew install make terraform pre-commit git

On a Linux server, you can use your package manager. On a Windows computer... Good Luck!

### Third Party Accounts

You will require accounts for:

- [Github](./docs/files/github/readme.md)
- [CircleCi](./docs/files/circleci/readme.md)
- [Digital Ocean](./docs/files/digitalocean/readme.md)

[CircleCi](./docs/files/circleci/readme.md) and [Digital Ocean](./docs/files/digitalocean/readme.md) support Single Sign
On (SSO) using your GitHub account. SSO allows easy navigation between the services and allows you to link the accounts
together. Therefore it is important to create your [Github](./docs/files/github/readme.md) account first and you need
to [fork](./docs/files/github/fork.md) the required repositories before creating the other accounts.

---

## First Steps

DO key, run this script to create infrasturcutre (K8's cluster and repo)
have a script to install doctl - get DO key and create a env var (reanme to not collide)
then run the make files. # terraformDemo
