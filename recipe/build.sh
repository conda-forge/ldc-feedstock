#!/bin/bash
set -eu -o pipefail

# https://github.com/conda-forge/llvmdev-feedstock/issues/54
#rm -rf $BUILD_PREFIX/lib/libLLVM*.a $BUILD_PREFIX/lib/libclang*.a

## bootstrap with 0.17.x which is the last version that doesn't require a host D compiler.
## See https://wiki.dlang.org/Building_LDC_from_source
#
#curl -sL https://github.com/ldc-developers/ldc/releases/download/v0.17.6/ldc-0.17.6-src.tar.gz | tar xz
#pushd ldc-0.17.6-src
#mkdir build
#cd build
#cmake -G Ninja \
#      -DCMAKE_BUILD_TYPE=Release \
#      -DCMAKE_INSTALL_PREFIX=$SRC_DIR/install \
#      -DCMAKE_PREFIX_PATH=$PREFIX \
#      ..
#
#ninja install
#
#popd
#rm -rf ldc-0.17.6-src ldc-0.17.6-src.tar.gz
# bootstrap with a previous ldc
mamba install ldc -p ${BUILD_PREFIX}

# Build latest version
mkdir build
cd build
cmake -G Ninja \
      ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DBUILD_SHARED_LIBS=ON \
      -DD_COMPILER=${BUILD_PREFIX}/install/bin/ldmd2 \
      ..
ninja install
ldc2 -version

