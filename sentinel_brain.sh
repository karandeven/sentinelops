#!/bin/bash
set -o pipefail
# ================== CONFIG ==================
LOG_FILE="sentinel.log"
CSV_FILE="system_metrics.csv"

CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=90
# ============================================

# ---------- Logger ----------
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}
safe_run() {
  "$@" || {
    log "ERROR: Command failed -> $*"
    echo "ERROR: Something went wrong. Check sentinel.log"
    exit 1
  }
}



# ---------- CSV header ----------
init_csv() {
  if [ ! -f "$CSV_FILE" ]; then
    echo "time,cpu,ram,disk" > "$CSV_FILE"
  fi
}

# ---------- Metrics ----------
get_cpu() {
  top -bn1 | awk '/Cpu/ {print $2}'
}

get_ram() {
  free | awk '/Mem:/ {printf "%.2f", $3*100/$2}'
}

get_disk() {
  df / | awk 'NR==2 {print $5}'
}

# ---------- Alerts ----------
check_thresholds() {
  local cpu_int=${1%.*}
  local ram_int=${2%.*}
  local disk_int=${3%\%}

  cpu_int=${cpu_int:-0}
  ram_int=${ram_int:-0}
  disk_int=${disk_int:-0}

  if [ "$cpu_int" -ge "$CPU_THRESHOLD" ]; then
    echo "WARNING: High CPU usage!"
    log "WARNING: High CPU usage detected (${1}%)"
  fi

  if [ "$ram_int" -ge "$RAM_THRESHOLD" ]; then
    echo "WARNING: High RAM usage!"
    log "WARNING: High RAM usage detected (${2}%)"
  fi

  if [ "$disk_int" -ge "$DISK_THRESHOLD" ]; then
    echo "CRITICAL: Disk almost full!"
    log "CRITICAL: Disk usage critical (${3})"
  fi
}

# ================== MAIN ==================
log "INFO: Script started"
init_csv

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
cpu_usage=$(safe_run get_cpu)
ram_usage=$(safe_run get_ram)
disk_usage=$(safe_run get_disk)


echo "SentinelOps Brain started"
echo "Time: $timestamp"
echo "CPU Usage: $cpu_usage %"
echo "RAM Usage: $ram_usage %"
echo "Disk Usage: $disk_usage"

echo "$timestamp,$cpu_usage,$ram_usage,$disk_usage" >> "$CSV_FILE"
log "INFO: CPU=${cpu_usage}% RAM=${ram_usage}% DISK=${disk_usage}"

check_thresholds "$cpu_usage" "$ram_usage" "$disk_usage"

