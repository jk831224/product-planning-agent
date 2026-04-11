#!/bin/bash
# checkpoint-prd.sh — 手動存檔當前 PRD 狀態（RPG-style save point）
# 用法：
#   ./scripts/checkpoint-prd.sh <prd-file> [label]
#
# 範例：
#   ./scripts/checkpoint-prd.sh deliverables/FitLog-PRD.md
#   ./scripts/checkpoint-prd.sh deliverables/FitLog-PRD.md "before-story-map-refactor"

set -euo pipefail

PRD_FILE="${1:?請提供 PRD 檔案路徑，例如：./scripts/checkpoint-prd.sh deliverables/FitLog-PRD.md}"
LABEL="${2:-}"

if [ ! -f "$PRD_FILE" ]; then
    echo "❌ 檔案不存在：${PRD_FILE}"
    exit 1
fi

FILENAME=$(basename "$PRD_FILE")
PRODUCT_NAME="${FILENAME%-PRD.md}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HISTORY_DIR="${REPO_ROOT}/.prd-history/${PRODUCT_NAME}"

mkdir -p "$HISTORY_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
if [ -n "$LABEL" ]; then
    SAFE_LABEL=$(echo "$LABEL" | tr -cs 'A-Za-z0-9_\-' '-' | sed 's/^-*//;s/-*$//')
    CHECKPOINT_FILE="${HISTORY_DIR}/${TIMESTAMP}-${SAFE_LABEL}.md"
else
    CHECKPOINT_FILE="${HISTORY_DIR}/${TIMESTAMP}.md"
fi

cp "$PRD_FILE" "$CHECKPOINT_FILE"

TBD_COUNT=$(grep -c '\[TBD' "$CHECKPOINT_FILE" || true)
CHECKPOINT_COUNT=$(find "$HISTORY_DIR" -maxdepth 1 -name '*.md' -type f | wc -l | tr -d ' ')

echo "💾 已存檔：${PRODUCT_NAME}"
echo "   檔名：$(basename "$CHECKPOINT_FILE")"
if [ -n "$LABEL" ]; then
    echo "   標籤：${LABEL}"
fi
echo "   當前 [TBD]：${TBD_COUNT} 個"
echo "   ${PRODUCT_NAME} 共有 ${CHECKPOINT_COUNT} 個存檔"
echo ""
echo "💡 若要反悔，說「讀檔」或執行：./scripts/restore-prd.sh ${PRODUCT_NAME}"
