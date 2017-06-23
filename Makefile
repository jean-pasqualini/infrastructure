SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

install: ## Requirements for use this project
	@source scripts/install && infrastructure:install

install-dev: ## Requirements for dev this project
	@source scripts/tools && check:tool:required docker
	docker pull koalaman/shellcheck

infrastructure-ic-spawn: install ## Spawn IC in infrastructure
	@source scripts/infrastructure-ic && infrastructure:ic:spawn

infrastructure-ic-destroy: install ## Destroy IC in infrastructure
	@source scripts/infrastructure-ic && infrastructure:ic:destroy

infrastructure-ic-show-ip: install ## Show ip ic
	@source scripts/infrastructure-ic && infrastructure:ic:show-ip

lint: ## Lint bash, Dockerfile, docker-compose.yml, terraform...
	@echo '---> Lint bash'
	@find . -name *.sh | xargs -I{} docker run --rm -i -w /mnt -v "${PWD}:/mnt" koalaman/shellcheck {}

packer-build: ## Packer
	@packer build -var "ssh_public_key='$(cat "${HOME}/.ssh/id_rsa.pub")'" ./packer/packer.json

help:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'