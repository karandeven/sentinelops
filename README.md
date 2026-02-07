# SentinelOps – Linux System Monitoring with Bash
SentinelOps ek simple Linux system monitoring project hai jo maine Bash scripting
use karke banaya hai.

Is project ka main goal ye samajhna tha:
- CPU usage kaise nikalta hai
- RAM usage kaise calculate hota hai
- Disk usage ka data kaise collect aur log kiya jaata hai

## Who is this project for?

Ye project Linux beginners aur DevOps aspirants ke liye hai
jo Bash scripting ke through system monitoring samajhna chahte hain.

Ye production-grade monitoring tool nahi hai.
Ye ek learning-focused project hai.


---

## What this project does

Ye script system se ye cheezein collect karta hai:

- CPU usage
- RAM usage
- Disk usage
- Current time (timestamp)

Aur har run pe ye data:
- terminal pe show hota hai
- ek CSV file (`system_metrics.csv`) mein save ho jaata hai

---

## Tech used

- Ubuntu (WSL2)
- Bash scripting
- Git & GitHub

---

## How it works

1. Script start hoti hai  
2. Current time nikalti hai  
3. CPU, RAM aur Disk ka usage read karti hai  
4. Data terminal pe print hota hai  
5. Same data CSV file mein append ho jaata hai  

---

## Sample output
Time: 2026-02-06 23:30:09
CPU Usage: 1.26 %
RAM Usage: 11.95 %
Disk Usage: 1%

---

## What I learned

- Linux system metrics kaise kaam karte hain
- Bash scripting basics
- Git & GitHub workflow
- Real project banana aur GitHub pe host karna

---

## Current status

Phase 1 complete hai.  
Script stable hai aur properly kaam kar rahi hai.

---

## Future plans

- Cron job automation
- Grafana visualization
- AWS EC2 deployment

