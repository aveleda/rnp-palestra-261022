#!/bin/bash
#SBATCH --job-name=hello
#SBATCH --ntasks=1
#SBATCH --time=00:02:00
#SBATCH --output=%x-%j.out
# Exercício 1 — primeiro job (exemplo ilustrativo)
echo "Olá do nó $(hostname)"
echo "Job ID:        $SLURM_JOB_ID"
echo "Nome:          $SLURM_JOB_NAME"
echo "Nós:           $SLURM_JOB_NODELIST"
echo "Tasks:         $SLURM_NTASKS"
echo "Submetido de:  $SLURM_SUBMIT_DIR"
sleep 30
