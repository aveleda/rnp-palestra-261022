#!/bin/bash
#SBATCH --job-name=apptainer
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --output=%x-%j.out
# Exercício 10 — Apptainer
# Antes, no login node:  apptainer pull lolcow.sif docker://godlovedc/lolcow
srun apptainer exec lolcow.sif cowsay "Rodando em $(hostname) no job $SLURM_JOB_ID"
srun apptainer exec lolcow.sif cat /etc/os-release
