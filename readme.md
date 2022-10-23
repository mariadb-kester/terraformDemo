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

To create the required infrastructure on DigitalOcean, we are first going to clone your forked version of this
infrastructure.

This is so that you can execute the commands required to run the build scripts.

You need to open a terminal on your computer and run the following commands, it is important though that you clone your
repository and not mine. And please replace the <REPLACE...> with your information.

    git version || brew install git
    mkdir /tmp/mariadbdemo
    cd /tmp/mariadbdemo
    git clone https://github.com/<REPLACE WITH YOUR GITHUB USER NAME>/terraformDemo.git

The system will clone the repository to your computer:

    Cloning into 'terraformDemo'...
    remote: Enumerating objects: 55, done.
    remote: Counting objects: 100% (55/55), done.
    remote: Compressing objects: 100% (52/52), done.
    remote: Total 55 (delta 0), reused 55 (delta 0), pack-reused 0
    Receiving objects: 100% (55/55), 486.76 KiB | 236.00 KiB/s, done.

When we are here, we are going to grab the other three repositories we will need later:

    git clone https://github.com/<REPLACE WITH YOUR GITHUB USER NAME>/phpAppDocker.git
    git clone https://github.com/<REPLACE WITH YOUR GITHUB USER NAME>/mariadbMaxscaleDocker.git
    git clone https://github.com/<REPLACE WITH YOUR GITHUB USER NAME>/mariadbServerDocker.git

Now, change in to the cloned directory:

    cd /tmp/mariadbdemo/terraformDemo

And set your GitHub login information.

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

[comment]: <> (After you have created the infrastructure you are ready to configure CircleCI to build the containers that you are going)

[comment]: <> (to use within your environment. The following guide will help)

[comment]: <> (you [configure CircleCI]&#40;./docs/files/circleci/configure.md&#41; to use the DigitalOcean infrastructure.)

The next stop is to tell CircleCI to prepare to build our projects.

We need to make sure we are in the correct directory:

    cd /tmp/mariadbdemo/terraformDemo

and then we need to set up the User Name (including the < >) we have used for CircleCI

    echo "export CIRCLECI_USER=<INSERT USER NAME>" >> .env

and we need to set a [Personal Access Token](./docs/files/circleci/personaltoken.md):

    echo "export CIRCLECI_API=<INSERT ACCESS TOKEN>" >> .env

We now need to set up some additional variables

export TF_VAR_demo_digital_ocean_token=dop_v1_c0d76311d1aad05af257282a2b4bb1e466d9247c678ab0160cc9ad2802ff8595 export
CIRCLECI_API=4fec0f377a4b1d0b66537c3cbb6d57b25c5bbcfe export CIRCLECI_USER=mariadb-kester export
DO_REPO=registry.digitalocean.com/dev-kdr-demo export MARIADB_TOKEN=7b02f262-b9c8-4396-a988-21f926dda76e export
MAXSCALE_VERSION=22.08 export MARIADB_SERVER_VERSION=10.6

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