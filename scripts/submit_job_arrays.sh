#!/bin/bash
# Change based on your shell. (e.g., Bash, C, ZSH etc.)

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 TOTAL_TASKS MAX_TASKS_PER_JOB MAX_SUBMIT JOB_SCRIPT"
    echo "  TOTAL_TASKS: Total number of tasks to run"
    echo "  MAX_TASKS_PER_JOB: Maximum tasks per job array"
    echo "  MAX_SUBMIT: Maximum concurrent jobs allowed"
    echo "  JOB_SCRIPT: Path to the SLURM job script (e.g., job_array.sh)"
    exit 1
fi

TOTAL_TASKS=$1
MAX_TASKS_PER_JOB=$2
MAX_SUBMIT=$3
JOB_SCRIPT=$4

_next_task_id=1
_submitted_not_in_queue=0

while [ $_next_task_id -le $TOTAL_TASKS ]; do
    # Check current job queue
    CURRENT_JOBS=$(squeue -u $USER -h | wc -l)
    adjusted_current_jobs=$((CURRENT_JOBS + _submitted_not_in_queue))
    max_possible=$((MAX_SUBMIT - adjusted_current_jobs))

    if [ $max_possible -le 0 ]; then
        echo "Queue full. Waiting... (Current: $adjusted_current_jobs, Max: $MAX_SUBMIT)"
        sleep 90
        _submitted_not_in_queue=0
        continue
    fi

    remaining_tasks=$((TOTAL_TASKS - _next_task_id + 1))
    if [ $MAX_TASKS_PER_JOB -lt $max_possible ]; then
        temp=$MAX_TASKS_PER_JOB
    else
        temp=$max_possible
    fi
    if [ $temp -lt $remaining_tasks ]; then
        tasks_to_submit=$temp
    else
        tasks_to_submit=$remaining_tasks
    fi

    start=$_next_task_id
    end=$((_next_task_id + tasks_to_submit - 1))
    if [ $end -gt $TOTAL_TASKS ]; then
        end=$TOTAL_TASKS
    fi

    echo "Submitting array $start-$end"
    sbatch --array=$start-$end $JOB_SCRIPT

    _next_task_id=$((end + 1))
    _submitted_not_in_queue=$((_submitted_not_in_queue + tasks_to_submit))
done