# DDM
python /Users/afengler/OneDrive/proj_clash_of_worlds/clash_of_worlds/run_model.py --data data/parameter_recovery/param_recov_dataset_ddm.pickle \
                       --save_folder hddm_models/ddm/ \
                       --model_idx ddm \
                       --mode navarro \
                       --n_mcmc 2000 \
                       --n_burnin 500 \
                       --n_chains 4 \
                       --parallel 0

python /Users/afengler/OneDrive/proj_clash_of_worlds/clash_of_worlds/run_model.py --data data/parameter_recovery/param_recov_dataset_angle.pickle \
                       --save_folder hddm_models/angle/ \
                       --model_idx angle \
                       --mode navarro \
                       --n_mcmc 2000 \
                       --n_burnin 500 \
                       --n_chains 4 \
                       --parallel 0

python /Users/afengler/OneDrive/proj_clash_of_worlds/clash_of_worlds/run_model.py --data data/parameter_recovery/param_recov_dataset_weibull.pickle \
                       --save_folder hddm_models/weibull/ \
                       --model_idx weibull \
                       --mode navarro \
                       --n_mcmc 2000 \
                       --n_burnin 500 \
                       --n_chains 4 \
                       --parallel 0

python /Users/afengler/OneDrive/proj_clash_of_worlds/clash_of_worlds/run_model.py --data data/parameter_recovery/param_recov_dataset_ornstein.pickle \
                       --save_folder hddm_models/ornstein/ \
                       --model_idx ornstein \
                       --mode navarro \
                       --n_mcmc 2000 \
                       --n_burnin 500 \
                       --n_chains 4 \
                       --parallel 0

# LAN
# python /Users/afengler/OneDrive/proj_clash_of_worlds/clash_of_worlds/run_model.py --data data/parameter_recovery/param_recov_dataset_ddm.pickle \
#                        --save_folder hddm_models/ddm/ \
#                        --model_idx ddm \
#                        --mode lan \
#                        --n_mcmc 1500 \
#                        --n_burnin 500 \
#                        --n_chains 1 \
#                        --parallel 1

# check for issues
# python /Users/afengler/OneDrive/proj_clash_of_worlds/clash_of_worlds/run_model.py --data data/parameter_recovery/param_recov_dataset_angle.pickle \
#                        --save_folder hddm_models/angle/ \
#                        --model_idx angle \
#                        --mode lan \
#                        --n_mcmc 1500 \
#                        --n_burnin 500 \
#                        --n_chains 1 \
#                        --parallel 1

# python /Users/afengler/OneDrive/proj_clash_of_worlds/clash_of_worlds/run_model.py --data data/parameter_recovery/param_recov_dataset_weibull.pickle \
#                        --save_folder hddm_models/weibull/ \
#                        --model_idx weibull \
#                        --mode lan \
#                        --n_mcmc 1500 \
#                        --n_burnin 500 \
#                        --n_chains 1 \
#                        --parallel 1

# python /Users/afengler/OneDrive/proj_clash_of_worlds/clash_of_worlds/run_model.py --data data/parameter_recovery/param_recov_dataset_ornstein.pickle \
#                        --save_folder hddm_models/ornstein/ \
#                        --model_idx ornstein \
#                        --mode lan \
#                        --n_mcmc 1500 \
#                        --n_burnin 500 \
#                        --n_chains 1 \
#                        --parallel 0