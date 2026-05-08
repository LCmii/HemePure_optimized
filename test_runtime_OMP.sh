#!/bin/bash
#SBATCH -J Heme_runtime_OMP
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 3
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
# 使用IntelBuild.sh编译的版本
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/runtime_OMP

rm -rf $OUT

# 运行时启用OMP（即使编译时没有-qopenmp）
export OMP_NUM_THREADS=28
export OMP_PROC_BIND=close
export OMP_PLACES=slots

mpirun -np 3 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=28 \
  $EXE -in $INPUT -out $OUT