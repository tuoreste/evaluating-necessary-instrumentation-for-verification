# basic environment dependencies

SHELL := /bin/bash
BUILD_LOG := cover-build.log

.DEFAULT_GOAL := help

EXTERNAL_DIR := external
COVER_REPO := CoVer
BUGBENCH_REPO := mpi-bugbench

COVER_URL ?= https://github.com/tudasc/CoVer.git
BUGBENCH_URL ?= https://git-ce.rwth-aachen.de/hpc-public/mpi-bugbench.git

.PHONY: help check start sources deps build cover-source bugbench-source errors shell clean clean-all

BUILD_JOBS ?= 1

help:
	@printf '%s\n' \
	'Available commands:' \
	'	make help		Show commands' \
	'	make check		Check host requirements' \
	'	make start		Start project setup' \
	'	make sources	Clone missing external repositories'

check:
	@printf "Operating System: "; uname -s
	@for tool in git docker; do \
		if ! command -v $$tool >/dev/null 2>&1; then \
			echo "Please install $$tool"; exit 1; \
		fi; \
		echo "$$tool: installed"; \
	done
	@docker info >/dev/null 2>&1 || { \
		echo "Please start Docker"; exit 1; \
	}
	@docker buildx version >/dev/null 2>&1 || { \
		echo "Docker Buildx missing or broken."; \
		echo "Please install or repair Docker Buildx."; \
		exit 1; \
	}
	@echo "Dependencies OK"

sources:
	@missing=0; \
	if [ ! -d "$(EXTERNAL_DIR)/$(COVER_REPO)/.git" ]; then \
		echo "CoVer missing. Clone with:"; \
		echo "git clone --recurse-submodules $(COVER_URL) $(EXTERNAL_DIR)/$(COVER_REPO)"; \
		missing=1; \
	else \
		echo "CoVer: found"; \
	fi; \
	if [ ! -d "$(EXTERNAL_DIR)/$(BUGBENCH_REPO)/.git" ]; then \
		echo "MPI-BugBench missing. Clone with:"; \
		echo "git clone $(BUGBENCH_URL) $(EXTERNAL_DIR)/$(BUGBENCH_REPO)"; \
		missing=1; \
	else \
		echo "MPI-BugBench: found"; \
	fi; \
	[ $$missing -eq 0 ]
	@if git -C "$(EXTERNAL_DIR)/$(COVER_REPO)" submodule status | grep -q '^-'; then \
		echo "CoVer submodules missing. Run:"; \
		echo "git -C $(EXTERNAL_DIR)/$(COVER_REPO) submodule update --init --recursive"; \
		exit 1; \
	fi


start: build
	@echo "Environment ready."

build: check sources
	@mkdir -p docker
	@sed \
		-e 's/make -j8 install/make -j$(BUILD_JOBS) install/' \
		-e 's/--target install -j$$/--target install -j$(BUILD_JOBS)/' \
		$(EXTERNAL_DIR)/$(COVER_REPO)/Dockerfile \
		> docker/CoVer.Dockerfile
	@set -o pipefail; \
	docker buildx build --load --progress=plain \
		-t cover-lab \
		-f docker/CoVer.Dockerfile \
		$(EXTERNAL_DIR)/$(COVER_REPO) \
		2>&1 | tee $(BUILD_LOG)
	@echo "CoVer built successfully."

errors:
	@test -f $(BUILD_LOG) || { echo "No build log found."; exit 1; }
	@grep -Ein -C 3 'error|failed|killed|out of memory' $(BUILD_LOG) || true

clean:
	@if docker image inspect cover-lab:latest >/dev/null 2>&1; then \
		docker image rm cover-lab:latest; \
	else \
		echo "CoVer image already removed."; \
	fi

clean-all:
	@echo "WARNING: This will prune ALL unused Docker containers,"
	@echo "images, networks, build cache, and volumes."
	@echo "This affects ALL Docker projects, not just this project!"
	@printf "Are you sure? [y/N] "; \
	read answer; \
	if [ "$$answer" = "y" ]; then \
		docker system prune -a --volumes -f; \
	else \
		echo "Cleanup cancelled."; \
	fi

# inside the project

shell: check
	@docker run --rm -it -v "$(CURDIR):/workspace" -w /workspace cover-lab:latest bash