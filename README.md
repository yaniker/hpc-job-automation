# HPC Job Automation

I have developed this tool several years ago to automate job submission to any HPC I work with. What it does is to continously send new jobs via SLURM to the HPC while observing the fair usage limitations. It simplifies running your script with different sets of parameters by generating parameter combinations and managing job submissions in a controlled manner.

## Prerequisites

Before using this tool, ensure you have the following:

- **Access to an HPC cluster with SLURM**: You need permission to submit jobs to a SLURM-based high-performance computing cluster.
- **Python 3**: Required for generating job parameters.
- **Bash**: Needed to execute the provided scripts.

## Configuration

All user-specific settings are defined in the `config.txt` file. Edit this file to specify your SLURM account, executable script, environment activation commands, and job array parameters.

### Example `config.txt`

```plaintext
# Configuration file for HPC Job Automation

# SLURM account name
SLURM_ACCOUNT=your_account_name

# Path to your executable script
EXECUTABLE="python your_script.py"

# Environment activation command (leave blank if not needed)
ENV_ACTIVATE="source ~/miniconda3/etc/profile.d/conda.sh && conda activate your_env_name"

# Job array parameters
MAX_TASKS_PER_JOB=10
MAX_SUBMIT=20

# Path to the job array script (do not change unless necessary)
JOB_SCRIPT="job_array.sh"

# Sleep duration in seconds when queue is full
SLEEP_DURATION=90
```

## Generating Parameters
The `generate_params.py` script generates a list of parameters for your jobs, which are saved in `_params.txt`. Each line in _params.txt represents the arguments for a single job.

### Example `generate_params.py`
```
import itertools

# Define your parameters here
param1 = ["value1", "value2"]
param2 = ["optionA", "optionB"]

# Generate all combinations of parameters
params_list = [f"{p1} {p2}" for p1, p2 in itertools.product(param1, param2)]

# Write parameters to _params.txt
with open("_params.txt", "w") as f:
    for params in params_list:
        f.write(params + "\n")
```

### Running the Script
Run the script to create _params.txt:
`python generate_params.py`
Edit `generate_params.py` to define your own parameters based on what your script (your_script.py) expects.

## Job Array Script
The `job_array.sh` script is pre-configured to execute your script with parameters from _params.txt. It sources settings from `config.txt`, so you typically don’t need to modify it directly. However, you may need to adjust SLURM directives (e.g., --time, --mem) in `job_array.sh` to match your job’s resource requirements.

## Scheduler Script
The slurm_scheduler.sh script oversees the submission process. It calls `submit_job_arrays.sh` to submit jobs in batches, ensuring that the limits set in `config.txt` (e.g., `MAX_SUBMIT`) are respected.

### Submitting the Scheduler
Submit the scheduler to SLURM with:
```
sbatch slurm_scheduler.sh
```

This script runs until all tasks in `_params.txt` are processed.

## Submit Job Arrays Script
The `submit_job_arrays.sh` script is an internal component called by `slurm_scheduler.sh`. It handles submitting job arrays in batches based on the settings in `config.txt`. You don’t need to interact with this script directly.

## Monitor Your Jobs
Use SLURM commands to check job status:
```
squeue -u $USER
```

## Troubleshooting
Here are some common issues and fixes:

- **Environment Not Activating**  
Double-check the `ENV_ACTIVATE` field in `config.txt`. Ensure the command works when run manually in your terminal. If no environment is needed, leave it blank.  
- **Parameter Errors**  
Inspect `_params.txt` after running `generate_params.py`. Verify that the parameters match what your script expects.  
- **SLURM Errors**  
Ensure your `SLURM_ACCOUNT` is correct and that resource requests (e.g., time, memory) in `job_array.sh` are sufficient. Check SLURM logs (e.g., slurm-<job_id>.out) for details.
