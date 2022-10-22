.SHELL := /usr/bin/bash

# ############################################################################################################

export TF_IN_AUTOMATION ?= true
export TF_LOG ?= TRACE
export TF_LOG_PATH ?= /tmp/$(shell basename $$PWD)-$@-$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
GIT_HUB_USER ?= $(shell bash -c 'read -p "GitHub User Name: " username; echo $$username')
GIT_HUB_EMAIL ?= $(shell bash -c 'read -p "GutHub E-Mail Address: " emailadd; echo $$emailadd')
# ############################################################################################################

git-credentials: clear
	@echo Username › $(GIT_HUB_USER)
	@echo Password › $(GIT_HUB_EMAIL)
	echo "export GIT_HUB_USER=$GIT_HUB_USER" >> .env
	echo "export GIT_HUB_EMAIL=$GIT_HUB_EMAIL" >> .env
	git config user.name "$GIT_HUB_USER"
	git config user.email "$GIT_HUB_EMAIL"
	git config user.name
	git config user.email

git-clone:
	mkdir -p /tmp/github.com/
	cd /tmp/github.com/
	git clone https://github.com/repos/$my_user_name/phpAppDocker
	git clone https://github.com/repos/$my_user_name/mariadbServerDocker
	git clone https://github.com/repos/$my_user_name/mariadbMaxscaleDocker
#	git clone https://github.com/repos/$my_user_name/terraformDemo
#	curl -u $my_user_name https://api.github.com/repos/$my_user_name/helmChrtsDatabaseDemo/forks -d ''


prepare-mac: clear initialise-mac install-doctl

prepare-linux: clear initialise-linux install-doctl
# Can only be ran once Digital Ocean Account Created
doctl-configure:
	doctl auth init -t ${DO_ACCESS_TOKEN}

k8s-configure:
	echo 1

install-doctl:
	wget https://github.com/digitalocean/doctl/releases/download/v1.54.0/doctl-1.54.0-linux-amd64.tar.gz
	tar xf doctl-1.54.0-linux-amd64.tar.gz
	mv doctl /usr/local/bin

initialise-mac:
	brew upgrade
	brew update --auto-update
	make --version || brew install make
	terraform --version || brew terraform
	helm version || brew helm
	git --version || brew install git
	kubectl version || brew install kubectl
	pre-commit --version || brew install pre-commit
	pre-commit install

initialise-linux:
	brew upgrade
	brew update --auto-update
	make --version || brew install make
	terraform --version || brew terraform
	helm version || brew helm
	git --version || brew install git
	kubectl version || brew install kubectl
	pre-commit --version || brew install pre-commit
	pre-commit install

run-pre-commit:
	pre-commit run --all-files

# ############################################################################################################

.PHONY: clear
clear:
	clear

# Usage: replace % with environment directory name, e.g. for rnd:
# make init-rnd
init-%:
	source .env && \
	cd $* && \
	terraform init

# Usage: replace % with environment directory name, e.g. for rnd:
# make refresh-rnd
refresh-%:
	source .env && \
	cd $* && \
	terraform refresh

# Usage: replace % with environment directory name, e.g. for rnd:
# make plan-rnd
# DEBUG level logs will be written to /tmp/DIRNAME-plan-ENV-TIMESTAMP
plan-%: init-% clear
	source .env && \
	cd $* && \
	terraform plan

# Usage: replace % with environment directory name, e.g. for rnd:
# make apply-rnd
# DEBUG level logs will be written to /tmp/DIRNAME-apply-ENV-TIMESTAMP
apply-%: init-% clear
	source .env && \
	cd $* && \
	terraform apply --auto-approve

# Usage: replace % with environment directory name, e.g. for rnd:
# make k8s-destroy-rnd
# DEBUG level logs will be written to /tmp/DIRNAME-destroy-ENV-TIMESTAMP
destroy-%:
	source .env && \
	cd $* && \
	terraform init && \
	terraform destroy && \
	rm -rf outputs
