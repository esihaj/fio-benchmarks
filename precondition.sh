#!/bin/bash
set -e
RED='\033[0;31m'
NC='\033[0m' # No Color

mkdir results

NVME_DEVICES=$(lsblk -b  | grep nvme | grep -v nvme0n | grep -v '─' | tr -s ' ' | cut -d' ' -f1,4)
while IFS= read -r line; do
    DEV=$(echo $line | cut -d' ' -f 1)
    SIZE=$(echo $line | cut -d' ' -f 2)
    echo -e "filling ${RED}$DEV${NC} of size $SIZE"
    sudo fio --name=fill_disk_$DEV --eta=always \
    --filename=/dev/$DEV --filesize=$SIZE \
    --ioengine=io_uring  --direct=1 --verify=0 --randrepeat=0 \
    --bs=128K --iodepth=64 --rw=randwrite > ./results/$DEV-fill_disk.log &
done <<< "$NVME_DEVICES"

wait
