#!/bin/bash
#SBATCH -J Heme_OMP_6p_9t  
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 6                    # 6进程（rank0 + 5计算）
#SBATCH -t 4:00:00
#SBATCH -o log_%j.out
#SBATCH --exclusive

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

BASE=/global/exafs/users/rdmaworkshop10/lc/HemeLB
EXE=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/src/build_PP_Benchmark/hemepure
INPUT=$BASE/Aneurysm-VIRTUAL/input_PP.xml
OUT=/global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/result/OMP_6p_9t

rm -rf $OUT

# 5计算进程 × 9线程 = 45线程
# 49M sites / 5 / 9 = 1.09M sites/线程（接近原始883K）
export OMP_NUM_THREADS=9
export OMP_PROC_BIND=close  
export KMP_AFFINITY=compact,1,0

mpirun -np 6 \
  -genv I_MPI_PIN_DOMAIN=numa \
  -genv I_MPI_PIN_ORDER=compact \
  -genv OMP_NUM_THREADS=9 \
  $EXE -in $INPUT -out $OUT