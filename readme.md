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

### You!

You require a certain level of technical knowledge to complete this, as you are required to install some tools to your
computer.

The demonstration is designed to run on a MacBook or linux based computer where you have access to the internet and a
terminal, where you can execute all the commands with the required permissions.

### Third Party Accounts

You will require accounts for:

- [Github](./docs/files/github/readme.md)
- [CircleCi](./docs/files/circleci/readme.md)
- [Digital Ocean](./docs/files/digitalocean/readme.md)

[CircleCi](./docs/files/circleci/readme.md) and [Digital Ocean](./docs/files/digitalocean/readme.md) support Single Sign
On (SSO) using your GitHub account. SSO allows easy navigation between the services and allows you to link the accounts
together.

It is important to create your [Github](./docs/files/github/readme.md) account before creating the other accounts.

---

## Getting Started

Hopefully you have already created the [Third Party Accounts](#third-party-accounts) required.

You can now [fork](./docs/files/github/fork.md) the required repositories.

Once you have forked the repositories, there is a simple script to run:

    curl -L https://github.com/mariadb-kester/terraformDemo/blob/main/bin/circleci_configure_project.sh | sudo bash

This script will check out your forked projects, prompt you for some inputs and will prepare your system ready to build.

When this script runs you might need to enter your Operating System User password, you might also have to accept some
prompts with a `y` or `yes`

To make it easy, there is a `make` script to set up your laptop, this will ask you for your GitHub User Name and email
address and an Access Key for Digital Ocean.

*(note: if you are prompted for a password, it will be your computer password, this is not always clear, you might also
be prompted for some 'y' inputs)*

You are now ready to create the
[DigitalOcean infrastructure](./docs/files/digitalocean/infrastructure.md).

The next stop is to tell CircleCI to prepare to build our projects.

We need to make sure we are in the correct directory:

    cd /tmp/mariadbdemo/terraformDemo

and then we need to set up the User Name (including the < >) we have used for CircleCI

    echo "export CIRCLECI_USER=<INSERT USER NAME>" >> .env

and we need to set a [Personal Access Token](./docs/files/circleci/personaltoken.md):

    echo "export CIRCLECI_API=<INSERT ACCESS TOKEN>" >> .env

We now need to set up some additional variables

we can now use automation to configure our projects:

    make circleci-configure-projects

When you run this command, it will configure CircleCI and GitHub and this will generate some warning emails to be sent
to you.

We are required at this point to build some Docker Containers, we are building our own, as these are Enterprise
Containers are unique to us, and must be kept private. To make this easy, there is a script to do this for you. From
your terminal.

    cd /tmp/mariadbdemo/terraformDemo
    make git-prep-build

If everything has worked well, this will generate a build of MaxScale, Enterprise Server and a PHP Test App, in CircleCI
which you can check on the dashboard and will push them to the Container Registry in DigitalOcean. You can check they
are there as well.

If everything looks good, we can deploy our Database Cluster using Helm

### destroy

The destroy command will delete the infrastructure. This is important, if you have finished using it, to stop getting
charged. Clearly, do not run this until you have finished.

`make destroy-dev`

If you are running the destroy command, it will ask you to confirm by typing `yes` at the prompt.