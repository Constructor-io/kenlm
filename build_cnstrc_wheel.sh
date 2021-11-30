#!/bin/bash

set -e

# re-create build dir
rm -rf build && mkdir build

# build binaries in build dir
cd build && cmake .. && make -j 8 && cd ..

# copy binaries into kenlm_bin dir
cp -r build/bin kenlm_bin/

# build the cnstrc_kenlm wheels
pip wheel . -w /tmp/wheels

# repair wheels to be manylinux
auditwheel repair /tmp/wheels/cnstrc_kenlm-0.0.2-cp38-cp38-linux_x86_64.whl -w wheels/manylinux
