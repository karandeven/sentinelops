#!/bin/bash

# ===============================
# SentinelOps - System Monitor
# Author: karandeven
# ===============================

LOG_FILE="sentinel.log"
CSV_FILE="system_metrics.csv"

CPU_THRESHOLD=${CPU_THRESHOLD:-80}
RAM_THRESHOLD=${RAM_THRESHOLD:-80}
DISK_THRESHOLD=${DISK_THRESHOLD:-90}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Create CSV header once
if [ ! -f "$CSV_FILE" ]; then
  echo "time,cpu,ram,disk" > "$CSV_FILE"
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

CPU_USAGE=$(top -bn1 | awk '/Cpu/ {print 100 - $8}')
CPU_INT=${CPU_USAGE%.*}

RAM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3*100/$2}')
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "SentinelOps Brain started"
echo "Time: $TIMESTAMP"
echo "CPU Usage: $CPU_USAGE %"
echo "RAM Usage: $RAM_USAGE %"
echo "Disk Usage: $DISK_USAGE %"

log "INFO: Script started"

STATUS="INFO: System healthy"

if [ "$CPU_INT" -ge "$CPU_THRESHOLD" ]; then
  STATUS="ALERT: CPU high ($CPU_USAGE%)"
fi

if [ "$RAM_USAGE" -ge "$RAM_THRESHOLD" ]; then
  STATUS="ALERT: RAM high ($RAM_USAGE%)"
fi

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
  STATUS="ALERT: Disk high ($DISK_USAGE%)"
fi

log "$STATUS"

echo "$TIMESTAMP,$CPU_USAGE,$RAM_USAGE,$DISK_USAGE" >> "$CSV_FILE"

