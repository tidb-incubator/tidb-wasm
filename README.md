# tidb-wasm

```
git clone git@github.com:pingcap/tidb-wasm.git
cd tidb-wasm
make
cd dist
python -m SimpleHTTPServer 8000
```

Don't use golang 1.13.x which has bug on WebAssembly target.
