module github.com/pingcap/tidb-wasm

require (
	github.com/onsi/ginkgo v1.10.3 // indirect
	github.com/onsi/gomega v1.7.1 // indirect
	github.com/pingcap/errors v0.11.5-0.20190809092503-95897b64e011
	github.com/pingcap/goleveldb v0.0.0-20191031114657-7683883cfb36 // indirect
	github.com/pingcap/parser v0.0.0-20191223023445-b93660cf3e4e
	github.com/pingcap/tidb v1.1.0-beta.0.20191223080440-db97ad9a03b9
)

go 1.13

replace github.com/pingcap/check => github.com/tiancaiamao/check v0.0.0-20191119042138-8e73d07b629d

replace github.com/coreos/go-systemd => github.com/5kbpers/go-systemd v0.0.0-20191209150347-994f05092cc6
