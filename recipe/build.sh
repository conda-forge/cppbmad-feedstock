#!/bin/bash

export ACC_ROOT_DIR=$BUILD_PREFIX

export FFLAGS="${FFLAGS} -I${PREFIX}/include/bmad"

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # We can't create stubs when cross-compiling.
  # I'll instead make sure this is done upstream in the source repo when tagged.
  # I might switch this off for all builds, then.
  STUBGEN=OFF
else
  STUBGEN=ON
fi

cmake -S . -B build ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_PYBMAD=ON \
  -DSKBUILD=OFF \
  -DSTUBGEN="${STUBGEN}" \
  -DPython_EXECUTABLE="$PYTHON" \
  -DVERSION_INFO="${PKG_VERSION}"

cmake --build build -j${CPU_COUNT}
cmake --install build

echo "Moving python package from $PREFIX/pybmad to $SP_DIR/pybmad"
mkdir -p $SP_DIR
mv $PREFIX/pybmad $SP_DIR/
