# clash_of_worlds
Github repository for working paper: A clash between worlds: Posterior Amortization and the Scientific Workflow


# Oscar installation guide

Make a new environment (here named: *clash_of_worlds*),

`conda create --name clash_of_worlds --python 3.7`
`conda deactivate`
`conda activate clash_of_worlds`

Then,

`pip install pandas`
`pip install matplotlib`
`pip install scikit-learn`
`pip install git+www.github.com/hddm-devs/kabuki`
`pip install git+www.github.com/hddm-devs/hddm`

Now make the enviroment available in jupyter (assuming that you have jupyter installed in the base environment),

`conda install -c anaconda ipykernel`
`python -m ipykernel install --user --name=clash_of_worlds`

Lastly, request an interact session with a gpu,

`interact -m 64g -n 10 -t 12:00:00 -q gpu -g 1 -a your-account -f quadrortx`

and continue by installing pytorch, (did not work on oscar for now)

`module load cudnn/8.2.0`
`module load cuda/11.3`
`module load gcc/10.2`
`pip3 install torch==1.10.2+cu113 torchvision==0.11.3+cu113 torchaudio==0.10.2+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html`

For now only the CPU version works,
`pip3 install torch==1.10.2+cpu torchvision==0.11.3+cpu torchaudio==0.10.2+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html`




