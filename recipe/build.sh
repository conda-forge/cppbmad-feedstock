#!/bin/bash

export ACC_ROOT_DIR=$BUILD_PREFIX

export FFLAGS="${FFLAGS} -I${PREFIX}/include/bmad"

# Note: stubs are generated in the upstream repo, we don't need to regenerate
# them here (I hope).
cmake -S . -B build ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_PYBMAD=ON \
  -DSKBUILD=OFF \
  -DSTUBGEN=OFF \
  -DPython_EXECUTABLE="$PYTHON" \
  -DVERSION_INFO="${PKG_VERSION}"

cmake --build build -j${CPU_COUNT}
cmake --install build

echo "Moving python package from $PREFIX/pybmad to $SP_DIR/pybmad"
mkdir -p $SP_DIR
mv $PREFIX/pybmad $SP_DIR/
