#!/bin/sh -eu

out_dir=./dist
shared_args="
	--verbose
	--force
	--package=$out_dir
	--name=hello-world
	--input-type=dir
	./hello-world=/usr/bin/hello-world
"

mkdir -p $out_dir
fpm --output-type=deb $shared_args
fpm --output-type=rpm $shared_args
