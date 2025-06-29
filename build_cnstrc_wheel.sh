#!/bin/bash

set -e

# re-create build dir
rm -rf build && mkdir build

# build binaries in build dir
cd build && CXXFLAGS=-std=c++11 cmake .. && make -j 8 && cd ..

# copy binaries into kenlm_bin dir
cp -r build/bin kenlm_bin/

# remove previous wheels
rm -rf wheels/tmp

# build the cnstrc_kenlm wheels
pip wheel . -w wheels/tmp
