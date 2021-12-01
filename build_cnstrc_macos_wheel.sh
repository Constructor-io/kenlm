./build_cnstrc_wheel.sh

version=`sed -n 's/^\s*version='\''\(.*\)'\'',$/\1/p' setup.py`

# repair wheels to have embedded libraries
# TODO: check the file name on macos...
delocate-wheel -w wheels/macos wheels/cnstrc_kenlm-$version-cp38-cp38-macosx_x86_64.whl
