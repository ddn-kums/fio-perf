#!/bin/bash

#Run Type
#MODE="final"
MODE="quick"
#Result File
RESULT_FILE="/home/ubuntu/kums/perf/fio/results/$MODE/nvme_settings_`date +%F-%T`.txt"
#SLEEPT in seconds
SLEEPT=1
# Block Dev
NVME_DEVICES="nvme2n1"
#NVME_DEVICES="nvme0n1 nvme1n1 nvme2n1 nvme3n1 nvme4n1 nvme5n1 nvme6n1 nvme7n1 nvme8n1 nvme9n1 nvme10n1 nvme11n1 nvme13n1 nvme14n1 nvme15n1 nvme16n1"

get_sys_value() {

	NVME_DEVICE=$1

	echo $NVME_DEVICE 2>&1 | tee -a $RESULT_FILE
	cat /sys/block/$NVME_DEVICE/queue/scheduler 2>&1 | tee -a $RESULT_FILE
	cat /sys/block/$NVME_DEVICE/queue/nr_requests 2>&1 | tee -a $RESULT_FILE
	cat /sys/block/$NVME_DEVICE/queue/max_sectors_kb 2>&1 | tee -a $RESULT_FILE
	cat /sys/block/$NVME_DEVICE/queue/read_ahead_kb 2>&1 | tee -a $RESULT_FILE
	cat /sys/block/$NVME_DEVICE/queue/rq_affinity 2>&1 | tee -a $RESULT_FILE

	sleep $SLEEPT
}

echo "Getting NVMe device settings"

for dev in $NVME_DEVICES
do
	get_sys_value $dev
done
