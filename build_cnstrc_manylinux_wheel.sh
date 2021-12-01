./build_cnstrc_wheel.sh

# repair wheels to be manylinux
auditwheel repair wheels/cnstrc_kenlm-0.0.2-cp38-cp38-linux_x86_64.whl -w wheels/manylinux
