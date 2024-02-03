#!/bin/bash

# Script for Running Dragonflye Assembly Pipeline

# Define variables
IDS_FILE="ids"
BASE_DIR="/mnt/d/assembly_evaluation_cgps/fastqs/KPN"
G_SIZE="5.5M"
CPUS="16"
RAM="15"
MODEL="r941_min_sup_g507"

# Function to execute Dragonflye command
run_dragonflye() {
    local command_num=$1
    local out_dir="$BASE_DIR/dragonflye_out_$command_num"

    echo "Executing Command $command_num"

    for f in $(cat $IDS_FILE); do
        dragonflye --trim --gsize $G_SIZE --reads ${f}*-ont.fastq.gz \
            --outdir "$out_dir/$f" --prefix $f --R1 "$f"*-R1.fastq.gz \
            --R2 "$f"*-R2.fastq.gz --cpus $CPUS --ram $RAM $2
    done

    # Check the exit status of the Dragonflye command
    if [ $? -eq 0 ]; then
        echo "Command $command_num succeeded"
    else
        echo "Command $command_num failed, skipping remaining commands"
        exit 1
    fi
}

# Command 1
run_dragonflye 1 "--racon 1 --medaka 1 --pilon 1 --polypolish 1"

# Command 2
run_dragonflye 2 "--racon 1 --polypolish 1"

# Command 3
run_dragonflye 3 "--racon 1"

# Command 4
run_dragonflye 4 "--racon 1 --medaka 1 --model $MODEL --pilon 1"

# Command 5
run_dragonflye 5 "--medaka 1 --model $MODEL --pilon 1 --polypolish 1"

echo "All Dragonflye commands executed successfully"
