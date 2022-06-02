#!/bin/bash

#activate venv if needed
source env/bin/activate
#move to directory
cd SuperStyl
#remove file
rm -f test.csv
rm -f train.csv
rm -f 4_rolling.log

echo """
------------------------
-t chars -n 3 --sampling --sample_units words --sample_size 2000
------------------------
"""
#create reference data
python3 main.py -s ../train/unbalanced/* -t chars -n 3 --sampling --sample_units words --sample_size 2000
# save train
mv feats_tests_n3_k_5000.csv train.csv
#create corpus data
python3 main.py -s ../unseen/debated_poems/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_step 10 --sample_units words --sample_size 2000
mv feats_tests_n3_k_5000.csv test.csv

echo """
------------------------
--norms --class_weights --balance downsampling --final
------------------------
"""
#train model
python3 train_svm.py train.csv --test_path test.csv --norms --class_weights --balance downsampling --final --get_coefs >> 4_rolling.log

# Save plot
Rscript ../R/Rolling.R

cd ..

