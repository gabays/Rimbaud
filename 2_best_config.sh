#!/bin/bash

#activate venv if needed
source env/bin/activate
#move to subdirectory
cd SuperStyl
#remove file
rm -f train.csv
rm -f test_attributed.csv
rm -f 2_best_config.log
echo """
------------------------
Create train and test sets
-t chars -n 3 --sampling --sample_units words --sample_size 2000
------------------------
"""
#create training data
python3 main.py -s ../train/unbalanced/* -t chars -n 3 --sampling --sample_units words --sample_size 2000
#save train data
mv -f feats_tests_n3_k_5000.csv train.csv
#create test data
python3 main.py -s ../unseen/attributed_poems/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_units words --sample_size 2000
# save test data
mv -f feats_tests_n3_k_5000.csv test_attributed.csv


echo """
------------------------
Test set
------------------------
"""
echo "--norms --class_weights--balance downsampling" >> 2_best_config.log
#train model
python3 train_svm.py train.csv --test_path test_attributed.csv --norms --class_weights --balance downsampling >> 2_best_config.log


echo """
------------------------
Cross-validation
------------------------
"""
echo "--norms --class_weights --balance downsampling" >> 2_best_config.log
#train model
python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --get_coefs >> 2_best_config.log

# going up to main directory

cd ..

