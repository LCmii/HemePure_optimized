#!/bin/bash
#SBATCH -J Heme_OMP_numa2
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
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/OMP_numa2

rm -rf $OUT

# 2 NUMA节点，每节点1进程，每进程28线程（用满28核）
export OMP_NUM_THREADS=28
export OMP_PROC_BIND=close
export OMP_PLACES=slots
export KMP_AFFINITY=compact,1,0

mpirun -np 2 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=28 \
  $EXE -in $INPUT -out $OUT