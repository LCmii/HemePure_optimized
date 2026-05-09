#!/bin/bash
#SBATCH -J Heme_OMP_4p
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 4                    # 4进程：rank0(IO) + 3计算
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/OMP_4p_14t

rm -rf $OUT

# 4进程：rank0(IO不计算) + 3计算进程 = 3个计算
# 3计算进程 × 14线程 = 42线程（接近56核）
# 每计算进程处理：49M/3 ≈ 16M sites，但用14线程并行
# 每线程处理：16M/14 ≈ 1.1M sites（接近原始的883K）

export OMP_NUM_THREADS=14
export OMP_PROC_BIND=close
export OMP_PLACES=slots
export KMP_AFFINITY=compact,1,0
export KMP_BLOCKTIME=0

mpirun -np 4 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=14 \
  $EXE -in $INPUT -out $OUT