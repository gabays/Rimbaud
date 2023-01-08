#!/bin/bash

#move to directory
cd SuperStyl
#activate venv if needed
source ../env/bin/activate
rm -f 1a_balanced_benchmark_cross.log
rm -f train.csv
rm -f test.csv
rm -f test_attributed.csv

for i in `seq 750 250 2500`; do
  echo "--------------------------" >> 1a_balanced_benchmark_cross.log
  echo $i >> 1a_balanced_benchmark_cross.log
  echo "--------------------------" >> 1a_balanced_benchmark_cross.log
  echo "--------------------------"
  echo $i
  echo "--------------------------"
  #create training data
	python3 main.py -s ../train/balanced/* -t chars -n 3 --sampling --sample_units words --sample_size $i
	#save train data
	mv -f feats_tests_n3_k_5000.csv train.csv
  # K-10
  echo "k=10"
  echo "k=10" >> 1a_balanced_benchmark_cross.log
  python train_svm.py train.csv --norms --cross_validate k-fold --k 10 >> 1a_balanced_benchmark_cross.log

  #-norms --cross_validate k-fold --k 10 --class_weights
  echo "--norms --cross_validate k-fold --k 10 --class_weights"
  echo "--norms --cross_validate k-fold --k 10 --class_weights" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance downsampling >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance upsampling >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance upsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance upsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance upsampling" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance upsampling >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance Tomek >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance Tomek
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance Tomek"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance Tomek" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance Tomek >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel LinearSVC
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel LinearSVC"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel LinearSVC" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel LinearSVC >> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel linear
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel linear"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel linear" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel linear>> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel rbf
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel rbf"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel rbf" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel rbf>> 1a_balanced_benchmark_cross.log

	#--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel sigmoid
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel sigmoid"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel sigmoid" >> 1a_balanced_benchmark_cross.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance downsampling --kernel sigmoid>> 1a_balanced_benchmark_cross.log

done

cd ..

