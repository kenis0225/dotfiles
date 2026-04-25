#!/bin/bash

# 检查参数数量是否正确（需要3个参数：目标目录、原文件名、新文件名）
if [ $# -ne 3 ]; then
  echo "用法: $0 <目标目录> <原文件名> <新文件名>"
  echo "示例: $0 /home/user/documents a.txt b.csv"
  echo "示例: $0 ./data old.log new.log"
  exit 1
fi

# 定义参数变量，提高可读性
TARGET_DIR="$1"   # 目标目录
OLD_FILENAME="$2" # 要查找的原文件名
NEW_FILENAME="$3" # 要替换成的新文件名

# 检查目标目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
  echo "错误: 目录 '$TARGET_DIR' 不存在！"
  exit 1
fi

# 递归查找指定文件名的文件并批量重命名
# -print0 和 read -d $'\0' 配合，处理包含空格/特殊字符的文件名
find "$TARGET_DIR" -type f -name "$OLD_FILENAME" -print0 | while read -r -d $'\0' file_path; do
# 提取文件所在目录，保证新文件仍在原目录
file_dir=$(dirname "$file_path")
# 构建新文件的完整路径
new_file_path="$file_dir/$NEW_FILENAME"

    # 检查新文件是否已存在，避免覆盖
    if [ -f "$new_file_path" ]; then
      echo "警告: $new_file_path 已存在，跳过重命名 $file_path"
      continue
    fi

    # 执行重命名并检查结果
    if mv "$file_path" "$new_file_path"; then
      echo "成功: $file_path -> $new_file_path"
    else
      echo "失败: 无法重命名 $file_path"
    fi
  done

  echo "批量重命名操作执行完成！"
