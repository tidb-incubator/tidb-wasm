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

CHECK_LDFLAGS += $(LDFLAGS) ${TEST_LDFLAGS}

TARGET = ""

.PHONY: wasm wasi

default: wasm wasi

wasm:
	mkdir -p wasm-dist
	# We produce main.css instead of main.wasm because many CDNs don't compress .wasm file automatically.
	GOOS=js GOARCH=wasm $(GOBUILD) -ldflags '$(LDFLAGS)' -o wasm-dist/main.css wasm/*.go
	cp "$(GOROOT)/misc/wasm/wasm_exec.js" wasm-dist/
	cp asset/favicon.ico wasm-dist/
	cp asset/*.js wasm-dist/
	sh tools/fix-wasm-size.sh

wasi:
	mkdir -p wasi-dist
	GOOS=wasi GOARCH=wasm $(GOBUILD) -ldflags '$(LDFLAGS)' -o wasi-dist/main.wasm wasi/*.go