#!/bin/bash
# ============================================================================
# PyTorch + Pyxis/Enroot - container options on the srun command
# ----------------------------------------------------------------------------
# Here the Slurm job itself runs on the host; only what srun launches runs
# inside the container. This is useful when part of the script must run on the
# host and part inside the container, or when launching several srun steps with
# different images.
# ============================================================================
#SBATCH --job-name=pt-srun
#SBATCH --partition=gpuq
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=00:30:00
#SBATCH --output=%x-%j.out

echo "=== HOST side (outside the container) ==="
date +%T
hostname
echo "Job ${SLURM_JOB_ID} starting on $(hostname)"

echo ""
echo "=== CONTAINER side (launched by srun) ==="
cd $SLURM_SUBMIT_DIR
srun \
  --container-image=nvcr.io/nvidia/pytorch:26.09-py3 \
  --container-mounts=$PWD:/scratch \
  --container-workdir=/scratch \
  python3 /scratch/pytorch_test.py

echo ""
echo "=== HOST side again ==="
date +%T
echo "end"
