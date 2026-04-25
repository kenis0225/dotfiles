#!/bin/bash
set -euo pipefail

TRZSZ_BIN="trzsz"
INSTALL_PATH="/usr/local/bin"
DOWNLOAD_URL="https://gitee.com/trzsz/trzsz-go/releases/download/v1.1.8/trzsz_1.1.8_linux_x86_64.tar.gz"
TEMP_DIR=$(mktemp -d)

if command -v "$TRZSZ_BIN" &> /dev/null; then
  echo -e "\033[32m✅ 检测到 $TRZSZ_BIN 已安装，当前版本：\033[0m"
  "$TRZSZ_BIN" --version
  exit 0
fi

echo -e "\033[33mℹ️  未检测到 $TRZSZ_BIN，开始自动安装...\033[0m"

if ! command -v "tar" &> /dev/null; then
  echo -e "\033[31m❌ 缺少依赖工具：tar，请先安装后重试\033[0m"
  exit 1
fi

if command -v "curl" &> /dev/null; then
  DOWNLOAD_TOOL="curl"
elif command -v "wget" &> /dev/null; then
  DOWNLOAD_TOOL="wget"
else
  echo -e "\033[31m❌ 缺少下载工具（curl/wget），请先安装后重试\033[0m"
  exit 1
fi

echo -e "\033[34m📥 正在从以下地址下载：\033[0m"
echo "$DOWNLOAD_URL"
cd "$TEMP_DIR" || exit 1

if [ "$DOWNLOAD_TOOL" = "curl" ]; then
  curl -fSL "$DOWNLOAD_URL" -o "trzsz.tar.gz"
else
  wget -q --show-progress "$DOWNLOAD_URL" -O "trzsz.tar.gz"
fi

echo -e "\033[34m📦 正在解压文件...\033[0m"
tar -zxf "trzsz.tar.gz" --strip-components=1 -C "$TEMP_DIR"

if [ ! -f "$TRZSZ_BIN" ]; then
  echo -e "\033[31m❌ 解压失败或压缩包内无 $TRZSZ_BIN 可执行文件\033[0m"
  rm -rf "$TEMP_DIR"
  exit 1
fi

echo -e "\033[34m🚀 正在部署到 $INSTALL_PATH...\033[0m"
sudo mv "trzsz" "$INSTALL_PATH/"
sudo mv "trz" "$INSTALL_PATH/"
sudo mv "tsz" "$INSTALL_PATH/"

rm -rf "$TEMP_DIR"

if command -v "$TRZSZ_BIN" &> /dev/null; then
  echo -e "\033[32m🎉 $TRZSZ_BIN 安装成功！当前版本：\033[0m"
  "$TRZSZ_BIN" --version
else
  echo -e "\033[31m❌ $TRZSZ_BIN 安装失败，请检查权限或路径配置\033[0m"
  exit 1
fi
