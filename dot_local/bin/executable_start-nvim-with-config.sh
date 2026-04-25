#!/bin/zsh

function start-nvim-with-config() {
  local config_dir="$HOME/.config"

  # 1. 使用 zsh 的通配符 (n) 查找目录。nvim*表示匹配开头，(/) 表示只匹配目录
  # 这比 find 命令更简洁，且能自动处理包含空格的文件名
  local nvim_configs=($config_dir/nvim*(/))

  # 2. 检查列表是否为空 (zsh 中数组索引从 1 开始)
  if [ ${#nvim_configs} -eq 0 ]; then
    echo "错误：在 $config_dir 中没有找到以 'nvim' 开头的配置目录。"
    return 1
  fi

  # 3. 使用 (F) 标志将数组按换行符展开，传给 fzf
  local selected_config=$(printf '%s\n' "${nvim_configs[@]}" | fzf --prompt "选择一个 Neovim 配置: ")

  # 4. 检查用户是否取消
  if [ -z "$selected_config" ]; then
    echo "操作已取消。"
    return 0
  fi

  # 5. 提取目录名并启动 nvim
  local nvim_appname=$(basename "$selected_config")
  echo "正在使用配置: $nvim_appname"
  
  NVIM_APPNAME="$nvim_appname" nvim
}

start-nvim-with-config