SHELL    := /bin/bash
BASE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

default: build-bundle

## Targets for building, validating and publishing bundles ##
REGISTRY ?= ghcr.io/vdice

# all-bundles loops through all items in the current directory
# and if the item is a sub-directory containing a porter.yaml file,
# runs the make target(s) provided by the first argument
define all-bundles
	@for dir in $$(ls -1 .); do \
		if [[ -e "./$$dir/porter.yaml" ]]; then \
			BUNDLE=$$dir make $(MAKE_OPTS) $(1) || exit $$? ; \
		fi ; \
	done
endef

.PHONY: build-bundle
build-bundle:
ifndef BUNDLE
	$(call all-bundles,build-bundle)
else
	@echo Building $(BUNDLE)...
	@cd $(BUNDLE) && ../bin/porter$(FILE_EXT) build
endif

.PHONY: publish-bundle
publish-bundle:
ifndef BUNDLE
	$(call all-bundles,publish-bundle)
else
	@echo Publishing $(BUNDLE)...
	@cd $(BUNDLE) && ../bin/porter$(FILE_EXT) publish --tag $(REGISTRY)/$(BUNDLE)
endif

SCHEMA_DIR         := $(BASE_DIR)/schema
SCHEMA_VERSION     := cnab-core-1.0.1
BUNDLE_SCHEMA      := bundle.schema.json
DEFINITIONS_SCHEMA := definitions.schema.json

define fetch-schema
	@mkdir -p $(SCHEMA_DIR)
	@curl -L --fail --silent --show-error -o $(SCHEMA_DIR)/$(1) \
		https://cnab.io/schema/$(SCHEMA_VERSION)/$(1)
endef

fetch-schemas: fetch-bundle-schema fetch-definitions-schema

fetch-bundle-schema:
	$(call fetch-schema,$(BUNDLE_SCHEMA))

fetch-definitions-schema:
	$(call fetch-schema,$(DEFINITIONS_SCHEMA))

VALIDATOR_IMG := vdice/cnab-validator:ajv

.PHONY: build-validator
build-validator:
	@docker build -f Dockerfile.ajv -t $(VALIDATOR_IMG) .

.PHONY: validate-bundle
validate-bundle: build-validator fetch-schemas
ifndef BUNDLE
	$(call all-bundles,validate-bundle)
else
	@echo Validating $(BUNDLE)...
	@docker run --rm \
		-v $(BASE_DIR):$(BASE_DIR) \
		-w $(BASE_DIR) \
		$(VALIDATOR_IMG) sh -c 'cd $(BUNDLE) && ajv test -s $(SCHEMA_DIR)/$(BUNDLE_SCHEMA) -r $(SCHEMA_DIR)/$(DEFINITIONS_SCHEMA) -d .cnab/bundle.json --valid'
endif

## Utility targets to download porter and mixins ##

CLIENT_PLATFORM = $(shell go env GOOS)
CLIENT_ARCH     = $(shell go env GOARCH)

ifeq ($(CLIENT_PLATFORM),windows)
FILE_EXT=.exe
else ifeq ($(RUNTIME_PLATFORM),windows)
FILE_EXT=.exe
else
FILE_EXT=
endif

PORTER_MIXINS_URL = https://cdn.porter.sh/mixins
PORTER_MIXINS     = az arm exec docker docker-compose helm kubernetes terraform
MIXIN_TAG        ?= latest

get-porter-mixins:
	@$(foreach MIXIN, $(PORTER_MIXINS), \
		bin/porter$(FILE_EXT) mixin install $(MIXIN) --version $(MIXIN_TAG) --url $(PORTER_MIXINS_URL)/$(MIXIN); \
	)

# TODO: use upstream repo for cowsay mixin once next release is out
# @bin/porter$(FILE_EXT) mixin install cowsay --version v0.1.0 --url https://github.com/carolynvs/porter-cowsay/releases/download
get-other-mixins:
	@bin/porter$(FILE_EXT) mixin install cowsay --version v0.2.0 --url https://github.com/vdice/porter-cowsay/releases/download
	@bin/porter$(FILE_EXT) mixin install helm3 --feed-url https://mchorfa.github.com/porter-helm3/atom.xml

bin/porter$(FILE_EXT):
	@mkdir -p bin
	@curl -fsSLo bin/porter$(FILE_EXT) https://cdn.porter.sh/canary/porter-$(CLIENT_PLATFORM)-$(CLIENT_ARCH)$(FILE_EXT)
	@chmod +x bin/porter$(FILE_EXT)

bin/porter-runtime:
	@curl -fsSLo bin/porter-runtime https://cdn.porter.sh/canary/porter-runtime-linux-amd64
	@chmod +x bin/porter-runtime

bootstrap: bin/porter$(FILE_EXT) bin/porter-runtime get-porter-mixins get-other-mixins

clean:
	@rm -rf bin