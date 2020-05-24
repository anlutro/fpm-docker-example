# make sure to export DOCKER_BUILDKIT=1

FROM python AS build
# download wheels for dependencies for all versions we need to support (python
# 3.6 on centos, 3.7 on debian, 3.8 in our docker production image). if any of
# your dependencies *do not* provide wheels for these versions and need to
# compile code, you will have to build them yourself, in which case you'll need
# multiple build stages, one for each python version. this example only defines
# dependencies in setup.py, but it's also possible to use requirements.txt and
# constraints.txt, just like with `pip install`.
COPY setup.py /project/setup.py
RUN for pyver in 36 37 38; do \
        pip download /project --only-binary=:all: --python-version=$pyver -d /wheels/cpython-$pyver; \
    done
# build wheel for the project itself
COPY hello /project/hello
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
