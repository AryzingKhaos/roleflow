#!/bin/bash
# ESLint Hook 调试脚本

# 日志文件
LOG_FILE=".claude/hooks/eslint-hook.log"

# 读取 stdin 到变量
INPUT=$(cat)

# 写入日志
{
  echo "==========================================="
  echo "🔍 ESLint Hook 已触发！时间: $(date)"
  echo "==========================================="
  echo "Hook Input: $INPUT"

  # 提取文件路径
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

  echo "📁 File Path: $FILE_PATH"
  echo "📂 Working Directory: $(pwd)"

  # 检查文件是否存在
  if [ ! -f "$FILE_PATH" ]; then
    echo "⚠️  Warning: File not found: $FILE_PATH"
    exit 0
  fi

  # 执行 ESLint 自动修复
  echo "🔧 Running ESLint --fix on: $FILE_PATH"
  pnpm exec eslint --fix "$FILE_PATH" 2>&1
  ESLINT_EXIT_CODE=$?

  echo "✅ ESLint exit code: $ESLINT_EXIT_CODE"
  echo "==========================================="
  echo ""
} >> "$LOG_FILE" 2>&1

# 同时输出到 stderr
echo "🔍 ESLint Hook executed. Check .claude/hooks/eslint-hook.log for details" >&2

# 总是返回 0，不阻止操作
exit 0
