SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

install: ## Requirements for use this project
	@source scripts/install && infrastructure:install

infrastructure-ic-spawn: install ## Spawn IC in infrastructure
	@source scripts/infrastructure-ic && infrastructure:ic:spawn

infrastructure-ic-destroy: install ## Destroy IC in infrastructure
	@source scripts/infrastructure-ic && infrastructure:ic:destroy

help:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'