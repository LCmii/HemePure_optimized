#!/bin/bash
#SBATCH -J Heme_OMP_2p_28t
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 2                    # 2 NUMA节点
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/OMP_2p_28t

rm -rf $OUT

# 2 NUMA × 28线程 = 56线程
# 49M sites / 56线程 = 875K sites/线程（接近原始883K！）
export OMP_NUM_THREADS=28
export OMP_PROC_BIND=close
export OMP_PLACES=slots
export KMP_AFFINITY=compact,1,0
export KMP_BLOCKTIME=0

mpirun -np 2 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=28 \
  $EXE -in $INPUT -out $OUT