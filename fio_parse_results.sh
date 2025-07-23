#!/bin/bash

#Benchmark
BENCHMARK="fio"
#Run Type
MODE="final"
#Result File
BASE_RESULT_FILE="/home/ubuntu/kums/perf/results/$MODE/qlc_fio_results_qd-1"
BASE_RESULT_FILE="/home/ubuntu/kums/perf/results/$MODE/samsung_fio_results_qd-1"
#SLEEPT in seconds
SLEEPT=3
# NUMBER OF ITERATIONS
NUM_ITER=3
# Block Dev
BDEV_DEVICE="/dev/nvme3n1"

parse_bw () {

	TESTNAME=$1
	BSIZE=$2
	ITER=$3

	RESULT_FILE=$BASE_RESULT_FILE"_"$TESTNAME"_"$BSIZE"_"$ITER"_*.txt"

	grep 'BW=' $RESULT_FILE | awk -F '=' '{print $3}' | awk '{print $1}' 

}

parse_iops () {

	TESTNAME=$1
	BSIZE=$2
	ITER=$3

	RESULT_FILE=$BASE_RESULT_FILE"_"$TESTNAME"_"$BSIZE"_"$ITER"_*.txt"

	grep 'IOPS=' $RESULT_FILE | awk -F '=' '{print $2}' | awk '{print $1}'| cut -d ',' -f1

}

echo "Parsing Bandwidth results"

for sd_test in write read randwrite randread
#for sd_test in write
do
	echo $sd_test
	for ((iter=1; iter <= $NUM_ITER; iter++))
	do
		echo $iter
		for io_size in 4k 8k 16k 32k 64k 128k 256k 512k 1m
		do
			 parse_bw $sd_test $io_size $iter
		done
	done
done

echo "Parsing IOPS results"

for sd_test in write read randwrite randread
#for sd_test in write
do
	echo $sd_test
	for ((iter=1; iter <= $NUM_ITER; iter++))
	do
		echo $iter
		for io_size in 4k 8k 16k 32k 64k 128k 256k 512k 1m
		do
			 parse_iops $sd_test $io_size $iter
		done
	done
done
