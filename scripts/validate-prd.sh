#!/bin/bash
# validate-prd.sh — Handoff 前的品質檢查
# 用法：./scripts/validate-prd.sh <prd-file>
# 或：  ./scripts/validate-prd.sh（自動掃描最新的 PRD）

set -euo pipefail

DELIVERABLES_DIR="$(cd "$(dirname "$0")/.." && pwd)/deliverables"

# 決定要檢查哪個檔案
if [ -n "${1:-}" ]; then
    PRD_FILE="$1"
else
    # 自動找最新的 PRD
    PRD_FILE=$(find "$DELIVERABLES_DIR" -name "*-PRD.md" -type f -exec ls -t {} + 2>/dev/null | head -1)
    if [ -z "$PRD_FILE" ]; then
        echo "❌ 找不到 PRD 檔案。"
        exit 1
    fi
fi

if [ ! -f "$PRD_FILE" ]; then
    echo "❌ 檔案不存在：${PRD_FILE}"
    exit 1
fi

FILENAME=$(basename "$PRD_FILE")
PRODUCT_NAME="${FILENAME%-PRD.md}"

echo "🔍 品質檢查：${PRODUCT_NAME}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PASS=0
WARN=0
FAIL=0

# === 1. 完成度檢查 ===
TBD_COUNT=$(grep -c '\[TBD' "$PRD_FILE" || true)
if [ "$TBD_COUNT" -eq 0 ]; then
    echo "✅ 完成度：所有段落已填寫"
    PASS=$((PASS + 1))
elif [ "$TBD_COUNT" -le 2 ]; then
    echo "⚠️  完成度：還有 ${TBD_COUNT} 個 [TBD]"
    WARN=$((WARN + 1))
else
    echo "❌ 完成度：還有 ${TBD_COUNT} 個 [TBD]，建議先填完再 handoff"
    FAIL=$((FAIL + 1))
fi

# === 2. spec-forge 四要素檢查 ===
echo ""
echo "📋 spec-forge 四要素（Actor / Event / Command / Rule）："

# Actor：檢查 Persona 段落是否有內容
if grep -q '### 2.1 Persona' "$PRD_FILE" && ! grep -A2 '### 2.1 Persona' "$PRD_FILE" | grep -q '\[TBD\]'; then
    echo "  ✅ Actor：Persona 已定義"
    PASS=$((PASS + 1))
else
    echo "  ❌ Actor：Persona 未定義（§2.1）"
    FAIL=$((FAIL + 1))
fi

# Event：檢查 User Journey 或 User Story
HAS_JOURNEY=false
HAS_STORY=false
if grep -q '## 7. User Journey' "$PRD_FILE" && ! grep -A2 '## 7. User Journey' "$PRD_FILE" | grep -q '\[TBD\]'; then
    HAS_JOURNEY=true
fi
if grep -q '## 5. User Story' "$PRD_FILE" && ! grep -A2 '## 5. User Story' "$PRD_FILE" | grep -q '\[TBD\]'; then
    HAS_STORY=true
fi
if $HAS_JOURNEY || $HAS_STORY; then
    echo "  ✅ Event：有用戶操作描述"
    PASS=$((PASS + 1))
else
    echo "  ❌ Event：User Journey（§7）或 User Story（§5）需要填寫"
    FAIL=$((FAIL + 1))
fi

# Command：檢查 Feature List
if grep -q '## 3. Feature List' "$PRD_FILE" && ! grep -A2 '## 3. Feature List' "$PRD_FILE" | grep -q '\[TBD\]'; then
    echo "  ✅ Command：Feature List 已定義"
    PASS=$((PASS + 1))
else
    echo "  ❌ Command：Feature List 未定義（§3）"
    FAIL=$((FAIL + 1))
fi

# Rule：檢查是否有 GWT 驗收標準
if grep -qi 'given\|when.*then\|驗收標準' "$PRD_FILE"; then
    echo "  ✅ Rule：找到驗收標準 / GWT"
    PASS=$((PASS + 1))
else
    echo "  ⚠️  Rule：建議在 User Story 中加入 GWT 驗收標準"
    WARN=$((WARN + 1))
fi

# === 3. 六大浪費預防 ===
echo ""
echo "🗑️  六大浪費預防檢查："

# 檢查 User Story 是否存在（半成品預防）
STORY_COUNT=$(grep -c 'US-' "$PRD_FILE" || true)
if [ "$STORY_COUNT" -ge 1 ]; then
    echo "  ✅ 半成品預防：有 ${STORY_COUNT} 個 User Story"
    PASS=$((PASS + 1))
else
    echo "  ⚠️  半成品預防：建議定義 User Story 以便切分工作"
    WARN=$((WARN + 1))
fi

# 檢查 MVP 範圍是否明確
if grep -qi 'MVP\|Feature List' "$PRD_FILE" && ! grep -A2 '## 3. Feature List' "$PRD_FILE" | grep -q '\[TBD\]'; then
    echo "  ✅ 範圍控制：MVP Feature List 已定義"
    PASS=$((PASS + 1))
else
    echo "  ⚠️  範圍控制：建議明確定義 MVP 範圍，避免 scope creep"
    WARN=$((WARN + 1))
fi

# === 4. 進階段落檢查 ===
echo ""
echo "📊 進階段落（可選但建議有）："

# 非功能性需求
if grep -q '## 8. 非功能性需求' "$PRD_FILE" && ! grep -A2 '## 8. 非功能性需求' "$PRD_FILE" | grep -q '\[TBD\]'; then
    echo "  ✅ 非功能性需求已填寫"
else
    echo "  💡 非功能性需求（§8）未填 — 建議至少定義效能和安全需求"
fi

# 成功指標
if grep -q '## 10. 成功指標' "$PRD_FILE" && ! grep -A2 '## 10. 成功指標' "$PRD_FILE" | grep -q '\[TBD\]'; then
    echo "  ✅ 成功指標已填寫"
else
    echo "  💡 成功指標（§10）未填 — 建議至少定義一個核心指標"
fi

# === 總結 ===
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "結果：✅ ${PASS} 通過 | ⚠️ ${WARN} 警告 | ❌ ${FAIL} 未通過"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo "🚀 可以 handoff！說「handoff」或「交付」觸發 /handoff-to-spec-forge。"
    exit 0
elif [ "$FAIL" -le 2 ]; then
    echo "⚡ 接近可交付。建議先處理上方 ❌ 項目。"
    exit 0
else
    echo "🔧 建議先補完核心段落再 handoff。"
    exit 1
fi
