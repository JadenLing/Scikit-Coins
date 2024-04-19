#!/bin/bash
#SBATCH --job-name=testIHC_analysis #Name to give the job
#SBATCH --time=6:30:00 #Time to allow job to run for
#SBATCH --ntasks=1 #Number of jobs (total)
#SBATCH --cpus-per-task=12 #Only use more than one if code is already multithreaded
#SBATCH --mem 64G #obvious


#The next line is essential for conda to work in your script
source /stornext/System/data/apps/anaconda3/anaconda3-2019.03/etc/profile.d/conda.sh
conda activate bac 

SCRIPT_DIR="$1"

OUTPUT_LOCATION="$2"

GETTIF="getTifs.py"

IHC_DAB="IHC_DAB_Count.py"

PYTHON_SCRIPT_1="${SCRIPT_DIR%/}/${GETTIF}"

PYTHON_SCRIPT_2="${SCRIPT_DIR%/}/${IHC_DAB}"

~/.conda/envs/bac/bin/python "$PYTHON_SCRIPT_1" "$SCRIPT_DIR"

#Creates the command line argmument for the analysis, reads the taskID numbered line of the test.images file
name=$(sed -n "$SLURM_ARRAY_TASK_ID"p images.list)


#run the analysis
~/.conda/envs/bac/bin/python "$PYTHON_SCRIPT_2" "$name"

rm images.list