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
-t chars -n 3 --sampling --sample_units words --sample_size 1500
------------------------
"""
#create training data
python3 main.py -s ../train/balanced/* -t chars -n 3 --sampling --sample_units words --sample_size 1500
#save train data
mv -f feats_tests_n3_k_5000.csv train.csv
#create test data
python3 main.py -s ../unseen/attributed_poems/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_units words --sample_size 1500
# save test data
mv -f feats_tests_n3_k_5000.csv test_attributed.csv
#create test data 2
python3 main.py -s ../unseen/attributed_letters/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_units words --sample_size 1500 >> 3_test_unseen.log
# save test data 2
mv feats_tests_n3_k_5000.csv test_letters.csv

echo """
------------------------
Test set 1: attributed poems
------------------------
"""
echo "--norms --class_weights --dim_reduc pca --balance downsampling" >> 2_best_config.log
#train model
python3 train_svm.py train.csv --test_path test_attributed.csv --norms --class_weights --dim_reduc pca --balance downsampling >> 2_best_config.log

echo """
------------------------
Test set 2: attributed letters
------------------------
"""

echo "cancelled"

#echo "--norms --class_weights --dim_reduc pca --balance downsampling" >> 2_best_config.log
#train model
#python3 train_svm.py train.csv --test_path test_letters.csv --norms --class_weights --dim_reduc pca --balance downsampling >> 2_best_config.log

echo """
------------------------
Get coefs: cross-validation
------------------------
"""
echo "--norms --class_weights --dim_reduc pca --balance downsampling" >> 2_best_config.log
#train model
python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling >> 2_best_config.log


# going up to main directory

cd ..

