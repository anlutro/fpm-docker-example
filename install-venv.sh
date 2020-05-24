#!/bin/sh
set -eu

: ${VIRTUAL_ENV:=/opt/hello}
: ${WHEELS_PATH:=$VIRTUAL_ENV/wheels}

# note that this depends on the system "python3" being the correct version.
# you will need to change this if your application needs a python version
# more recent than what the distro provides.
: ${PYTHON:=python3}

py_ver_tag=$($PYTHON -c 'import sys; print(sys.implementation.cache_tag)')
$PYTHON -m venv --upgrade $VIRTUAL_ENV
$VIRTUAL_ENV/bin/pip install --isolated --no-index \
    $WHEELS_PATH/*.whl \
    $WHEELS_PATH/$py_ver_tag/*.whl

# allow our hello-world CLI to be used from anywhere
ln -sf $VIRTUAL_ENV/bin/hello-world /usr/local/bin/
