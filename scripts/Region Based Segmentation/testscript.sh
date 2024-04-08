#!/bin/bash

#SBATCH --job-name test-script
#SBATCH --mem=4G

module load anaconda3/latest

conda activate base

SCRIPT_DIR="$1"

FILENAME="workflow1.py"

PYTHON_SCRIPT="${SCRIPT_DIR%/}/${FILENAME}"

#PYTHON_SCRIPT="/home/users/allstaff/ling.j/trial_slurm/scripts/Region Based Segmentation/workflow1.py"

OUTPUT_LOCATION="$2"

/stornext/System/data/apps/anaconda3/anaconda3-latest/bin/python "$PYTHON_SCRIPT" "$OUTPUT_LOCATION"


conda deactivate

module unload anaconda3/latest
