#!/bin/bash

#activate venv if needed
source ../env/bin/activate
#move to directory
cd SuperStyl
rm -f 1b_balanced_benchmark_test.log
rm -f train.csv
rm -f test.csv
rm -f test_attributed.csv

for i in `seq 750 250 2500`; do
  echo "--------------------------" >> 1b_balanced_benchmark_test.log
  echo $i >> 1b_balanced_benchmark_test.log
  echo "--------------------------" >> 1b_balanced_benchmark_test.log
  echo "--------------------------"
  echo $i
  echo "--------------------------"
  #create training data
	python3 main.py -s ../train/balanced/* -t chars -n 3 --sampling --sample_units words --sample_size $i
	#save train data
	mv -f feats_tests_n3_k_5000.csv train.csv
  #create test data
	python3 main.py -s ../unseen/attributed_poems/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_units words --sample_size $i
	# save test data
	mv -f feats_tests_n3_k_5000.csv test_attributed.csv

  #-norms --cross_validate k-fold --k 10 --class_weights
  echo "--norms --cross_validate k-fold --k 10 --class_weights"
  echo "--norms --cross_validate k-fold --k 10 --class_weights" >> 1b_balanced_benchmark_test.log
	#train model K-10
	python3 train_svm.py train.csv --test_path test_attributed.csv --class_weights >> 1b_balanced_benchmark_test.log

	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca" >> 1b_balanced_benchmark_test.log
	#train model K-10
	python3 train_svm.py train.csv --test_path test_attributed.csv --class_weights --dim_reduc pca >> 1b_balanced_benchmark_test.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling" >> 1b_balanced_benchmark_test.log
	#train model K-10
	python3 train_svm.py train.csv --test_path test_attributed.csv --class_weights --balance downsampling >> 1b_balanced_benchmark_test.log

	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling" >> 1b_balanced_benchmark_test.log
	#train model K-10
	python3 train_svm.py train.csv --test_path test_attributed.csv --class_weights --dim_reduc pca --balance downsampling >> 1b_balanced_benchmark_test.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling" >> 1b_balanced_benchmark_test.log
	#train model K-10
	python3 train_svm.py train.csv --test_path test_attributed.csv --class_weights --balance upsampling >> 1b_balanced_benchmark_test.log

	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance upsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance upsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance upsampling" >> 1b_balanced_benchmark_test.log
	#train model K-10
	python3 train_svm.py train.csv --test_path test_attributed.csv --class_weights --dim_reduc pca --balance upsampling >> 1b_balanced_benchmark_test.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek" >> 1b_balanced_benchmark_test.log
	#train model K-10
	python3 train_svm.py train.csv --test_path test_attributed.csv --class_weights --balance Tomek >> 1b_balanced_benchmark_test.log

	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance Tomek
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance Tomek"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance Tomek" >> 1b_balanced_benchmark_test.log
	#train model K-10
	python3 train_svm.py train.csv --test_path test_attributed.csv --class_weights --dim_reduc pca --balance Tomek >> 1b_balanced_benchmark_test.log
done

cd ..

