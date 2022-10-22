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
well. On a Mac you can use brew to ensure your packages are updated and installed. There is a Script provided to ensure
the required elements are provided.

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

There are a couple of manual steps, to ensure Git is setup. Make sure you replace everything between the ""'s with your
information.

    git version || brew install git
    mkdir /tmp/mariadbdemo
    cd /tmp/mariadbdemo
    git clone https://github.com/mariadb-kester/terraformDemo.git
    cd /tmp/mariadbdemo/terraformDemo
	git config user.name "<REPLACE WITH YOUR GITHUB USER NAME>"
	git config user.email "<REPLACE WITH YOUR GITHUB EMAIL>"

You will now have this repository on your computer, everything else you need is scripted for you.

To make it easy, there is a `make` script to set up your laptop, this will ask you for your GitHub User Name and email
address, for a MacBook:

*(note: if you are prompted for a password, it will be your computer password, this is not always clear, you might also
be prompted for some 'y' inputs)*

    make prepare-mac

On a Linux computer:

    make prepare-linux

On a Windows computer... Good Luck!

By this point you should have:

- created the required accounts
- forked the GitHub repository
- cloned this repository
- ran the appropriate prepare command

You are now ready to create the
[DigitalOcean infrastructure](./docs/files/digitalocean/infrastructure.md).

After you have created the infrastructure you are ready to configure CircleCI to build the containers that you are going
to use within your environment. The following guide will help
you [configure CircleCI](./docs/files/circleci/configure.md) to use the DigitalOcean infrastructure.

Now that we have the infrastructure and build process ready, we can start manipulating our cluster, to do this we are
going to use helm. 