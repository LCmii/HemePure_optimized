#!/bin/bash
#SBATCH -J Heme_test_tiny
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 2                    # 2 NUMA节点×28线程
#SBATCH -t 1:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Bifurcation-TINY/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/test_tiny_2p_28t

rm -rf $OUT

export OMP_NUM_THREADS=28
export OMP_PROC_BIND=close
export KMP_AFFINITY=compact,1,0

mpirun -np 2 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=28 \
  $EXE -in $INPUT -out $OUT