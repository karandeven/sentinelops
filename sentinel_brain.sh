#!/bin/bash

# SentinelOps - Simple System Monitor
# Written by: karandeven
# Learning-focused script (safe & stable)

LOG_FILE="sentinel.log"
CSV_FILE="system_metrics.csv"

CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=80

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "INFO: Script started"

# CSV header (run once)
if [ ! -f "$CSV_FILE" ]; then
  echo "time,cpu,ram,disk" > "$CSV_FILE"
fi

timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# -------- CPU usage (SAFE METHOD) --------
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)

# -------- RAM usage --------
ram_usage=$(free | awk '/Mem:/ {printf "%d", $3*100/$2}')

# -------- Disk usage --------
disk_usage=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

# -------- Output --------
echo "SentinelOps Brain started"
echo "Time: $timestamp"
echo "CPU Usage: $cpu_usage %"
echo "RAM Usage: $ram_usage %"
echo "Disk Usage: $disk_usage %"

# -------- Alerts --------
if [ "$cpu_usage" -ge "$CPU_THRESHOLD" ]; then
  echo "🔥 CPU HIGH ($cpu_usage%)"
  log "ALERT: CPU high ($cpu_usage%)"
fi

if [ "$ram_usage" -ge "$RAM_THRESHOLD" ]; then
  echo "🔥 RAM HIGH ($ram_usage%)"
  log "ALERT: RAM high ($ram_usage%)"
fi

if [ "$disk_usage" -ge "$DISK_THRESHOLD" ]; then
  echo "🔥 DISK HIGH ($disk_usage%)"
  log "ALERT: Disk high ($disk_usage%)"
fi

# -------- Save to CSV --------
echo "$timestamp,$cpu_usage,$ram_usage,$disk_usage" >> "$CSV_FILE"

log "INFO: CPU=$cpu_usage% RAM=$ram_usage% DISK=$disk_usage%"

