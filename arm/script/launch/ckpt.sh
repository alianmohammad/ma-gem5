#!/bin/bash
# Authors: Mohammad Alian <malian2@illinois.edu>
# Launching dist-gem5 to bootup linux and take a checkpoint using HTCondor 
# For more information about HTCondor visit https://research.cs.wisc.edu/htcondor/

ROOT_PATH=../../../../ma-gem5
GEM5_PATH=$ROOT_PATH/gem5
IMG=$ROOT_PATH/arm/disks/ubuntu-16.04.img
VMLINUX=$ROOT_PATH/arm/binaries/vmlinux-4.14
DTB=$GEM5_PATH/system/arm/dt/armv8_gem5_v1_4cpu.dtb

binary_path=$ROOT_PATH/arm
export M5_PATH="${binary_path}"

SCRIPT_DIR="$(pwd)"

CONFIG=$1
SCRIPT=$2
[ -z "$CONFIG" ] && CONFIG="default"
[ -z "$SCRIPT" ] && SCRIPT="../rcS/ckpt.rcS"

CKPTDIR=$ROOT_PATH/ckptdir/$CONFIG

RUNDIR=$CKPTDIR

rm -rf $CKPTDIR

host_cores=4

EXE=$GEM5_PATH/build/ARM/gem5.opt
DEBUG="--debug-flags=WorkItems "
NODES=2

extra_args=" --mem-size=8GB --multi-nic "

MACHINE_TYPE=VExpress_GEM5_V1

bash $GEM5_PATH/util/dist/gem5-dist-condor.sh -n $NODES -r $RUNDIR -c $CKPTDIR -s $GEM5_PATH/configs/dist/sw.py -f $GEM5_PATH/configs/example/fs.py --fs-args --machine-type=$MACHINE_TYPE --kernel=$VMLINUX --disk-image=$IMG $HAVE_DTB --script=$SCRIPT_DIR/$SCRIPT --num-cpus=$host_cores $extra_args -x $EXE --cf-args --dist-sync-start=1000000000000t --m5-args $DEBUG
