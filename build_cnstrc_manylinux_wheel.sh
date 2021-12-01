./build_cnstrc_wheel.sh

version=`sed -n 's/^\s*version='\''\(.*\)'\'',$/\1/p' setup.py`

# repair wheels to be manylinux
auditwheel repair wheels/cnstrc_kenlm-$version-cp38-cp38-linux_x86_64.whl -w wheels/manylinux
