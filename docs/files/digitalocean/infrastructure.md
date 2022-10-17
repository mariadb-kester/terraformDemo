DO key, run this script to create infrasturcutre (K8's cluster and repo)
have a script to install doctl - get DO key and create a env var (reanme to not collide)
then run the make files. # terraformDemo


---

To create the required infrastructure on DigitalOcean, we are first going to clone your forked version of this
infrastructure.

This is so that you can execute the commands required to run the build scripts. The build scripts will also, check the
state of your cluster back in to the GitHub repository, therefore keeping track and control of the state of your
cluster.

You need to open a terminal on your computer and run the following commands, it is important though that you clone your
repository and not mine.

    cd ~
    mkdir github.com
    cd github.com
    git clone https://github.com/mariadb-kester/terraformDemo.git

**Make sure you change the `mariadb-kester` part with your own GitHub username.**

The system will clone the repository to your computer:

    Cloning into 'terraformDemo'...
    remote: Enumerating objects: 55, done.
    remote: Counting objects: 100% (55/55), done.
    remote: Compressing objects: 100% (52/52), done.
    remote: Total 55 (delta 0), reused 55 (delta 0), pack-reused 0
    Receiving objects: 100% (55/55), 486.76 KiB | 236.00 KiB/s, done.

Now, change in to the cloned directory:

    cd terraformDemo

To be able to continue you require a [DigitalOcean API Key](./apikey.md). Once you have your key you need to use this to
create a local environment variable. Replace the below (after the = and up to the ") with your own API key.

    echo "export TF_VAR_demo_digital_ocean_token=dop_v1_xxxxxxxxxx" > .env

Set up your GitHub access.

    echo "export TF_VAR_demo_github_token=" >> .env