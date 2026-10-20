#!/bin/bash
#SBATCH --job-name=mpi
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --time=00:05:00
#SBATCH --output=%x-%j.out
# Exercício 8 — MPI com srun (ajuste o módulo e o plugin MPI ao seu cluster)
# Compile antes, no login node:  module load OpenMPI && mpicc -o mpi_hello 08_mpi_hello.c
export OMPI_MCA_btl="^openib"
module load openmpi4/gcc
srun --mpi=pmix ./mpi_hello
