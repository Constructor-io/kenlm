#!/usr/bin/env bash
set -ex

# Install system packages required by libraries
yum install -y libunistring-devel boost-devel

# cleanup and prepare binaries
rm -rf build && mkdir build
cd build && CXXFLAGS=-std=c++11 cmake .. && make -j 8 && cd ..
cp -r build/bin kenlm_bin/

# Compile wheels
for PYBIN in /opt/python/cp311-cp311/bin; do
    "${PYBIN}/pip" wheel . -w /tmp/wheelhouse/ --no-deps
done

# Bundle external shared libraries into the wheels
for whl in /tmp/wheelhouse/*.whl; do
    auditwheel repair "$whl" -w wheelhouse/
done
