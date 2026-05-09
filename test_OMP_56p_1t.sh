#!/bin/bash
#SBATCH -J Heme_OMP_56p_1t
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 56                   # 56进程（每核1进程）
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/OMP_56p_1t

rm -rf $OUT

# 56进程×1线程（作为基线对比）
export OMP_NUM_THREADS=1

mpirun -np 56 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=1 \
  $EXE -in $INPUT -out $OUT