PROJECT=tidb-wasm

GO              := GO111MODULE=on go
GOROOT		    := $(shell go env GOROOT)
GOBUILD         := $(GO) build $(BUILD_FLAG) -tags codes
GOTEST          := $(GO) test -p $(P)

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
	GOOS=wasip1 GOARCH=wasm $(GOBUILD) -ldflags '$(LDFLAGS)' -o wasi-dist/main.wasm wasi/*.go