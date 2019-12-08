#!/bin/sh -eu

img=tmp/hello-world

docker build --target=prod --tag=$img .
docker run --rm -it $img
