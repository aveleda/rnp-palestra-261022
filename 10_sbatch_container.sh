#!/bin/bash
# ============================================================================
# PyTorch + Pyxis/Enroot - container options on the #SBATCH header
# ----------------------------------------------------------------------------
# Here the container wraps the WHOLE batch script: every command in the script
# runs inside the container. Simpler when the entire job runs in one container.
#
# NOTE: #SBATCH support for --container-* depends on the Pyxis/Slurm version.
# Confirm with:   sbatch --help | grep -i container
# If the flags do NOT appear there, use the srun variant instead.
# ============================================================================
#SBATCH --job-name=pt-sbatch
#SBATCH --partition=gpuq
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=00:30:00
#SBATCH --output=%x-%j.out
#SBATCH --container-image=nvcr.io/nvidia/pytorch:26.09-py3
#SBATCH --container-mounts=/scratch:/scratch
#SBATCH --container-workdir=/scratch

# Everything below already runs INSIDE the container.
echo "=== Inside the container ==="
date +%T
hostname
echo "Job ${SLURM_JOB_ID}"

# Confirm we really are in the container image (should be the NGC PyTorch env)
python3 --version
nvidia-smi

echo ""
echo "=== Running the training script ==="
cd $SLURM_SUBMIT_DIR
python3 pytorch_test.py

echo "end"
