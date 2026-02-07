#!/bin/bash

# SentinelOps
# Simple Linux system monitoring script
# Written by: karandeven

LOG_FILE="sentinel.log"
CSV_FILE="system_metrics.csv"

CPU_THRESHOLD=${CPU_THRESHOLD:-80}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "INFO: Script started"

# create CSV header only once
if [ ! -f "$CSV_FILE" ]; then
    echo "time,cpu,ram,disk" > "$CSV_FILE"
fi

timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# CPU usage (safe & simple)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')

# RAM usage
ram_usage=$(free | awk '/Mem/ {printf("%d", $3*100/$2)}')

# Disk usage
disk_usage=$(df / | awk 'NR==2 {print int($5)}')

echo "SentinelOps Brain started"
echo "Time: $timestamp"
echo "CPU Usage: $cpu_usage %"
echo "RAM Usage: $ram_usage %"
echo "Disk Usage: $disk_usage %"

echo "$timestamp,$cpu_usage,$ram_usage,$disk_usage" >> "$CSV_FILE"

log "INFO: CPU=${cpu_usage}% RAM=${ram_usage}% DISK=${disk_usage}%"

if [ "$cpu_usage" -ge "$CPU_THRESHOLD" ]; then
    log "ALERT: CPU high (${cpu_usage}%)"
fi

