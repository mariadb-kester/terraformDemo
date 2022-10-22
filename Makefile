.SHELL := /usr/bin/bash

# ############################################################################################################

export TF_IN_AUTOMATION ?= true
export TF_LOG ?= TRACE
export TF_LOG_PATH ?= /tmp/$(shell basename $$PWD)-$@-$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# ############################################################################################################

git-clone:
	mkdir -p /tmp/github.com/
	cd /tmp/github.com/
	git clone https://github.com/repos/$my_user_name/phpAppDocker
	git clone https://github.com/repos/$my_user_name/mariadbServerDocker
	git clone https://github.com/repos/$my_user_name/mariadbMaxscaleDocker
#	git clone https://github.com/repos/$my_user_name/terraformDemo
#	curl -u $my_user_name https://api.github.com/repos/$my_user_name/helmChrtsDatabaseDemo/forks -d ''

prepare-mac: clear initialise-mac

prepare-linux: clear initialise-linux
# Can only be ran once Digital Ocean Account Created
doctl-configure:
	doctl auth init -t ${DO_ACCESS_TOKEN}

k8s-configure:
	echo 1

initialise-mac:
	make --version || brew install make
	terraform --version || brew terraform
	helm version || brew helm
	git --version || brew install git
	kubectl version || brew install kubectl
#	doctl version || brew install doctl
	pre-commit --version || brew install pre-commit
	pre-commit install

initialise-linux:
	make --version || brew install make
	terraform --version || brew terraform
	helm version || brew helm
	git --version || brew install git
	kubectl version || brew install kubectl
#	doctl version || brew install doctl
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
	cd $* && \
	terraform init

# Usage: replace % with environment directory name, e.g. for rnd:
# make refresh-rnd
refresh-%:
	cd $* && \
	terraform refresh

# Usage: replace % with environment directory name, e.g. for rnd:
# make plan-rnd
# DEBUG level logs will be written to /tmp/DIRNAME-plan-ENV-TIMESTAMP
plan-%: init-% clear
	cd $* && \
	terraform plan

# Usage: replace % with environment directory name, e.g. for rnd:
# make apply-rnd
# DEBUG level logs will be written to /tmp/DIRNAME-apply-ENV-TIMESTAMP
apply-%: init-% clear
	cd $* && \
	terraform apply --auto-approve && \
	(git tag --delete "$*" || true) && \
	git tag -a "$*" -m "Tagged automatically during make-apply-$*" && \
	(git push origin --delete "$*" || true) && \
	git push origin "$*"

# Usage: replace % with environment directory name, e.g. for rnd:
# make k8s-destroy-rnd
# DEBUG level logs will be written to /tmp/DIRNAME-destroy-ENV-TIMESTAMP
destroy-%: update-tags
    (git checkout "$*" || true) && \
	cd $* && \
	terraform init && \
	terraform destroy && \
	rm -rf outputs

# Usage: replace % with environment directory name, e.g. for rnd:
# make tag-rnd
tag-%:
	(git tag --delete "$*" || true) && \
 	git tag -a "$*" -m "Tagged manually using make-tag-$*" && \
	(git push origin --delete "$*" || true) && \
	git push origin "$*"

update-tags:
	@git pull --force --tags