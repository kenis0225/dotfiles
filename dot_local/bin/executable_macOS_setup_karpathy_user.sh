#!/usr/bin/env bash
set -euo pipefail

# 定义下载的源文件URL
SOURCE_URL="https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md"

# 定义目标安装位置数组（包含完整路径）
INSTALL_PATHS=(
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.codex/AGENTS.md"
  "$HOME/.config/opencode/AGENTS.md"
)

# 遍历所有目标路径
for target_path in "${INSTALL_PATHS[@]}"; do
  # 提取目标目录和文件名
  target_dir=$(dirname "${target_path}")
  target_file=$(basename "${target_path}")

  # 检查文件是否已存在
  if [ -f "${target_path}" ]; then
    echo "✅ 文件已存在，跳过: ${target_path}"
    continue
  fi

  # 目录不存在则创建
  if [ ! -d "${target_dir}" ]; then
    echo "📁 创建目录: ${target_dir}"
    mkdir -p "${target_dir}"
  fi

  echo "⬇️  正在下载文件到: ${target_path}"
  # curl 失败会直接终止脚本
  curl -sSL --fail "${SOURCE_URL}" -o "${target_path}"

  # 非CLAUDE.md文件需要执行内容替换
  if [ "${target_file}" != "CLAUDE.md" ]; then
    echo "🔄 执行内容替换: CLAUDE.md -> AGENTS.md"
    sed -i.bak 's/CLAUDE.md/AGENTS.md/g' "${target_path}"
    rm -f "${target_path}.bak"
  fi

  echo "✅ 完成: ${target_path}"
  echo "----------------------------------------"
done

echo "🎉 所有文件处理完成！"
