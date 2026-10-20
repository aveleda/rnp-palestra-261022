#!/bin/bash
#SBATCH --job-name=gpu
#SBATCH --ntasks=2
#SBATCH --gpus-per-task=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:05:00
#SBATCH --output=%x-%j.out
# Exercício 9 — GPUs (use a partição de GPU do seu cluster: sbatch -p <part_gpu> 09_gpu.sh)
echo "SLURM_JOB_GPUS=$SLURM_JOB_GPUS  SLURM_GPUS_ON_NODE=$SLURM_GPUS_ON_NODE"
srun -l bash -c 'echo "$(hostname) CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES"; nvidia-smi -L'
