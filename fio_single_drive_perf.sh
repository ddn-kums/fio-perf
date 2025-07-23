#!/bin/bash

#Benchmark
BENCHMARK="fio"
#Run Type
MODE="final"
#MODE="quick"
#Result File
BASE_RESULT_FILE="/home/ubuntu/kums/perf/fio/results/$MODE/nvme_fio_results"
#Single drive jobfile
SD_JOB_FILE="/home/ubuntu/kums/perf/fio/scripts/sd_jobfile.txt"
#SLEEPT in seconds
SLEEPT=3
LONG_SLEEPT=60
#LONG_SLEEPT=10
# NUMBER OF ITERATIONS
NUM_ITER=3
#NUM_ITER=1
# Block Dev
BDEV_DEVICE="/dev/nvme2n1"

run_fio_test () {

	TESTNAME=$1
	BSIZE=$2
	ITER=$3

	RESULT_FILE=$BASE_RESULT_FILE"_"$TESTNAME"_"$BSIZE"_"$ITER"_`date +%F-%T`.txt"

	echo $RESULT_FILE
	sudo TEST=$TESTNAME BS=$BSIZE $BENCHMARK $SD_JOB_FILE 2>&1 | tee -a $RESULT_FILE

	sleep $SLEEPT
}

run_bdev_trim () {

	echo "Doing Trim on $1"
	sudo blkdiscard -f $1
	sleep $LONG_SLEEPT

}

echo "Launching fio"

for ((iter=1; iter <= $NUM_ITER; iter++))
do
	for sd_test in write read randwrite randread
	#for sd_test in randread
	do
		#for io_size in 4k 8k 16k 32k 64k 128k 256k 512k 1m
		for io_size in 4k 1m
		do
			run_bdev_trim $BDEV_DEVICE
			run_fio_test $sd_test $io_size $iter
		done
	done
done
