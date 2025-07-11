#!/bin/bash
set -eu -o pipefail
set -x

mamba install -y ldc -p "${BUILD_PREFIX}"
DCMP=${BUILD_PREFIX}/bin/ldmd2

mkdir build
cd build
cmake -G Ninja \
    ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DBUILD_SHARED_LIBS=ON \
    -DD_COMPILER="$DCMP" \
    ..
ninja install
ldc2 -version

cd ..
rm -rf build

# If we don't do this a second time, we can end up linking to the wrong version of libphobos et al.
mkdir build
cd build
cmake -G Ninja \
    ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DBUILD_SHARED_LIBS=BOTH \
    -DD_COMPILER="${PREFIX}/bin/ldmd2" \
    ..
ninja install
ldc2 -version
