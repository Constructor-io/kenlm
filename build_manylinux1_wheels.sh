#!/usr/bin/env bash
set -ex

# Install system packages required by libraries
yum install -y libunistring-devel boost-devel

# cleanup and prepare binaries
rm -rf build && mkdir build
rm -rf wheelhouse/*

cd build && cmake .. && make -j 8 && cd ..
cp -r build/bin kenlm_bin/

# Compile wheels
for PYBIN in /opt/python/cp38-cp38/bin /opt/python/cp39-cp39/bin /opt/python/cp310-cp310/bin /opt/python/cp311-cp311/bin; do
    "${PYBIN}/pip" wheel . -w /tmp/wheelhouse/ --no-deps
done

# Bundle external shared libraries into the wheels
for whl in /tmp/wheelhouse/*.whl; do
    auditwheel repair "$whl" -w wheelhouse/
done
