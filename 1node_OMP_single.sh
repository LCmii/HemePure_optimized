#!/bin/bash
#SBATCH -J Heme_OMP_56t_n1_p1
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 1                    # 1 MPI进程（单节点，现在rank0也参与计算）
#SBATCH --ntasks-per-core=1
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_OMP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/omp_single

rm -rf $OUT

# ======================== 单节点全OMP并行（修改后） ========================
# 关键设计（修改后）：
#   - 1 MPI进程（rank0也参与计算）
#   - 56 OMP线程（用满56核）
#   - 特点：单节点计算，无MPI通信开销（适合小规模问题）

export OMP_NUM_THREADS=56
export OMP_PROC_BIND=close
export OMP_PLACES=slots
export OMP_STACKSIZE=64M
export KMP_AFFINITY=compact,1,0

# 单进程运行
mpirun -np 1 \
  -genv I_MPI_PIN=0 \
  $EXE -in $INPUT -out $OUT