#!/bin/bash
# prd-status.sh — 掃描所有 PRD 的完成度
# 用法：./scripts/prd-status.sh

set -euo pipefail

DELIVERABLES_DIR="$(cd "$(dirname "$0")/.." && pwd)/deliverables"

# 檢查 deliverables/ 是否存在
if [ ! -d "$DELIVERABLES_DIR" ]; then
    echo "📭 deliverables/ 不存在。要開始新的產品企劃嗎？"
    exit 0
fi

# 找所有 PRD 檔案
PRD_FILES=$(find "$DELIVERABLES_DIR" -name "*-PRD.md" -type f 2>/dev/null | sort)

if [ -z "$PRD_FILES" ]; then
    echo "📭 deliverables/ 下沒有 PRD 檔案。要開始新的產品企劃嗎？"
    exit 0
fi

echo "📋 PRD 狀態總覽"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for prd in $PRD_FILES; do
    FILENAME=$(basename "$prd")
    PRODUCT_NAME="${FILENAME%-PRD.md}"

    # 計算 [TBD] 數量
    TOTAL_TBD=$(grep -c '\[TBD' "$prd" || true)

    # 計算總段落數（## 開頭的段落）
    TOTAL_SECTIONS=$(grep -c '^## ' "$prd" || true)

    # 計算已填寫的段落（有 ## 但下方沒有 [TBD] 的段落）
    # 簡化：用 [TBD] 數量推算完成度
    if [ "$TOTAL_TBD" -eq 0 ]; then
        STATUS="✅ 完成"
        PROGRESS="100%"
    elif [ "$TOTAL_TBD" -le 2 ]; then
        STATUS="🟡 接近完成"
        PROGRESS="~90%"
    elif [ "$TOTAL_TBD" -le 5 ]; then
        STATUS="🔵 進行中"
        PROGRESS="~60%"
    elif [ "$TOTAL_TBD" -le 8 ]; then
        STATUS="🔵 進行中"
        PROGRESS="~30%"
    else
        STATUS="⬜ 剛開始"
        PROGRESS="~10%"
    fi

    echo ""
    echo "  📄 ${PRODUCT_NAME}"
    echo "     狀態：${STATUS} (${PROGRESS})"
    echo "     剩餘 [TBD]：${TOTAL_TBD} 個"

    # 列出哪些段落還是 TBD
    if [ "$TOTAL_TBD" -gt 0 ]; then
        echo "     待填段落："
        # 找出包含 [TBD] 的段落標題
        grep -B5 '\[TBD' "$prd" | grep '^## \|^### ' | sort -u | while read -r line; do
            echo "       - ${line}"
        done
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Handoff 提醒
for prd in $PRD_FILES; do
    TOTAL_TBD=$(grep -c '\[TBD' "$prd" || true)
    FILENAME=$(basename "$prd")
    PRODUCT_NAME="${FILENAME%-PRD.md}"
    if [ "$TOTAL_TBD" -le 2 ] && [ "$TOTAL_TBD" -gt 0 ]; then
        echo "💡 ${PRODUCT_NAME} 快完成了！填完剩餘 ${TOTAL_TBD} 個 [TBD] 就可以 handoff。"
    elif [ "$TOTAL_TBD" -eq 0 ]; then
        echo "🚀 ${PRODUCT_NAME} 已完成！可以說「handoff」交給 spec-forge-agent。"
    fi
done
