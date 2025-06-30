#!/bin/bash

set -ex

rm -rf wheelhouse/macos

# re-create build dir
rm -rf build && mkdir build

# build binaries in build dir
cd build && CXXFLAGS=-std=c++11 cmake .. && make -j 8 && cd ..

# copy binaries into kenlm_bin dir
cp -r build/bin kenlm_bin/

# remove previous wheels
rm -rf wheelhouse/tmp/

python_versions=(3.13 3.12 3.11 3.10 3.9)

for PYTHON_VERSION in "${python_versions[@]}"; do
  export VIRTUAL_ENV="generated-venv-${PYTHON_VERSION}"
  uv venv --python ${PYTHON_VERSION} $VIRTUAL_ENV
  source $VIRTUAL_ENV/bin/activate
  uv pip install build delocate

  uv build --wheel --out-dir wheelhouse/tmp
  delocate-wheel wheelhouse/tmp/*macosx*.whl -w wheelhouse/macos
  rm -rf wheelhouse/tmp
  deactivate
  rm -rf generated-venv-*
done

