#!/bin/bash
#SBATCH --job-name=steps
#SBATCH --ntasks=4
#SBATCH --ntasks-per-core=1
#SBATCH --time=00:05:00
#SBATCH --output=%x-%j.out
# Exercício 2 — vários steps no mesmo job (adaptado do srun Example 7)
date +%T
#srun -n4 -l hostname
srun -n1 --exact sleep 10 &
srun -n1 --exact sleep 10 &
srun -n2 --exact sleep 10 &
wait
date +%T
echo "fim"
