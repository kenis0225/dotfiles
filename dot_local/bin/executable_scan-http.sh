#!/bin/bash

# 检查参数数量是否正确
if [ $# -ne 2 ]; then
    echo "用法: $0 <网段> <端口>"
    echo "示例: $0 192.168.1.0/24 8181"
    exit 1
fi

NETWORK=$1
PORT=$2
OUTPUT_FILE="http_${PORT}_ips.txt"

# 清空输出文件
> $OUTPUT_FILE

echo "开始扫描网段 $NETWORK 的 $PORT 端口HTTP服务..."
echo "结果将保存到 $OUTPUT_FILE"

# 扫描指定网段的指定端口
nmap -p $PORT -T4 -n -Pn $NETWORK -oG - | grep "${PORT}/open" | awk '{print $2}' | while read IP; do
    echo "检查 $IP:$PORT ..."
    # 使用curl检查是否为HTTP服务，超时5秒，只获取头部
    if curl -s --connect-timeout 5 -I "http://$IP:$PORT" | grep -q "HTTP/"; then
        echo "$IP" >> $OUTPUT_FILE
        echo "$IP:$PORT 是HTTP服务，已记录"
    fi
done

echo "扫描完成，共发现 $(wc -l < $OUTPUT_FILE) 个提供 $PORT 端口HTTP服务的IP"
