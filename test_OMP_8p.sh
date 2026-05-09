#!/bin/bash
#SBATCH -J Heme_OMP_8p
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 8                    # 8进程：rank0(IO) + 7计算
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/OMP_8p_7t

rm -rf $OUT

# 8进程：rank0(IO不计算) + 7计算进程 = 7个计算
# 7计算进程 × 7线程 = 49线程（接近56核）
# 每计算进程处理：49M/7 ≈ 7M sites
# 每线程处理：7M/7 ≈ 1M sites（接近原始的883K）

export OMP_NUM_THREADS=7
export OMP_PROC_BIND=close
export OMP_PLACES=slots
export KMP_AFFINITY=compact,1,0
export KMP_BLOCKTIME=0

mpirun -np 8 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=7 \
  $EXE -in $INPUT -out $OUT