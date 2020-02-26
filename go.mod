module github.com/pingcap-incubator/tidb-wasm

require (
	github.com/5kbpers/go-systemd v0.0.0-20191226123609-22b03c51af0f // indirect
	github.com/onsi/ginkgo v1.10.3 // indirect
	github.com/onsi/gomega v1.7.1 // indirect
	github.com/pingcap/errors v0.11.5-0.20190809092503-95897b64e011
	github.com/pingcap/log v0.0.0-20200117041106-d28c14d3b1cd
	github.com/pingcap/parser v0.0.0-20200207090844-d65f5147dd9f
	github.com/pingcap/tidb v1.1.0-beta.0.20200212065659-23ce3b29c9da
	github.com/sirupsen/logrus v1.2.0
	github.com/struCoder/pidusage v0.1.2 // indirect
	github.com/ugorji/go/codec v0.0.0-20190204201341-e444a5086c43 // indirect
	go.uber.org/zap v1.13.0
	gopkg.in/airbrake/gobrake.v2 v2.0.9 // indirect
	gopkg.in/gemnasium/logrus-airbrake-hook.v2 v2.1.2 // indirect
)

go 1.13

replace github.com/pingcap/check => github.com/tiancaiamao/check v0.0.0-20191119042138-8e73d07b629d

replace github.com/coreos/go-systemd => github.com/5kbpers/go-systemd v0.0.0-20191226123609-22b03c51af0f

replace github.com/cznic/mathutil => github.com/5kbpers/mathutil v0.0.0-20200212065626-c4124e10c01c
