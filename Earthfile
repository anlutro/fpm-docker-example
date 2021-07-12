build-binary:
    FROM golang:alpine
    COPY hello-world.go /go/src
    RUN go build -o /go/bin/hello-world src/hello-world.go
    SAVE ARTIFACT /go/bin/hello-world AS LOCAL dist/hello-world

build-image:
    FROM scratch
    COPY +build-binary /go/bin/hello-world /bin/hello-world
    CMD /bin/hello-world
    SAVE IMAGE tmp/hello-world

build-packages:
    FROM eclecticiq/package
    COPY +build-binary/hello-world ./
    RUN mkdir -p ./pkg
    ARG fpm_args="
        --verbose
        --force
        --package=./pkg
        --name=hello-world
        --input-type=dir
        ./hello-world=/usr/bin/hello-world
    "
    RUN fpm --output-type=deb $fpm_args
    RUN fpm --output-type=rpm $fpm_args
    SAVE ARTIFACT ./pkg/* AS LOCAL dist/

test-deb:
    FROM debian:10-slim
    COPY +build-packages/pkg /dist
    RUN apt -y install /dist/*.deb
    RUN hello-world

test-rpm:
    FROM centos:7
    COPY +build-packages/pkg /dist
    RUN yum -C -y install /dist/*.rpm
    RUN hello-world
