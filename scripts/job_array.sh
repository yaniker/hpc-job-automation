#!/bin/bash
# Change based on your shell. (e.g., Bash, C, ZSH etc.)

#SBATCH --job-name=my_job_array
#SBATCH --time=12:00:00
#SBATCH --account=your_account_name  # REPLACE with your SLURM account
#SBATCH --mem=2GB
#SBATCH --output=./slurm/slurm-%A_%a.out

# Set your executable here (e.g., "python your_script.py")
EXECUTABLE="python your_script.py"  # REPLACE with your script

# Activate your environment (edit as needed)
# Example for Conda:
source ~/miniconda3/etc/profile.d/conda.sh
conda activate your_env_name  # REPLACE with your environment name

# Read parameters for this task from params.txt
PARAMS=$(sed -n "${SLURM_ARRAY_TASK_ID}p" params.txt) # Do NOT change the name

# Run the executable with parameters
echo "Running task $SLURM_ARRAY_TASK_ID with params: $PARAMS"
$EXECUTABLE $PARAMS