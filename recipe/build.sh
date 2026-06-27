#!/bin/bash

export ACC_ROOT_DIR=$BUILD_PREFIX

export FFLAGS="${FFLAGS} -I${PREFIX}/include/bmad"

# Define base CMake arguments
CMAKE_OPTS="${CMAKE_ARGS}"

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  # Addresses this error when cross-compiling on macos:
  # CMake Error at cppbmad-pybmad_1782515104851/_build_env/share/cmake-4.3/Modules/FindPython/Support.cmake:46 (message):
  #   Python: When cross-compiling, Interpreter and/or Compiler components cannot
  #   be searched when CMAKE_CROSSCOMPILING_EMULATOR variable is not specified
  #   (see policy CMP0190).

  CMAKE_OPTS="${CMAKE_OPTS} -DCMAKE_CROSSCOMPILING_EMULATOR=env"
fi

# Note: stubs are generated in the upstream repo, we don't need to regenerate
# them here (I hope; yeah, that's right).
cmake -S . -B build ${CMAKE_OPTS} \
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
