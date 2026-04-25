#!/bin/zsh

# 获取指定网卡的IPv4网关地址，默认网卡为en0
function macOS-get-gateway-ipv4() {
  # 定义默认网卡为en0，如果用户传入参数则使用参数指定的网卡
  local nic=${1:-en0}
  
  # 过滤指定网卡的默认网关，并仅提取IPv4地址
  netstat -rn | grep "default.*${nic}" | awk '/\./ && !/:/ {print $2}'
}

macOS-get-gateway-ipv4