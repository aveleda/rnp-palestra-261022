#!/bin/bash
#SBATCH --job-name=timeout
#SBATCH --ntasks=1
#SBATCH --time=00:02:00
#SBATCH --signal=B:USR1@60
#SBATCH --output=%x-%j.out
# Exercício 5 — aviso antes do fim do tempo (--signal) e TIMEOUT
trap 'echo "$(date +%T) recebi USR1: salvando checkpoint..."; touch checkpoint.$SLURM_JOB_ID' USR1
echo "$(date +%T) início"
sleep 300 &
wait
# o trap interrompe o wait; esperamos de novo até o TIMEOUT
wait
