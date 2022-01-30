# Load modules
import hddm
import tensorflow as tf
import matplotlib
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
import scipy as scp
import psutil
from time import time
from copy import deepcopy
import os
import pickle
import argparse
import yaml as yml
from multiprocessing import Pool
from functools import partial

def run_subj_model_reg(df_subj, model_idx, reg_models = None,
                       include = None,
                       n_mcmc = 2000, n_burnin = 500,
                       n_chains = 1, save_folder = None,
                       started_by_mp = False):
    
    """This is the main function used for model fits. 
    
    Arguments:
        df_subj: pd.Dataframe
            Dataframe containing subject data to fit.
        
        model_idx: str 
            String that provides a name for the model fit. This is only used to generated an appropriate save file.
        reg_models: list of dictionaries <default=None>
            A list of dictionaries, where each dictionary holds a reg_model as expected by the HDDMRegressor class.
        include: list <default=None>
            A list of strings, which specify parameters to fit, which are not regressor outcomes (see HDDM documentation)
        n_mcmc: int <default=2000>
            Number of MCMC samples to run
        n_burnin: int <default=500>
            Number of burn in samples to run
        n_chains: int <default=1>
            Number of chains to run
        save_folder: str <default=None>
            Folder to save the outcomes in
        started_by_mp: bool <default=False>
            mp for multiprocessing. If started by mp is true returns are reduced to integers specifying whether the process completed without issue (1), the process was interrupted because sampling takes too long (-2), the process was interrupted because an error occured during sampling (-1). In case the argument is False, the function returns the data and the model.
    
    Return: If in multiprocessing mode, this function returns integers specifying whether the process completed correctly. If not in multiprocessing mode, the hddm model and some metadata dictionary is returned.
    """

    assert save_folder is not None, 'You want to save the model,' + \
                                        'but did not specify a folder to save the model in.'
        
    # Extract subject id from data (useful for naming of saved files etc.)
    subj_idx = df_subj['subject_uuid'].values[0]
    
    # ACTUAL RUN  ---------------------------------------------------
    for chain in range(1, n_chains + 1, 1):
        start_t = time()
        model_ = hddm.HDDM(df_subj,
                            include = 'z')

        db_file_name = save_folder + '/db_chain_' + str(chain) + '_' + model_idx + '_subj_' + subj_idx + '.db'
        model_file_name = save_folder + '/model_chain_' + str(chain) + '_' + model_idx + '_subj_' + subj_idx + '.pickle'

        # Check if model file name exists --> if yes don't run anything
        if os.path.exists(model_file_name):
            print(model_file_name, ' EXISTS --> NOT RUNNING THIS MODEL')
        else:
            try:
                model_.sample(n_mcmc + n_burnin, n_burnin, 
                              dbname = db_file_name, 
                              db = 'pickle')

                model_.save(model_file_name)

            except:
                print("Something went wrong with sampling from the model")
                print("Subj_idx: ", subj_idx)
                return -1

            # Make dataframe containing info about model
            model_data = pd.DataFrame(columns = ['model_idx', 'subj_idx', 
                                                 'model_file', 'db_file', 
                                                 'data',
                                                 'dic', 
                                                 'traces', 
                                                 'time'])
            model_data = model_data.append({'model_idx': model_idx, 'subj_idx': subj_idx, 
                               'model_file': model_file_name, 'db_file': db_file_name,
                               'data': df_subj,
                               'dic': model_.dic,
                               'traces': pd.DataFrame.from_dict({key: model_.mc.db._traces[key].gettrace() for key in model_.mc.db._traces.keys()}),
                               'time': time() - start_t},
                               ignore_index = True)

            data_file_name = save_folder + '/df_chain_' + str(chain) + '_' + model_idx + '_subj_' + subj_idx + '.pickle'
            pickle.dump(model_data, open(data_file_name, 'wb')) 
    
    if started_by_mp:
        return 1
    else:
        return model_, model_data
    
    # WRITE ONE MORE OF THESE THAT ALLOWS ARBITRARY REGRESSION MODEL
    # THINK ABOUT HOW TO STORE THAT !

if __name__ == "__main__":
    
    # Interface ----
    CLI = argparse.ArgumentParser()
    CLI.add_argument("--data",
                     type = str,
                     default = None)
    CLI.add_argument('--save_folder',
                     type = str,
                     default = None)
    CLI.add_argument('--model_idx',
                     type = str,
                     default = None)
    CLI.add_argument('--n_mcmc', 
                     type = int,
                     default = 2000)
    CLI.add_argument('--n_burnin',
                     type = int,
                     default = 500)
    CLI.add_argument('--n_chains',
                     type = int,
                     default = 1)
    CLI.add_argument('--parallel',
                     type = int,
                     default = 0)
    
    args = CLI.parse_args()
    print('Arguments passed: ', args)
    
    # Raw data dict
    data = pickle.load(open(args.data, 'rb'))
    
    # LOAD MODEL SPEC
    model_spec = yml.load(open('model_specs.yml', 'rb'), Loader = yml.Loader)[args.model_idx]
    
    print('LOADED FROM MODEL SPEC: ', args.model_idx)
    #print(model_spec)

    # Subjects to look at
    subj_ids = list(data.keys())
    
    if not len(model_spec['reg_models']) > 0:
        print('You included no regressors! Make sure this is intended!')
    else:
        print('regressors: ', model_spec['reg_models'])
    
    # RUN MODELS ------------------------------------------------------------------
    if not args.parallel:
        cnt = 0
        for subj_idx in subj_ids:
            print(subj_idx)
            print('Model ' + str(cnt) + ' of ' + str(len(subj_ids)))
            df_subj = data[subj_idx]['data']
            print(df_subj)

            model_tmp = run_subj_model_reg(df_subj, model_idx = args.model_idx, reg_models = model_spec['reg_models'],
                                           include = model_spec['includes'],
                                           n_mcmc = args.n_mcmc, n_burnin = args.n_burnin, n_chains = args.n_chains,
                                           save_folder = args.save_folder,
                                           started_by_mp = False)
            cnt += 1
    else:
        n_cpus = psutil.cpu_count(logical = False) - 1
        print('N CPUS: ', n_cpus)
        
        # Prepare data to be passed to run_subj_model_reg)
        par_args = [data[subj_idx]['data'] for subj_idx in subj_ids]
        
        if model_spec['includes'] == 'None':
            model_spec['includes'] = ()
        
        prepped_run_subj_model_reg = partial(run_subj_model_reg, 
                                             model_idx = args.model_idx,
                                             reg_models = model_spec['reg_models'],
                                             include = model_spec['includes'],
                                             n_mcmc = args.n_mcmc, n_burnin = args.n_burnin,
                                             n_chains = args.n_chains, save_folder = args.save_folder,
                                             started_by_mp = True)
        
        # Starting pool
        with Pool(processes = n_cpus) as pool:
            pool_out = pool.map(prepped_run_subj_model_reg, par_args)
        
        print('POOL OUT: ', pool_out)
        if (-1) not in pool_out:
            print('SCRIPT FINISHED: SUCCESSFULLY')
        else:
            print('SCRIPT FINISHED: SOME MODELS EITHER CREATED PROBLEMS OR DIDNT RUN')
