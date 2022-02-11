#!/bin/bash
set -eu -o pipefail
set -x

# https://github.com/conda-forge/llvmdev-feedstock/issues/54
#rm -rf $BUILD_PREFIX/lib/libLLVM*.a $BUILD_PREFIX/lib/libclang*.a

mamba install -y ldc -p ${BUILD_PREFIX}
find ${BUILD_PREFIX} -name ldmd2

# Build latest version
mkdir build
cd build
cmake -G Ninja \
      ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DBUILD_SHARED_LIBS=ON \
      -DD_COMPILER=${BUILD_PREFIX}/bin/ldmd2 \
      ..
ninja install
ldc2 -version

