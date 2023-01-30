#!/bin/bash
set -e
RED='\033[0;31m'
NC='\033[0m' # No Color

JOB=two-disk-per-job.fio
JOBS=2

SUMMARY=summary
RESULT=result
ARCHIVE=$SUMMARY/archive

mkdir $SUMMARY $RESULT $ARCHIVE || true

run_benchmark() {
        export DEPTH=$1
        export IOPS=$2
        export JOBS
        printf "depth=$DEPTH, IOPS=$IOPS, JOBS=$JOBS ...    "
        TEST_NAME="d-$DEPTH-iops-$IOPS"
        rm -rf $RESULT || true
        mkdir $RESULT
        
        fio $JOB > $SUMMARY/"$TEST_NAME.txt"
        mv $RESULT $ARCHIVE/$TEST_NAME
        echo "done"
        sleep 10s
}

run_benchmark 512 0
exit 1

for DEPTH in 1 2 4 8 16 32 64 128 192 256 512
do
    run_benchmark $DEPTH 0
done

mv $SUMMARY depth-summary
mkdir -p $SUMMARY $ARCHIVE 

for IOPS in 100000 200000 300000 400000 500000 600000 800000 800000 810000 820000 830000 840000 850000 860000 870000 890000 900000 0
do
    run_benchmark 128 $IOPS
done
