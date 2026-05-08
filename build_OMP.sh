#!/bin/bash
#SBATCH -J Heme_build
#SBATCH -p iris
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 0:30:00
#SBATCH -o build_%j.out

source /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure/env.sh

cd /global/exafs/users/rdmaworkshop10/lc/HemeLB/optimized/HemePure
bash IntelBuild_OMP.sh