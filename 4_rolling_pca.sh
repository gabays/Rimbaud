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
-t chars -n 3 --sampling --sample_units words --sample_size 1500
------------------------
"""
#create reference data
python3 main.py -s ../train/unbalanced/* -t chars -n 3 --sampling --sample_units words --sample_size 1500
# save train
mv feats_tests_n3_k_5000.csv train.csv
#create corpus data
python3 main.py -s ../unseen/debated_poems/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_step 10 --sample_units words --sample_size 1500
mv feats_tests_n3_k_5000.csv test_debated.csv

echo """
------------------------
--norms --class_weights --balance downsampling --final
------------------------
"""
#train model
python3 train_svm.py train.csv --test_path test_debated.csv --norms --class_weights --dim_reduc pca --balance downsampling --final>> 3_test_unseen.log

# Save plot
Rscript ../R/Rolling.R

cd ..

