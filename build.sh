#!/bin/sh -eu

id=hello-world-pkg
img=tmp/$id

cleanup() {
	echo "cleanup: removing docker container ..."
	docker rm -f $id || true
}
trap cleanup EXIT

echo "building docker image ..."
docker build --target=pkg --tag=$img .

echo "running docker container ..."
docker create --name=$id $img

echo "copying package files into 'dist' ..."
docker cp $id:/home/package/dist .
