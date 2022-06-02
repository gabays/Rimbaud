#!/bin/bash

#activate venv if needed
source env/bin/activate
#move to subdirectory
cd SuperStyl
#remove file
rm -f train.csv
rm -f test_attributed.csv
rm -f test_debated.csv
rm -f 3_test_unseen.log
echo """
------------------------
Create train set
-t chars -n 3 --sampling --sample_units words --sample_size 2000
------------------------
"""
#create reference data (for the json file)
python3 main.py -s ../train/unbalanced/* -t chars -n 3 --sampling --sample_units words --sample_size 2000
#save train data
mv -f feats_tests_n3_k_5000.csv train.csv
#create test data 1
python3 main.py -s ../unseen/attributed_poems/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_units words --sample_size 2000 >> 3_test_unseen.log
# save test data 1
mv feats_tests_n3_k_5000.csv test_attributed.csv
#create test data 2
python3 main.py -s ../unseen/debated_poems/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_units words --sample_size 2000 >> 3_test_unseen.log
# save test data 2
mv feats_tests_n3_k_5000.csv test_debated.csv

echo """
------------------------
TEST UNSEEN
------------------------
"""
echo "debated texts" >> 3_test_unseen.log

#test
python3 train_svm.py train.csv --test_path test_debated.csv --norms --class_weights --balance downsampling --final --get_coefs >> 3_test_unseen.log


cd ..
