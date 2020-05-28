module github.com/pingcap-incubator/tidb-wasm

require (
	github.com/5kbpers/goleveldb v0.0.0-20191027000049-0ab25bae6897 // indirect
	github.com/gorilla/context v1.1.1 // indirect
	github.com/jeremywohl/flatten v0.0.0-20190921043622-d936035e55cf // indirect
	github.com/pingcap/errors v0.11.5-0.20190809092503-95897b64e011
	github.com/pingcap/log v0.0.0-20200511115504-543df19646ad
	github.com/pingcap/parser v0.0.0-20200525110646-f45c2cee1dca
	github.com/pingcap/pd v1.1.0-beta.0.20200106144140-f5a7aa985497 // indirect
	github.com/pingcap/tidb v1.1.0-beta.0.20200526100040-689a6b6439ae
	github.com/sirupsen/logrus v1.6.0
	github.com/unrolled/render v0.0.0-20180914162206-b9786414de4d // indirect
	go.uber.org/zap v1.15.0
)

go 1.13

replace github.com/pingcap/check => github.com/tiancaiamao/check v0.0.0-20191119042138-8e73d07b629d

replace github.com/coreos/go-systemd => github.com/5kbpers/go-systemd v0.0.0-20191226123609-22b03c51af0f

replace github.com/cznic/mathutil => github.com/5kbpers/mathutil v0.0.0-20200420051611-5a9b4ef9a225

replace go.etcd.io/bbolt => ./bbolt

replace github.com/cheggaaa/pb/v3 => ./pb

replace go.etcd.io/etcd => ./etcd

replace github.com/syndtr/goleveldb => ./goleveldb