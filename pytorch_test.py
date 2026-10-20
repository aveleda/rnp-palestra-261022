#!/usr/bin/env python3
"""
Minimal PyTorch sanity-check / tiny training step.
Confirms CUDA/GPU is visible inside the container and runs a few
training iterations on a toy model.
"""
import os
import torch
import torch.nn as nn


def main():
    print("=" * 50)
    print(f"PyTorch version : {torch.__version__}")
    print(f"CUDA available  : {torch.cuda.is_available()}")
    if torch.cuda.is_available():
        print(f"CUDA version    : {torch.version.cuda}")
        print(f"GPU count       : {torch.cuda.device_count()}")
        for i in range(torch.cuda.device_count()):
            print(f"  GPU {i}: {torch.cuda.get_device_name(i)}")
    # Slurm context (handy for debugging allocation)
    print(f"SLURM_JOB_ID    : {os.environ.get('SLURM_JOB_ID', 'n/a')}")
    print(f"SLURM_NODEID    : {os.environ.get('SLURM_NODEID', 'n/a')}")
    print(f"Hostname        : {os.uname().nodename}")
    print("=" * 50)

    device = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"Training on: {device}")

    # Toy model + data
    model = nn.Sequential(
        nn.Linear(1024, 512),
        nn.ReLU(),
        nn.Linear(512, 10),
    ).to(device)

    x = torch.randn(256, 1024, device=device)
    y = torch.randint(0, 10, (256,), device=device)

    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)

    for step in range(20):
        optimizer.zero_grad()
        out = model(x)
        loss = criterion(out, y)
        loss.backward()
        optimizer.step()
        if step % 5 == 0:
            print(f"step {step:02d} | loss = {loss.item():.4f}")

    print("Treino concluído com sucesso.")


if __name__ == "__main__":
    main()
