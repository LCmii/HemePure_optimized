#!/bin/bash
#SBATCH -J Heme_original_mon_n1_p56
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 56
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/1nodes

rm -rf $OUT

# ======================== Intel MPI 正确绑定参数（这就对了！）
mpirun -np 56 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  $EXE -in $INPUT -out $OUT
    