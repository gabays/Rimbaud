#!/bin/bash

python3 -m venv env 
source env/bin/activate
git clone https://github.com/SupervisedStylometry/SuperStyl
pip install -r install/custom-requirements.txt
mkdir SuperStyl/superstyl/preproc/models
wget https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin -P ./SuperStyl/superstyl/preproc/models
