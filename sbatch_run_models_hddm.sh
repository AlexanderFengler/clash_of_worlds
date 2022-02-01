#!/bin/bash

# Default resources are 1 core with 2.8GB of memory per core.

# job name:
#SBATCH -J param_recov

# priority
#SBATCH --account=carney-frankmj-condo

# output file
#SBATCH --output /users/afengler/batch_job_out/param_recov_%A_%a.out

# Request runtime, memory, cores
#SBATCH --time=24:00:00
#SBATCH --mem=16G
#SBATCH -c 12
#SBATCH -N 1
##SBATCH --array=1-1

# --------------------------------------------------------------------------------------

# BASIC SETUP
source /users/afengler/.bashrc
conda deactivate
conda deactivate
conda activate clash_of_worlds

model_idx="ddm"
mode="navarro"
n_mcmc=2000
n_burn=500
n_chains=4
parallel=1
data="data/parameter_recovery/param_recov_dataset_$model_idx.pickle"
save_folder="hddm_models/$model_idx"

while [ ! $# -eq 0 ]
    do
        case "$1" in
            --data | -d)
                data=$2
                ;;
            --save_folder | -s)
                save_folder=$2
                ;;
            --model_idx | -i)
                model_idx=$2
                ;;
            --mode | -m)
                mode=$2
                ;;
            --n_mcmc | -n)
                n_mcmc=$2
                ;;
            --n_burn | -b)
                n_burn=$2
                ;;
            --n_chains | -c)
                n_chains=$2
                ;;
            --parallel | -p)
                parallel=$2
                ;;
        esac
        shift 2
    done

python -u run_model.py --data data/parameter_recovery/param_recov_dataset_ddm.pickle \
                                    --save_folder $save_folder \
                                    --model_idx $model_idx \
                                    --mode $mode \
                                    --n_mcmc $n_mcmc \
                                    --n_burnin $n_burn \
                                    --n_chains $n_chains \
                                    --parallel $parallel