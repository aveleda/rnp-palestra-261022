# Laboratório — Slurm para Usuários

Roteiro prático que acompanha a palestra. Os scripts deste diretório são **exemplos ilustrativos**
montados a partir da documentação oficial do Slurm (versão 26.05).
Adapte a partição, a conta e os módulos ao seu cluster.

---

## 0. Preparação

```bash
sinfo --version
sinfo -s
scontrol show partition gpuq
```

**Perguntas:** qual é a partição padrão (marcada com `*`)? Qual o `MaxTime` dela? Existe
`DefMemPerCPU`/`DefMemPerNode`? (`scontrol show config | grep -i mem`)

---

## 1. Primeiro job — `01_hello.sh`

```bash
sbatch 01_hello.sh
squeue -u $USER
scontrol show job <jobid>
cat hello-<jobid>.out
```

1. Identifique no `scontrol show job` os campos `JobState`, `Partition`, `TimeLimit`, `NumCPUs`.
2. Submeta de novo mudando o nome **pela linha de comando**: `sbatch -J outro 01_hello.sh`.
   Qual nome de arquivo de saída foi gerado? Por quê?
3. Rode `sbatch --test-only 01_hello.sh` e observe a estimativa de início.

---

## 2. Steps — `02_steps.sh`

```bash
sbatch 02_steps.sh
squeue -s -u $USER          # steps em execução
sacct -j <jobid> --format=jobid,jobname,elapsed,ntasks,state
```

1. Quantos steps aparecem no `sacct`? Quais nomes (`.batch`, `.extern`, `.0`, `.1` …)?
2. Remova `--exact` das três linhas com `&` e compare o tempo total (`Elapsed`) do job.

---

## 3. Tempo, sinais e TIMEOUT — `03_timeout.sh`

```bash
sbatch 03_timeout.sh
# aguarde ~2 min
cat timeout-<jobid>.out
ls checkpoint.*
sacct -j <jobid> -o JobID,State,Elapsed,Timelimit
```

1. Em que horário o `USR1` chegou, relativo ao início? (Lembre: pode chegar até 60 s antes.)
2. Qual o estado final do job?

---

## 4. Job array — `04_array.sh` + `entradas.txt`

```bash
mkdir -p logs
sbatch 04_array.sh
squeue -u $USER          # pendentes agrupados
squeue -u $USER -r       # um por linha
```

1. Quantos elementos rodam ao mesmo tempo? Por quê?
2. Cancele só os elementos 15 a 20: `scancel <jobid>_[15-20]`.
3. Altere o limite de concorrência: `scontrol update JobId=<jobid> ArrayTaskThrottle=10`.
4. Liste todos os elementos no `sacct`: `sacct -j <jobid> -X -o JobID,State,Elapsed`.

---

## 5. Pipeline com dependências — `05_pipeline.sh`

```bash
bash 05_pipeline.sh
watch -n 5 squeue -u $USER -o '"%.12i %.10j %.8T %.20R"'
```

1. Observe o reason `Dependency` nos jobs pendentes.
2. Qual elemento de `pos` começa primeiro? (`aftercorr`)
3. Modifique um `pre` para falhar (`exit 1`) e veja o que acontece com o `fim` (`DependencyNeverSatisfied`).

---

## 6. MPI — `06_mpi_hello.c` + `06_mpi.sh`

```bash
srun --mpi=list                         # plugins disponíveis
module load OpenMPI                     # ou o módulo MPI do seu site
mpicc -o mpi_hello 06_mpi_hello.c
sbatch 06_mpi.sh
```

1. A saída mostra 8 ranks em 2 nós?
2. Troque `--mpi=pmix` por `--mpi=pmi2` (se disponível). Funciona?
3. Rode interativamente: `salloc -N2 --ntasks-per-node=2 -t 10` e `srun ./mpi_hello`.

---

## 7. GPU — `07_gpu.sh`

```bash
sinfo -o "%P %G"                         # partições com GRES
sbatch -p gpuq 07_gpu.sh
```

1. Cada task enxerga qual `CUDA_VISIBLE_DEVICES`? E o `nvidia-smi -L`?
2. Compare `SLURM_JOB_GPUS` (IDs globais) com `CUDA_VISIBLE_DEVICES`.

---

## 8. Pyxis — `08_pyxis.sh`

```bash
srun --help | grep container-image      # o cluster tem Pyxis?
sbatch 08_pyxis.sh
```

1. Compare o `PRETTY_NAME` dentro e fora do container.
2. Use `--container-name` para instalar um pacote em um step e reutilizá-lo no step seguinte.

---

## 9. Container (srun) - `09_srun_container.sh`

```bash
sbatch 09_srun_container.sh
```

---

## 10. Container (sbatch) - `10_sbatch_container.sh`

```bash
sbatch 10_sbatch_container.sh
```

---

## 11. Fechamento: contabilidade

```bash
sacct -S today -u $USER -o JobID,JobName%15,Elapsed,Timelimit,CPUTime,TotalCPU,ReqMem,MaxRSS,State,ExitCode
```

Para cada job do laboratório, responda:

- O tempo pedido foi adequado?
- A memória pedida foi adequada (`ReqMem` × `MaxRSS`)?
- As CPUs foram usadas (`TotalCPU` × `CPUTime`)?

---

### Referências

- <https://slurm.schedmd.com/documentation.html> (Slurm 26.05)
- <https://github.com/NVIDIA/pyxis> (fonte complementar)
