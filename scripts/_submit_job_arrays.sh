#!/bin/bash
# Change based on your shell. (e.g., Bash, C, ZSH etc.)

# Source the configuration file
source config.txt

# Calculate TOTAL_TASKS dynamically
TOTAL_TASKS=$(wc -l < _params.txt)

_next_task_id=1
_submitted_not_in_queue=0

while [ $_next_task_id -le $TOTAL_TASKS ]; do
    # Check current job queue
    CURRENT_JOBS=$(squeue -u $USER -h | wc -l)
    adjusted_current_jobs=$((CURRENT_JOBS + _submitted_not_in_queue))
    max_possible=$((MAX_SUBMIT - adjusted_current_jobs))

    if [ $max_possible -le 0 ]; then
        echo "Queue full. Waiting for $SLEEP_DURATION seconds... (Current: $adjusted_current_jobs, Max: $MAX_SUBMIT)"
        sleep $SLEEP_DURATION
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