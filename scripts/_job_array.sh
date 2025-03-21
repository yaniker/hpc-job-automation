#!/bin/bash

# Source the configuration file
source config.txt

#SBATCH --job-name=my_job_array
#SBATCH --time=12:00:00
#SBATCH --account=$SLURM_ACCOUNT
#SBATCH --mem=2GB
#SBATCH --output=./slurm/slurm-%A_%a.out

# Activate environment if specified
if [ -n "$ENV_ACTIVATE" ]; then
    eval "$ENV_ACTIVATE"
fi

if [ ! -f "_params.txt" ]; then
    echo "Error: _params.txt does not exist" >&2
    exit 1
fi

# Read parameters for this task from _params.txt
PARAMS=$(sed -n "${SLURM_ARRAY_TASK_ID}p" _params.txt)  # Do NOT change the name

# Run the executable with parameters
echo "Running task $SLURM_ARRAY_TASK_ID with params: $PARAMS"
$EXECUTABLE $PARAMS