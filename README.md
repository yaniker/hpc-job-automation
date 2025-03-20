# HPC Job Automation

This tool simplifies submitting large numbers of jobs to an HPC cluster. It’s built for SLURM but can be adapted for other schedulers. The scripts are templates—customize them for your needs!

## Features
- Generate parameter combinations for your jobs.
- Submit job arrays in batches, respecting queue limits.
- Flexible and reusable for any script or environment.

## Prerequisites
- An HPC cluster with SLURM (or another scheduler, with tweaks).
- Python 3 (for `generate_params.py`).
- Bash.

## Inputs Needed
1. **Your Script**: The program you want to run (e.g., a Python script).
2. **Parameters**: Arguments for your script, defined in `generate_params.py`.
3. **SLURM Account**: Your account name for job submission.
4. **Resource Settings**: Time, memory, etc., in `job_array.sh`.

## Setup and Usage

### Step 1: Generate Parameters
Edit `generate_params.py` to create a `params.txt` file with your job parameters. Each line in `params.txt` is the arguments for one job.

**Example** (customize this):
```python
import itertools
param1 = ["A", "B"]
param2 = [1, 2]
with open("params.txt", "w") as f:
    for p1, p2 in itertools.product(param1, param2):
        f.write(f"{p1} {p2}\n")
```

### Step 2: Configure Job Script




**Notes**:
Currently only works with `Python` and `argparse` to import attributes to your code. Will improve its usability in the future.