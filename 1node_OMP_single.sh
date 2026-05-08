#!/bin/bash
#SBATCH -J Heme_OMP_n1_p56
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 56                   # 56 MPI进程（原始配置）
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_OMP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/omp_56

rm -rf $OUT

# ======================== 56进程配置（原始OMP优化） ========================
# 使用56个MPI进程，每个1线程（原始架构）
# 或者可以用OMP线程：每个进程内部可以用28线程=2NUMA

export OMP_NUM_THREADS=1
export OMP_PROC_BIND=close
export OMP_PLACES=slots
export OMP_STACKSIZE=64M
export KMP_AFFINITY=compact,1,0

# Intel MPI 绑定
mpirun -np 56 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  $EXE -in $INPUT -out $OUT