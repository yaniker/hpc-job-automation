import itertools

# This is a TEMPLATE script to generate parameter combinations for your jobs.
# REPLACE the example parameters and logic below with your own.

# Example parameters (edit these)
param1 = ["value1", "value2"]
param2 = ["optionA", "optionB"]

# Example: Generate combinations (modify this logic)
params_list = []
for p1, p2 in itertools.product(param1, param2):
    params = f"{p1} {p2}"
    params_list.append(params)

# Write to params.txt (one parameter set per line)
with open("params.txt", "w") as f:
    for params in params_list:
        f.write(params + "\n")

print(f"Generated {len(params_list)} tasks")