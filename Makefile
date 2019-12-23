PROJECT=tidb-wasm
GOPATH ?= $(shell go env GOPATH)
GOROOT ?= $(shell go env GOROOT)

# Ensure GOPATH is set before running build process.
ifeq "$(GOPATH)" ""
  $(error Please set the environment variable GOPATH before running `make`)
endif
ifeq "$(GOROOT)" ""
  $(error Please set the environment variable GOROOT before running `make`)
endif
FAIL_ON_STDOUT := awk '{ print } END { if (NR > 0) { exit 1 } }'

CURDIR := $(shell pwd)
path_to_add := $(addsuffix /bin,$(subst :,/bin:,$(GOPATH))):$(PWD)/tools/bin
export PATH := $(path_to_add):$(PATH)

GO              := GO111MODULE=on go
GOBUILD         := $(GO) build $(BUILD_FLAG) -tags codes
GOBUILDCOVERAGE := GOPATH=$(GOPATH) cd tidb-server; $(GO) test -coverpkg="../..." -c .
GOTEST          := $(GO) test -p $(P)
OVERALLS        := GO111MODULE=on overalls

PACKAGE_LIST  := go list ./...| grep -vE "cmd"
PACKAGES  := $$($(PACKAGE_LIST))
PACKAGE_DIRECTORIES := $(PACKAGE_LIST) | sed 's|github.com/pingcap/$(PROJECT)/||'
FILES     := $$(find $$($(PACKAGE_DIRECTORIES)) -name "*.go")

CHECK_LDFLAGS += $(LDFLAGS) ${TEST_LDFLAGS}

TARGET = ""

.PHONY: build clean wasm check checklist tidy

default: wasm buildsucc

buildsucc:
	@echo Build TiDB WASM successfully!

build:
	$(GOBUILD)

# Install the check tools.
check-setup:tools/bin/revive tools/bin/goword tools/bin/gometalinter tools/bin/gosec

check: fmt lint tidy check-static vet

# These need to be fixed before they can be ran regularly
check-fail: goword check-slow

fmt:
	@echo "gofmt (simplify)"
	@gofmt -s -l -w $(FILES) 2>&1 | $(FAIL_ON_STDOUT)

goword:tools/bin/goword
	tools/bin/goword $(FILES) 2>&1 | $(FAIL_ON_STDOUT)

gosec:tools/bin/gosec
	tools/bin/gosec $$($(PACKAGE_DIRECTORIES))

check-static: tools/bin/golangci-lint
	tools/bin/golangci-lint run -v --disable-all --deadline=3m \
	  --enable=misspell \
	  --enable=ineffassign \
	  $$($(PACKAGE_DIRECTORIES))

check-slow:tools/bin/gometalinter tools/bin/gosec
	tools/bin/gometalinter --disable-all \
	  --enable errcheck \
	  $$($(PACKAGE_DIRECTORIES))

lint:tools/bin/revive
	@echo "linting"
	@tools/bin/revive -formatter friendly -config tools/check/revive.toml $(FILES)

vet:
	@echo "vet"
	$(GO) vet -all $(PACKAGES) 2>&1 | $(FAIL_ON_STDOUT)

tidy:
	@echo "go mod tidy"
	./tools/check/check-tidy.sh

clean:
	$(GO) clean -i ./...
	rm -rf *.out
	rm -rf parser

wasm:
	mkdir -p dist
	# We produce main.css instead of main.wasm because many CDNs don't compress .wasm file automatically.
	GOOS=js GOARCH=wasm $(GOBUILD) -ldflags '$(LDFLAGS)' -o dist/main.css *.go
	cp "$(GOROOT)/misc/wasm/wasm_exec.js" dist/
	cp asset/favicon.ico dist/
	cp asset/*.js dist/
	sed "s/82837504/$(shell wc -c < dist/main.css)/g" asset/index.html.tpl > dist/index.html
