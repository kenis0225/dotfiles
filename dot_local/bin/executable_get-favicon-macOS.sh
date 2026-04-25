
#!/bin/bash

# 使用 pbpaste 从剪贴板中获取内容
domain=$(pbpaste)

# 检查剪贴板是否为空
if [ -z "$domain" ]; then
    echo "Clipboard is empty. Please copy a domain name to the clipboard and try again."
    exit 1
fi

# 拼接 URL
favicon_url="https://www.google.com/s2/favicons?domain=$domain"

# 将结果复制回剪贴板
echo -n "$favicon_url" | pbcopy

# 打印到终端
echo "Get Favicon URL has been copied to clipboard: $favicon_url"
