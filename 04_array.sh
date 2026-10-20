#!/bin/bash
#SBATCH --job-name=array
#SBATCH --array=1-20%5
#SBATCH --ntasks=1
#SBATCH --time=00:02:00
#SBATCH --output=logs/%x_%A_%a.out
# Exercício 6 — job array (crie o diretório logs/ antes de submeter)
ENTRADA=$(sed -n "${SLURM_ARRAY_TASK_ID}p" entradas.txt)
echo "array job $SLURM_ARRAY_JOB_ID, task $SLURM_ARRAY_TASK_ID de $SLURM_ARRAY_TASK_COUNT -> $ENTRADA"
sleep $(( RANDOM % 20 + 10 ))
echo "resultado de $ENTRADA" > logs/resultado_${SLURM_ARRAY_TASK_ID}.txt
