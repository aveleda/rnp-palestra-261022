#!/bin/bash
#SBATCH --job-name=pyxis
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --output=%x-%j.out
# Exercício 11 — Pyxis/Enroot (só se "srun --help | grep container-image" retornar algo)
srun grep PRETTY /etc/os-release
srun --container-image=almalinux:9 grep PRETTY /etc/os-release
srun --container-image=ubuntu:24.04 --container-mounts=$PWD:/trabalho --container-workdir=/trabalho ls -l
