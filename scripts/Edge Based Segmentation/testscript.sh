#!/bin/bash

#SBATCH --job-name test-script
#SBATCH --mem=4G

module load anaconda3/latest

conda activate base

USERNAME="$USER"

#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

SCRIPT_DIR="$1"

FILENAME="helloworld.py"

#PYTHON_SCRIPT="${SCRIPT_DIR}/Edge Based Segmentation/${FILENAME}"

PYTHON_SCRIPT="${SCRIPT_DIR%/}/${FILENAME}"

# PYTHON_SCRIPT="/home/users/allstaff/ling.j/trial_slurm/scripts/Edge Based Segmentation/helloworld.py"

# OUTPUT_LOCATION="/home/users/allstaff/ling.j/Scikit-Coins/scripts/Edge Based Segmentation/edge_based.png"

OUTPUT_LOCATION="$2"

/stornext/System/data/apps/anaconda3/anaconda3-latest/bin/python "$PYTHON_SCRIPT" "$OUTPUT_LOCATION"

conda deactivate

module unload anaconda3/latest

# Get the directory where the current script is located
# SCRIPT_DIR=$(dirname "$0")

# Append the Python script's name to the directory path
# PYTHON_SCRIPT="$SCRIPT_DIR/helloworld.py"

#OUTPUT_LOCATION="$1"

# python "$PYTHON_SCRIPT" > "$OUTPUT_LOCATION"

#python "$PYTHON_SCRIPT"

# echo -n "$PYTHON_SCRIPT"
#conda deactivate

#module unload anaconda3/latest
