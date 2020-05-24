# make sure to export DOCKER_BUILDKIT=1

FROM python AS build
COPY setup.py /project/
COPY hello /project/hello
COPY download-deps.sh /
RUN /download-deps.sh /project /wheels
RUN pip wheel /project --no-deps -w /wheels

# build packages. pinned to 1.10.2 because of a bug:
# https://github.com/jordansissel/fpm/issues/1602
FROM eclecticiq/package:1.10.2 AS pkg
COPY fpm.sh install-venv.sh ./
COPY --from=build --chown=package:package /wheels /opt/hello/wheels
RUN ./fpm.sh

# test the deb package
FROM debian:10-slim AS pkg-test-debian
RUN apt-get update
COPY --from=pkg /home/package/dist /dist
RUN apt -y install /dist/*.deb
CMD hello-world

# test the rpm package
FROM centos:7 AS pkg-test-centos
COPY --from=pkg /home/package/dist /dist
RUN yum -y install /dist/*.rpm
CMD hello-world

# run the application
FROM python:slim AS prod
COPY install-venv.sh ./
COPY --from=build /wheels /wheels
RUN VIRTUAL_ENV=/venv WHEELS_PATH=/wheels ./install-venv.sh
CMD hello-world
