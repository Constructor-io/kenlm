#!/usr/bin/env bash
set -eox

# Install system packages required by libraries
yum install -y libunistring-devel boost-devel wget xz-devel make gcc zlib-devel bzip2-devel cmake

cd /

# Install Eigen
wget https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.zip
unzip eigen-3.3.9.zip
cd /eigen-3.3.9
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=/installed/eigen3
make install

cd /io

# re-create build dir
rm -rf build && mkdir build

# build binaries in build dir
cd build
cmake ../ -DEigen3_DIR=/installed/eigen3/share/eigen3  && make -j 8 && cd ..

# copy binaries into kenlm_bin dir
cp -r build/bin kenlm_bin/
# remove previous wheels
rm -rf wheels/tmp

# Compile wheels
for PYBIN in /opt/python/cp38-cp38/bin /opt/python/cp39-cp39/bin /opt/python/cp310-cp310/bin; do
    "${PYBIN}/pip" wheel . -w /tmp/wheelhouse/ --no-deps
done

# Bundle external shared libraries into the wheels
for whl in /tmp/wheelhouse/*.whl; do
    auditwheel repair "$whl" -w wheelhouse/
done
