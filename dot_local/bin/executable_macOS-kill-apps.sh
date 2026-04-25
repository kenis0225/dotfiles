#!/bin/zsh

macOS-kill-apps() {
  local selected
  # 1. ps -ww -eo: 自定义输出 PID、运行时间、以及完整的命令路径
  # 2. grep: 仅匹配 /Applications 路径下的进程
  # 3. awk: 格式化输出，把路径末尾的 App 名字提取到前面，方便阅读
  selected=$(ps -ww -eo pid,time,command | grep "/Applications/" | grep -v "grep" | awk '{
    path=$3;
    # 提取路径中以 .app 结尾的部分作为名称
    split(path, a, "/");
    for (i in a) { if (a[i] ~ /\.app$/) appname=a[i] }
    if (appname == "") appname=a[split(path, a, "/")]
    printf "%-8s | %-10s | %-25s | %s\n", $1, $2, appname, path
  }' | fzf -m --header='PID      | TIME       | APP NAME                  | FULL PATH' --preview 'echo {} | awk -F "|" "{print \"Full Command: \" \$4}"' --preview-window=top:3:wrap)

  if [ -n "$selected" ]; then
    # 提取第一列的 PID 并杀死
    echo "$selected" | awk '{print $1}' | xargs kill -9
    echo "已清理选中的进程。"
  fi
}

macOS-kill-apps
