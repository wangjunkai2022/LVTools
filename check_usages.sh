#!/bin/bash
log_file="/logs/usage_log.log"

check_usage() {
    # 获取CPU使用率和内存使用率
    cpu_percent=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    memory_percent=$(free | awk '/Mem/{printf("%.2f"), $3/$2 * 100}')

    if (( cpu_percent >= 90 )) || (( memory_percent >= 90 )); then
        # 获取最占用资源的5个进程
        processes=$(get_top_processes)
        if (( cpu_percent >= 90 )); then
            # 记录CPU使用率较高的进程信息到日志
            log_usage "$processes" "CPU" "$cpu_percent"
        fi
        if (( memory_percent >= 90 )); then
            # 记录内存使用率较高的进程信息到日志
            log_usage "$processes" "内存" "$memory_percent"
        fi
    else
        # 记录当前CPU和内存占用情况到日志
        log_not_usage "$cpu_percent" "$memory_percent"
    fi
}

get_top_processes() {
    # 获取最占用资源的5个进程的PID和名称
    processes=$(ps -eo pid,comm --no-headers | sort -k 1 -r -n | head -n 5)
    echo "$processes"
}

log_usage() {
    kill_video_service
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "当前时间: $timestamp" >> "$log_file"
    echo "当前占用过高的是: $2" >> "$log_file"
    echo "占用率是: $3" >> "$log_file"
    echo "占用高的程序:" >> "$log_file"
    echo "$1" >> "$log_file"
    echo "" >> "$log_file"
}

log_not_usage(){
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "当前时间: $timestamp" >> "$log_file"
    echo "当前CUP占用: $1" >> "$log_file"
    echo "当前内存占用: $2" >> "$log_file"
    echo "" >> "$log_file"
}

kill_video_service(){
    echo "重启 emby 服务:" >> "$log_file"
    systemctl restart emby-server.service
    echo "重启 rclone 服务:" >> "$log_file"
    systemctl restart rclone.service
    echo "重启 alist 服务:" >> "$log_file"
    systemctl restart alist.service
}

while true; do
    check_usage
    sleep 60
done