MAKEFILE_PATH := $(realpath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR  := $(realpath $(dir $(MAKEFILE_PATH)))

ROOT := $(realpath $(MAKEFILE_DIR)/..)

run:
	cargo build
	cd $(ROOT) && $(MAKEFILE_DIR)/target/debug/monorepo-checkhealth
