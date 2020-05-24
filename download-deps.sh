#!/bin/sh
set -eu

# download wheels for dependencies for all versions we need to support (python
# 3.6 on centos, 3.7 on debian, 3.8 in our docker production image). if any of
# your dependencies *do not* provide wheels for these versions and need to
# compile code, you will have to build them yourself, in which case you'll need
# multiple build stages, one for each python version. this example only defines
# dependencies in setup.py, but it's also possible to use requirements.txt and
# constraints.txt, just like with `pip install`.

project_dir=${1-.}
wheels_dir=${2-./wheels}
python_versions="36 37 38"

# download all version's dependencies into the same directory to prevent
# downloading the same wheel twice if the wheel is version-independent
for pyver in $python_versions; do
    pip download $project_dir --only-binary=:all: --python-version=$pyver -d $wheels_dir
done

# move version-specific wheels into individual directories
for pyver in $python_versions; do
	# cpython-$pyver corresponds to sys.implementation.cache_tag which we will use
	# later to make sure we don't try to install incompatible wheels
	cp_wheels_dir="$wheels_dir/cpython-$pyver"
	mkdir $cp_wheels_dir
	find $wheels_dir | grep -F -- "-cp$pyver-" | xargs -I% -n1 mv % $cp_wheels_dir
done
