#!/bin/sh -eu

img=tmp/hello-world-test

docker build --target=pkg-test-debian --tag=$img-debian .
docker run --rm -it $img-debian

docker build --target=pkg-test-centos --tag=$img-centos .
docker run --rm -it $img-centos
