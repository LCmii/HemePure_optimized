#!/bin/bash
#SBATCH -J Heme_test_OMP_3p
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 3                    # 用3进程测试OMP版本
#SBATCH --ntasks-per-core=1
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_OMP_Benchmark/hemepure   # OMP编译版本
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/test_OMP_3p

rm -rf $OUT

export OMP_NUM_THREADS=1
export OMP_PROC_BIND=close

mpirun -np 3 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=1 \
  $EXE -in $INPUT -out $OUT