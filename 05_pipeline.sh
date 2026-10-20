#!/bin/bash
# Exercício 7 — pipeline com dependências (rodar no login node: bash 07_pipeline.sh)
set -e
mkdir -p logs
PRE=$(sbatch --parsable --array=1-4 -t 2 -o logs/pre_%A_%a.out --wrap='echo pre $SLURM_ARRAY_TASK_ID; sleep 20')
POS=$(sbatch --parsable --array=1-4 -t 2 -o logs/pos_%A_%a.out -d aftercorr:$PRE --wrap='echo pos $SLURM_ARRAY_TASK_ID; sleep 10')
FIM=$(sbatch --parsable -t 2 -o logs/fim_%j.out -d afterok:$POS --wrap='echo tudo pronto')
echo "pre=$PRE pos=$POS fim=$FIM"
squeue -u "$USER" -o "%.12i %.10j %.8T %.20R"
