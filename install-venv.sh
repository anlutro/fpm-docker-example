#!/bin/sh
set -eu

: ${VIRTUAL_ENV:=/opt/hello}
: ${WHEELS_PATH:=$VIRTUAL_ENV/wheels}

py_ver_tag=$(python3 -c 'import sys; print(sys.implementation.cache_tag)')
python3 -m venv --upgrade $VIRTUAL_ENV
$VIRTUAL_ENV/bin/pip install --isolated --no-index \
    $WHEELS_PATH/*.whl \
    $WHEELS_PATH/$py_ver_tag/*.whl

# allow our hello-world CLI to be used from anywhere
ln -sf $VIRTUAL_ENV/bin/hello-world /usr/local/bin/
