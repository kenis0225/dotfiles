#!/bin/bash
export TERMUX_HOME=/data/data/com.termux/files/home
CURRENT_HOME=~

configs=(
    ".config/yazi"
    ".config/lazygit"
    ".config/fish/config.fish"
    ".gitconfig"
)

for config in "${configs[@]}"; do
    src="${TERMUX_HOME}/${config}"
    dest="${CURRENT_HOME}/${config}"

    if [ ! -e "$src" ]; then
        echo "警告：源路径 $src 不存在，跳过该链接"
        continue
    fi

    if [ -L "$dest" ]; then
        echo "删除已存在的旧链接：$dest"
        rm -f "$dest"
    elif [ -e "$dest" ]; then
        echo "错误：$dest 不是软链接，而是普通文件/目录，跳过（避免覆盖）"
        continue
    fi

    ln -s "$src" "$dest"
    echo "成功创建链接：$dest -> $src"
done

echo "软链接创建完成！"
