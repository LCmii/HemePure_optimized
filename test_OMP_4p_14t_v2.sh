#!/bin/bash
#SBATCH -J Heme_OMP_4p_14t
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 4                    # 4进程
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/OMP_4p_14t_v2

rm -rf $OUT

# 修正：每线程=14，3个计算进程处理49M
# 49M / 3 / 14 = 1.17M sites/线程（接近原始883K）
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