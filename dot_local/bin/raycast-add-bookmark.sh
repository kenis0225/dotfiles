#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Add URL to Feishu Bitable
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔗
# @raycast.description Paste clipboard URL into Feishu Bitable

# ====== 配置区 ======
APP_TOKEN="ERbzb2zA8a4BgUspF1tctm2OnjS"
TABLE_ID="tblpoOFO15n2hsCV"
ACCESS_TOKEN="u-e6LA7aS01eHog9_DQ70a9cg4m0zA4hiPhgwaJwM00xrF"

# 从剪贴板读取 URL（macOS）
URL_TEXT="$(pbpaste | tr -d '\n')"

# ====== 简单校验 ======
if [ -z "$URL_TEXT" ]; then
  echo "❌ 剪贴板为空，未获取到 URL"
  exit 1
fi

# ====== 新增多维表格记录 ======
curl -i -X POST "https://open.feishu.cn/open-apis/bitable/v1/apps/${APP_TOKEN}/tables/${TABLE_ID}/records" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer ${ACCESS_TOKEN}" \
-d "{
  \"fields\": {
    \"URL\": \"${URL_TEXT}\"
  }
}"
