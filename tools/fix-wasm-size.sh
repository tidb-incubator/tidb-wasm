#! /bin/sh

sed "s/82837504/$(wc -c < wasm-dist/main.css)/g" asset/index.html.tpl > wasm-dist/index.html
