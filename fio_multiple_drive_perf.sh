#!/bin/bash

#Benchmark
BENCHMARK="fio"
#Run Type
#MODE="final"
MODE="quick"
#Result File
BASE_RESULT_FILE="/home/ubuntu/kums/perf/fio/results/$MODE/nvme_md_fio_results"
#Multiple drives jobfile
MD_JOB_FILE="/home/ubuntu/kums/perf/fio/scripts/md_jobfile.txt"
#SLEEPT in seconds
SLEEPT=3
LONG_SLEEPT=60
#LONG_SLEEPT=5
# NUMBER OF ITERATIONS
#NUM_ITER=3
NUM_ITER=2
# Block Dev
NVME_DEVICES="nvme0n1 nvme1n1 nvme2n1 nvme3n1 nvme4n1 nvme5n1 nvme6n1 nvme7n1 nvme8n1 nvme9n1 nvme10n1 nvme11n1"

run_fio_test () {

	TESTNAME=$1
	BSIZE=$2
	ITER=$3

	RESULT_FILE=$BASE_RESULT_FILE"_"$TESTNAME"_"$BSIZE"_"$ITER"_`date +%F-%T`.txt"

	echo $RESULT_FILE
	sudo TEST=$TESTNAME BS=$BSIZE $BENCHMARK $MD_JOB_FILE 2>&1 | tee -a $RESULT_FILE

	sleep $SLEEPT
}

run_bdev_trim () {

	for dev in $NVME_DEVICES
	do
		echo "Doing Trim on /dev/$dev"
		sudo blkdiscard -f "/dev/$dev"
	done
	sleep $LONG_SLEEPT

}

echo "Launching fio"

for ((iter=1; iter <= $NUM_ITER; iter++))
do
	#for md_test in write read randwrite randread
	for md_test in randread
	do
		#for io_size in 4k 32k 64k 256k 1m
		#for io_size in 4k 1m
		for io_size in 1m
		do
			run_bdev_trim
			run_fio_test $md_test $io_size $iter
		done
	done
done
