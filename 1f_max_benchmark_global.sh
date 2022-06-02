#!/bin/bash

#activate venv if needed
source env/bin/activate
#move to directory
cd SuperStyl
rm -f 1f_max_benchmark_global.log
rm -f train.csv
rm -f test.csv
rm -f test_attributed.csv

for i in `seq 750 250 1500`; do
  echo "--------------------------"
  echo $i
  echo "--------------------------"
  echo "--------------------------" >> 1f_max_benchmark_global.log
  echo $i >> 1f_max_benchmark_global.log
  echo "--------------------------" >> 1f_max_benchmark_global.log
  #create training data
	python3 main.py -s ../train/max/* -t chars -n 3 --sampling --sample_units words --sample_size $i
	#save train data
	mv -f feats_tests_n3_k_5000.csv train.csv
  #create test data
	python3 main.py -s ../unseen/attributed_poems/* -f feature_list_chars3grams5000mf.json -t chars -n 3 --sampling --sample_units words --sample_size $i
	# save test data
	mv -f feats_tests_n3_k_5000.csv test_attributed.csv
  # K-10
  echo "k=10"
  echo "k=10" >> 1f_max_benchmark_global.log
  python train_svm.py train.csv --norms --cross_validate k-fold --k 10 >> 1f_max_benchmark_global.log
  # test out-of-domain
  echo "out-of domain"
  echo "out-of domain" >> 1f_max_benchmark_global.log
  python3 train_svm.py train.csv --test_path test_attributed.csv --norms >> 1f_max_benchmark_global.log
  #-norms --cross_validate k-fold --k 10 --class_weights
  echo "--norms --cross_validate k-fold --k 10 --class_weights"
  echo "--norms --cross_validate k-fold --k 10 --class_weights" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights >> 1f_max_benchmark_global.log
  # test out-of-domain
  echo "out-of domain"
  echo "out-of domain" >> 1f_max_benchmark_global.log
  python3 train_svm.py train.csv --test_path test_attributed.csv --norms --class_weights >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca >> 1f_max_benchmark_global.log
  # test out-of-domain
  echo "out-of domain"
  echo "out-of domain" >> 1f_max_benchmark_global.log
  python3 train_svm.py train.csv --test_path test_attributed.csv --norms --class_weights --dim_reduc pca >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling >> 1f_max_benchmark_global.log
  # test out-of-domain
  echo "out-of domain"
  echo "out-of domain" >> 1f_max_benchmark_global.log
  python3 train_svm.py train.csv --test_path test_attributed.csv --norms --class_weights --dim_reduc pca --balance downsampling >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance downsampling >> 1f_max_benchmark_global.log
  # test out-of-domain
  echo "out-of domain"
  echo "out-of domain" >> 1f_max_benchmark_global.log
  python3 train_svm.py train.csv --test_path test_attributed.csv --norms --class_weights --balance downsampling >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance upsampling >> 1f_max_benchmark_global.log
  # test out-of-domain
  echo "out-of domain"
  echo "out-of domain" >> 1f_max_benchmark_global.log
  python3 train_svm.py train.csv --test_path test_attributed.csv --norms --class_weights --balance upsampling >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance Tomek >> 1f_max_benchmark_global.log
  # test out-of-domain
  echo "out-of domain"
  echo "out-of domain" >> 1f_max_benchmark_global.log
  python3 train_svm.py train.csv --test_path test_attributed.csv --norms --class_weights --balance Tomek >> 1f_max_benchmark_global.log
done

for i in `seq 1750 250 2500`; do
  echo "--------------------------" >> 1f_max_benchmark_global.log
  echo $i >> 1f_max_benchmark_global.log
  echo "--------------------------" >> 1f_max_benchmark_global.log
  echo "--------------------------"
  echo $i
  echo "--------------------------"
  #create training data
	python3 main.py -s ../train/max/* -t chars -n 3 --sampling --sample_units words --sample_size $i
	#save train data
	mv -f feats_tests_n3_k_5000.csv train.csv
  # K-10
  echo "k=10"
  echo "k=10" >> 1f_max_benchmark_global.log
  python train_svm.py train.csv --norms --cross_validate k-fold --k 10 >> 1f_max_benchmark_global.log
  #-norms --cross_validate k-fold --k 10 --class_weights
  echo "--norms --cross_validate k-fold --k 10 --class_weights"
  echo "--norms --cross_validate k-fold --k 10 --class_weights" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --dim_reduc pca --balance downsampling >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance downsampling" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance downsampling >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance upsampling" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance upsampling >> 1f_max_benchmark_global.log
	#--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek"
	echo "--norms --cross_validate k-fold --k 10 --class_weights --balance Tomek" >> 1f_max_benchmark_global.log
	#train model K-10
	python3 train_svm.py train.csv --norms --cross_validate k-fold --k 10 --class_weights --balance Tomek >> 1f_max_benchmark_global.log
done

cd ..

