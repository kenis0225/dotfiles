#!/bin/bash

# 检查是否安装 xclip
if ! command -v xclip &> /dev/null; then
    echo "xclip is not installed. Installing xclip using pacman..."
    sudo pacman -Syu xclip --noconfirm
fi

# 使用 xclip 从剪贴板中获取内容
domain=$(xclip -selection clipboard -o)

# 检查剪贴板是否为空
if [ -z "$domain" ]; then
    echo "Clipboard is empty. Please copy a domain name to the clipboard and try again."
    exit 1
fi

# 拼接 URL
favicon_url="https://www.google.com/s2/favicons?domain=$domain"

# 将结果复制回剪贴板
echo -n "$favicon_url" | xclip -selection clipboard

# 使用 notify-send 显示通知
notify-send "GetFavicon URL" "Favicon URL has been copied to clipboard: $favicon_url"
# 打印到终端
echo "Get Favicon URL has been copied to clipboard: $favicon_url"
