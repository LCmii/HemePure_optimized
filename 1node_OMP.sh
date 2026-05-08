#!/bin/bash
#SBATCH -J Heme_OMP_hybrid_n1_p3
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 3                    # 3 MPI进程：rank0(IO) + rank1,2(计算)
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_OMP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/omp_hybrid

rm -rf $OUT

# ======================== OMP+MPI 混合并行配置 ========================
# 3 MPI进程：1 IO + 2 计算
# 每个计算进程内部用OMP线程

export OMP_NUM_THREADS=28
export OMP_PROC_BIND=close
export OMP_PLACES=slots
export OMP_STACKSIZE=64M

# Intel MPI 绑定策略
mpirun -np 3 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=28 \
  -genv OMP_PROC_BIND=close \
  -genv OMP_PLACES=slots \
  $EXE -in $INPUT -out $OUT