.SHELL := /usr/bin/bash

# ############################################################################################################

export TF_IN_AUTOMATION ?= true
export TF_LOG ?= TRACE
export TF_LOG_PATH ?= /tmp/$(shell basename $$PWD)-$@-$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# ############################################################################################################

prepare-mac: clear initialise-mac

prepare-linux: clear initialise-linux


k8s-configure:
	echo 1

initialise-mac:
	make --version || brew install make
	terraform --version || brew terraform
	helm version || brew helm
	git --version || brew install git
	gunzip --version || brew install gunzip
	kubectl version || brew install kubectl
	doctl version || brew install doctl
	mariadb --version || brew install mysql-client
	pv --version || brew install pv
	pre-commit --version || brew install pre-commit
	pre-commit install
	chmod 777 ./bin/circleci_configure_project.sh

initialise-linux:
	make --version || brew install make
	terraform --version || brew terraform
	helm version || brew helm
	git --version || brew install git
	kubectl version || brew install kubectl
	doctl version || brew install doctl
	pre-commit --version || brew install pre-commit
	pre-commit install
	yum install -y gunzip
	yum install -y mariadb-client
	yum install -y pv
	chmod 777 ./bin/circleci_configure_project.sh

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


circleci-configure-projects:
	./bin/circleci_configure_project.sh

initialise-helm:
	helm repo add https://charts.helm.sh/stable
	helm repo update