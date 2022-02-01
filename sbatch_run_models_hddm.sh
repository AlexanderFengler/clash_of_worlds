#!/bin/bash

# Default resources are 1 core with 2.8GB of memory per core.

# job name:
#SBATCH -J data_generator

# priority
#SBATCH --account=carney-frankmj-condo

# output file
#SBATCH --output /users/afengler/batch_job_out/data_generator_%A_%a.out

# Request runtime, memory, cores
#SBATCH --time=8:00:00
#SBATCH --mem=16G
#SBATCH -c 24
#SBATCH -N 1
#SBATCH --array=1-1

# --------------------------------------------------------------------------------------

# BASIC SETUP
#source /users/afengler/.bashrc
#conda deactivate
#conda deactivate
#conda activate lanfactory

model_idxs=("ddm" "angle" "ornstein" "weibull")
mode="navarro"
n_mcmc=2000
n_burn=500
n_chains=4
parallel=1

for model_idx in "${model_idxs[@]}"
do
save_folder="hddm_models/$model_idx/"

# DDM
python -u run_model.py --data data/parameter_recovery/param_recov_dataset_ddm.pickle \
                                       --save_folder $save_folder \
                                       --model_idx $model_idx \
                                       --mode $mode \
                                       --n_mcmc $n_mcmc \
                                       --n_burnin $n_burn \
                                       --n_chains $n_chains \
                                       --parallel $parallel
done