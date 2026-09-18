#!/bin/bash

# Disk Usage Check Script
# This script checks the disk usage of the root filesystem and reports if it exceeds a specified threshold 
# Usage: ./disk-check.sh <threshold_percentage> [path]

mkdir -p ./logs

# Redirect all subsequent stdout and stderr to the log file
exec > >(tee -a "./logs/disk-check.log-$(date +%Y-%m-%d_%H-%M-%S)" 2>&1)

echo "______________________________"
echo "Disk Usage percentage"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <threshold_percentage> [path]"
    exit 2
fi

threshold=$1

if ! [[ "$threshold" =~ ^[0-9]+$ ]]; then
    echo "Error: Threshold must be a positive integer"
    exit 2
fi

if [ "$threshold" -lt 1 ] || [ "$threshold" -gt 100 ]; then
    echo "Error: Threshold must be between 1 and 100"
    exit 2
fi

path=${2:-/}  # Default to filesystem if no path is provided
disk_usage=$(df -h "$path" | awk 'NR==2 {print $5}' | sed 's/%//')
echo "Current disk usage of filesystem: $disk_usage%"

if [[ "$disk_usage" -lt "$threshold" ]]; then
    echo "Info: usage is below the threshold"
    exit 0
else
    echo "Warning: usage reaches or exceeds the threshold"
    exit 1
fi