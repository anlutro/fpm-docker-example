#!/bin/sh -eu
set -eu

out_dir=./dist
shared_args="
	--verbose
	--force
	--package=$out_dir
	--name=hello-world
	--input-type=dir
	--after-install=install-venv.sh
	/opt/hello
"

mkdir -p $out_dir

# dependency package names may differ between centos and debian, therefore we
# don't define them in shared_args
fpm --output-type=deb -d python3 -d python3-venv $shared_args
fpm --output-type=rpm -d python3 $shared_args
