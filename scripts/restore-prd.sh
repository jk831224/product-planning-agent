#!/bin/bash
# restore-prd.sh — 列出或還原 PRD 存檔（RPG-style load）
# 用法：
#   ./scripts/restore-prd.sh <product-name>               列出所有存檔
#   ./scripts/restore-prd.sh <product-name> --latest      還原到最新存檔
#   ./scripts/restore-prd.sh <product-name> --to <檔名>   還原到指定存檔

set -euo pipefail

PRODUCT_NAME="${1:?請提供產品名稱，例如：./scripts/restore-prd.sh FitLog}"
MODE="${2:-list}"
TARGET="${3:-}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HISTORY_DIR="${REPO_ROOT}/.prd-history/${PRODUCT_NAME}"
PRD_FILE="${REPO_ROOT}/deliverables/${PRODUCT_NAME}-PRD.md"

if [ ! -d "$HISTORY_DIR" ]; then
    echo "📭 ${PRODUCT_NAME} 還沒有任何存檔"
    echo "   先用：./scripts/checkpoint-prd.sh deliverables/${PRODUCT_NAME}-PRD.md"
    exit 0
fi

list_checkpoints() {
    echo "💾 ${PRODUCT_NAME} 存檔列表（新到舊）"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    local idx=0
    # shellcheck disable=SC2012
    for f in $(ls -1t "$HISTORY_DIR"); do
        idx=$((idx + 1))
        local tbd
        tbd=$(grep -c '\[TBD' "${HISTORY_DIR}/${f}" || true)
        printf "  %2d. %s   [TBD: %s]\n" "$idx" "$f" "$tbd"
    done
    echo ""
    echo "還原方式："
    echo "  ./scripts/restore-prd.sh ${PRODUCT_NAME} --latest          # 還原到最新存檔"
    echo "  ./scripts/restore-prd.sh ${PRODUCT_NAME} --to <檔名>        # 還原到指定存檔"
}

# List 模式（預設）
if [ "$MODE" = "list" ] || [ "$MODE" = "--list" ]; then
    list_checkpoints
    exit 0
fi

# 決定還原目標
if [ "$MODE" = "--latest" ]; then
    # shellcheck disable=SC2012
    TARGET_FILE=$(ls -1t "$HISTORY_DIR" | head -1)
    if [ -z "$TARGET_FILE" ]; then
        echo "❌ ${PRODUCT_NAME} 沒有存檔可還原"
        exit 1
    fi
elif [ "$MODE" = "--to" ]; then
    if [ -z "$TARGET" ]; then
        echo "❌ --to 需要指定存檔檔名"
        echo ""
        list_checkpoints
        exit 1
    fi
    TARGET_FILE="$TARGET"
else
    echo "❌ 未知模式：${MODE}"
    echo "   支援：--latest, --to <檔名>，或不帶參數列出所有存檔"
    exit 1
fi

CHECKPOINT_PATH="${HISTORY_DIR}/${TARGET_FILE}"
if [ ! -f "$CHECKPOINT_PATH" ]; then
    echo "❌ 找不到存檔：${TARGET_FILE}"
    echo ""
    list_checkpoints
    exit 1
fi

# 還原前，先把當前版本另存為 pre-restore 存檔（雙向可逆）
if [ -f "$PRD_FILE" ]; then
    PRE_RESTORE_TS=$(date +%Y%m%d-%H%M%S)
    PRE_RESTORE_FILE="${HISTORY_DIR}/${PRE_RESTORE_TS}-pre-restore.md"
    cp "$PRD_FILE" "$PRE_RESTORE_FILE"
    echo "🔒 還原前：當前版本已保留為 $(basename "$PRE_RESTORE_FILE")"
fi

# 執行還原
cp "$CHECKPOINT_PATH" "$PRD_FILE"
TBD_COUNT=$(grep -c '\[TBD' "$PRD_FILE" || true)

echo "⏮  已還原：${TARGET_FILE}"
echo "   目標：${PRD_FILE}"
echo "   當前 [TBD]：${TBD_COUNT} 個"
echo ""
echo "💡 若要反悔還原操作，讀檔回剛才的 pre-restore 存檔即可。"
