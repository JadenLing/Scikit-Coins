#!/bin/bash

#SBATCH --job-name test-script
#SBATCH --output=/home/users/allstaff/ling.j/trial_slurm/result-%j.out
#SBATCH --mem=4G

module load anaconda3/latest

conda activate base

PYTHON_SCRIPT="/home/users/allstaff/ling.j/trial_slurm/scripts/Region Based Segmentation/workflow1.py"

OUTPUT_LOCATION="$1"

/stornext/System/data/apps/anaconda3/anaconda3-latest/bin/python "$PYTHON_SCRIPT"


conda deactivate

module unload anaconda3/latest
