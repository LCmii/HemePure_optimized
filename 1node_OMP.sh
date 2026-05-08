#!/bin/bash
#SBATCH -J Heme_OMP_hybrid_n1_p2
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 2                    # 2 MPI进程（每NUMA节点1个，现在都参与计算）
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
# 关键设计（修改后）：
#   - 2 MPI进程（每NUMA节点1个，现在都参与计算）
#   - 每个MPI进程内部28个OMP线程（每NUMA 28核）
#   - rank0也参与计算，同时做I/O和OMP计算

export OMP_NUM_THREADS=28
export OMP_PROC_BIND=close
export OMP_PLACES=slots
export OMP_STACKSIZE=64M

# Intel MPI 绑定策略
mpirun -np 2 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=28 \
  -genv OMP_PROC_BIND=close \
  -genv OMP_PLACES=slots \
  $EXE -in $INPUT -out $OUT