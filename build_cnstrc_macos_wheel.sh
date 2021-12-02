./build_cnstrc_wheel.sh

# repair wheels to have embedded libraries
delocate-wheel -w wheels/macos wheels/cnstrc_kenlm*macosx*.whl
