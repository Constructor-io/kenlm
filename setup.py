from setuptools import setup, Extension
import glob
import platform
import os
import sys
import re
import shutil

#Does gcc compile with this header and library?
def compile_test(header, library):
    dummy_path = os.path.join(os.path.dirname(__file__), "dummy")
    command = "bash -c \"g++ -include " + header + " -l" + library + " -x c++ - <<<'int main() {}' -o " + dummy_path + " >/dev/null 2>/dev/null && rm " + dummy_path + " 2>/dev/null\""
    return os.system(command) == 0

max_order = "6"
is_max_order = [s for s in sys.argv if "--max_order" in s]
for element in is_max_order:
    max_order = re.split('[= ]',element)[1]
    sys.argv.remove(element)

FILES = glob.glob('util/*.cc') + glob.glob('lm/*.cc') + glob.glob('util/double-conversion/*.cc') + glob.glob('python/*.cc')
FILES = [fn for fn in FILES if not (fn.endswith('main.cc') or fn.endswith('test.cc'))]

if platform.system() == 'Linux':
    LIBS = ['stdc++', 'rt']
elif platform.system() == 'Darwin':
    LIBS = ['c++']
else:
    LIBS = []

#We don't need -std=c++11 but python seems to be compiled with it now.  https://github.com/kpu/kenlm/issues/86
ARGS = ['-O3', '-DNDEBUG', '-DKENLM_MAX_ORDER='+max_order, '-std=c++11']

#Attempted fix to https://github.com/kpu/kenlm/issues/186 and https://github.com/kpu/kenlm/issues/197
if platform.system() == 'Darwin':
    ARGS += ["-stdlib=libc++", "-mmacosx-version-min=10.7"]

if compile_test('zlib.h', 'z'):
    ARGS.append('-DHAVE_ZLIB')
    LIBS.append('z')

if compile_test('bzlib.h', 'bz2'):
    ARGS.append('-DHAVE_BZLIB')
    LIBS.append('bz2')

if compile_test('lzma.h', 'lzma'):
    ARGS.append('-DHAVE_XZLIB')
    LIBS.append('lzma')


LIBRARY_DIRS = []
LINK_LIBRARIES = [
    'boost'
]

# clang doesn't have static link flag, so in order to enforce static link
# we are copying lib*.a files to dedicated dir
if platform.system() == 'Darwin':
    mac_os_static_libs_dir = 'mac_os_static_libs'
    LIBRARY_DIRS.append(mac_os_static_libs_dir)

    if not os.path.exists(mac_os_static_libs_dir):
        os.makedirs(mac_os_static_libs_dir)

    for lib in LINK_LIBRARIES:
        lib_file_name = 'lib{}.a'.format(lib)
        src_file = os.path.join('/usr/local/lib', lib_file_name)
        dst_file = os.path.join(mac_os_static_libs_dir, lib_file_name)
        shutil.copyfile(src_file, dst_file)
        LIBS.append(lib)

ext_modules = [
    Extension(name='kenlm',
        sources=FILES + ['python/kenlm.cpp'],
        language='C++',
        include_dirs=['.'],
        libraries=LIBS,
        library_dirs=LIBRARY_DIRS,
        extra_compile_args=ARGS)
]

setup(
    name='cnstrc_kenlm',
    ext_modules=ext_modules,
    include_package_data=True,
    version='0.0.2.dev1',
    packages=['kenlm_bin'],
    package_data={'kenlm_bin': ['bin/*']}
)
