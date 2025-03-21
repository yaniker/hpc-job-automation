#!/bin/bash

# Source the configuration file
source config.txt

#SBATCH --job-name=my_job_array
#SBATCH --time=48:00:00
#SBATCH --account=$SLURM_ACCOUNT
#SBATCH --mem=1GB
#SBATCH --output=./slurm/slurm-%A_%a.out

if [ ! -f "_params.txt" ]; then
    echo "Error: _params.txt does not exist" >&2
    exit 1
fi

# Activate environment if specified
if [ -n "$ENV_ACTIVATE" ]; then
    eval "$ENV_ACTIVATE"
fi

while [ $(wc -l < _params.txt) -gt 0 ]; do  # Do NOT change the name
    ./_submit_job_arrays.sh
    sed -i '1,999d' _params.txt
done

echo "All jobs processed. Exiting slurm_scheduler.sh"
exit 0