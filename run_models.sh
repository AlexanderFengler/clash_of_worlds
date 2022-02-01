model_idxs=("ddm" "angle")
modes=("navarro" "lan")
n_mcmc=2000
n_burn=500
n_chains=4
parallel=1

for model_idx in "${model_idxs[@]}"
do  
    echo "passed"
    for mode in "${mode[@]}"
        echo "passed inner"
        do
        data="data/parameter_recovery/param_recov_dataset_$model_idx.pickle"
        save_folder="hddm_models/$model_idx/"

        # DDM
        sbatch sbatch_run_models_hddm.sh --data $data \
                                            --save_folder $save_folder \
                                            --model_idx $model_idx \
                                            --mode $mode \
                                            --n_mcmc $n_mcmc \
                                            --n_burnin $n_burn \
                                            --n_chains $n_chains \
                                            --parallel $parallel
        done
done