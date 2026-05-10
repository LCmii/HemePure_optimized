#!/bin/bash
## HemePure OMP+MPI 混合并行编译脚本
## 功能：在原有Intel编译基础上添加OpenMP并行

set -e

#=====================
# 加载环境
#=====================
source ./env.sh

#=====================
# 编译依赖（不变）
#=====================
build_dep() {
  echo -e "\n🚀 Building dependencies..."
  cd dep
  rm -rf build && mkdir build && cd build
  cmake .. \
    -DCMAKE_C_COMPILER=${CC} \
    -DCMAKE_CXX_COMPILER=${CXX} \
    -DCMAKE_BUILD_TYPE=Release

  make -j
  cd ../../
  echo "✅ Dependencies done"
}

#=====================
# 编译主程序（与IntelBuild.sh相同）
#=====================
build_src() {
  echo -e "\n🚀 Building main HemePure..."
  cd src
  FOLDER=build_OMP
  rm -rf $FOLDER && mkdir $FOLDER && cd $FOLDER

  cmake .. \
    -DCMAKE_C_COMPILER=${CC} \
    -DCMAKE_CXX_COMPILER=${CXX} \
    -DHEMELB_USE_GMYPLUS=OFF \
    -DHEMELB_USE_MPI_WIN=OFF \
    -DHEMELB_USE_SSE3=ON \
    -DHEMELB_USE_AVX2=ON \
    -DCMAKE_CXX_FLAGS="-xHost -O3 -ip" \
    -DHEMELB_OUTLET_BOUNDARY=LADDIOLET \
    -DHEMELB_WALL_OUTLET_BOUNDARY=LADDIOLETBFL \
    -DHEMELB_USE_VELOCITY_WEIGHTS_FILE=OFF

  make -j8
  cd ../../
  echo "✅ HemePure build_OMP done"
}

#=====================
# 编译 Benchmark
#=====================
build_benchmark() {
  echo -e "\n🚀 Building Benchmark..."
  cd src
  FOLDER=build_OMP_Benchmark
  rm -rf $FOLDER && mkdir $FOLDER && cd $FOLDER

  cmake .. \
    -DCMAKE_C_COMPILER=${CC} \
    -DCMAKE_CXX_COMPILER=${CXX} \
    -DHEMELB_USE_GMYPLUS=OFF \
    -DHEMELB_USE_MPI_WIN=OFF \
    -DHEMELB_USE_SSE3=ON \
    -DHEMELB_USE_AVX2=ON \
    -DCMAKE_CXX_FLAGS="-xHost -O3 -ip"

  make -j8
  cd ../../
  echo "✅ HemePure build_OMP_Benchmark done"
}

#=====================
# 开始编译
#=====================
build_dep
build_src
build_benchmark

echo -e "\n🎉 OMP+MPI HYBRID BUILD SUCCESSFULLY"
echo "Binary location: src/build_OMP_Benchmark/hemepure"