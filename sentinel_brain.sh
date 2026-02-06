#!/bin/bash

# ========== SentinelOps Brain ==========
# Purpose: Collect CPU, RAM, Disk usage and store in CSV
# ======================================

# ---- CSV HEADER (run only once) ----
if [ ! -f system_metrics.csv ]; then
    echo "time,cpu,ram,disk" > system_metrics.csv
fi

# ---- Timestamp ----
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# ---- CPU Usage ----
cpu_usage=$(awk '/^cpu / {printf "%.2f", ($2+$4)*100/($2+$4+$5)}' /proc/stat)

# ---- RAM Usage ----
ram_usage=$(free | awk '/Mem:/ {printf "%.2f", $3*100/$2}')

# ---- Disk Usage ----
disk_usage=$(df / | awk 'NR==2 {print $5}')

# ---- Print to Screen ----
echo "SentinelOps Brain started"
echo "Time: $timestamp"
echo "CPU Usage: $cpu_usage %"
echo "RAM Usage: $ram_usage %"
echo "Disk Usage: $disk_usage"

# ---- Save to CSV ----
echo "$timestamp,$cpu_usage,$ram_usage,$disk_usage" >> system_metrics.csv

