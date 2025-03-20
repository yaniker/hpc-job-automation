#!/bin/bash
# Change based on your shell. (e.g., Bash, C, ZSH etc.)

#SBATCH --job-name=my_job_array #Name accordingly
#SBATCH --time=48:00:00 # Recommend to keep this as high as possible given the other jobs will be submitted automatically as long as this script is active.
#SBATCH --account=your_account_name  # REPLACE with your SLURM account
#SBATCH --mem=1GB # Recommended to keep low as its main function is to regulate other jobs.
#SBATCH --output=./slurm/slurm-%A_%a.out

source ~/miniconda3/etc/profile.d/conda.sh
conda activate yanik-tfgpu

while [ $(wc -l < _params.txt) -gt 0 ]; do # Do NOT change the name.
    ./submit_job_arrays.sh
    sed -i '1,999d' params.txt
done

echo 'All jobs processed. Exiting slurm_scheduler.sh
exit 0