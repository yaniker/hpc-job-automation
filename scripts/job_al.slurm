#!/bin/bash

#SBATCH -t 48:00:00
#SBATCH -n 1
#SBATCH -A engineering_q
#SBATCH --mem=1GB
#SBATCH --output=./slurm_command/slurm-%A_%a.out

source ~/miniconda3/etc/profile.d/conda.sh
conda activate yanik-tfgpu

while [ $(wc -l < params_vae.txt) -gt 0 ]; do
    ./submit_job_arrays_vae.sh
    sed -i '1,999d' params_vae.txt
done

echo 'All jobs processed. Exiting job_vae.slurm
exit 0