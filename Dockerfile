# make sure to export DOCKER_BUILDKIT=1

# build the application itself
FROM golang:alpine AS build
COPY hello-world.go /go/src
RUN go build -o bin/hello-world src/hello-world.go

# build packages
FROM eclecticiq/package AS pkg
COPY fpm.sh .
COPY --from=build /go/bin/hello-world .
RUN ./fpm.sh

# test the deb package
FROM debian:10-slim AS pkg-test-debian
COPY --from=pkg /home/package/dist /dist
RUN apt -y install /dist/*.deb
CMD hello-world

# test the rpm package
FROM centos AS pkg-test-centos
COPY --from=pkg /home/package/dist /dist
RUN yum -C -y install /dist/*.rpm
CMD hello-world

# run the application
FROM scratch AS prod
COPY --from=build /go/bin/hello-world /bin/
CMD ["/bin/hello-world"]
