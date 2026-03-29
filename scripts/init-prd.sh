#!/bin/bash
# init-prd.sh — 初始化一份新的 PRD 骨架
# 用法：./scripts/init-prd.sh <產品名稱>

set -euo pipefail

PRODUCT_NAME="${1:?請提供產品名稱，例如：./scripts/init-prd.sh my-product}"
DELIVERABLES_DIR="$(cd "$(dirname "$0")/.." && pwd)/deliverables"
PRD_FILE="${DELIVERABLES_DIR}/${PRODUCT_NAME}-PRD.md"
TODAY=$(date +%Y-%m-%d)

# 檢查是否已存在
if [ -f "$PRD_FILE" ]; then
    echo "⚠️  ${PRD_FILE} 已存在。"
    echo "如果要重新初始化，請先刪除或改名。"
    exit 1
fi

# 確保 deliverables/ 存在
mkdir -p "$DELIVERABLES_DIR"

# 產出 PRD 骨架
cat > "$PRD_FILE" << 'TEMPLATE'
# PRODUCT_NAME_PLACEHOLDER PRD

| 項目 | 內容 |
|------|------|
| PM | [TBD] |
| 優先度 | [TBD] |
| 狀態 | Planning |
| 需求來源 | [TBD] |
| Cynefin 情境 | [TBD] |
| 建立日期 | DATE_PLACEHOLDER |

---

## 1. Goals
### 1.1 商業目標
[TBD]

### 1.2 版本目標（MVP scope）
[TBD]

---

## 2. User Request
### 2.1 Persona
[TBD]

### 2.2 痛點
[TBD]

### 2.3 需求（HMW）
[TBD]

---

## 3. Feature List
[TBD]

---

## 4. User Story Map
[TBD]

---

## 5. User Story（含 GWT 驗收標準）
[TBD]

---

## 6. Use Case
[TBD — 複雜流程才需要]

---

## 7. User Journey
[TBD]

---

## 8. 非功能性需求
[TBD]

---

## 9. 測試驗收（UAT 初稿）
[TBD]

---

## 10. 成功指標
[TBD]

---

## 11. 未來展望
[TBD]
TEMPLATE

# 替換 placeholder
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/PRODUCT_NAME_PLACEHOLDER/${PRODUCT_NAME}/g" "$PRD_FILE"
    sed -i '' "s/DATE_PLACEHOLDER/${TODAY}/g" "$PRD_FILE"
else
    sed -i "s/PRODUCT_NAME_PLACEHOLDER/${PRODUCT_NAME}/g" "$PRD_FILE"
    sed -i "s/DATE_PLACEHOLDER/${TODAY}/g" "$PRD_FILE"
fi

echo "✅ PRD 骨架已建立：${PRD_FILE}"
echo ""
echo "📊 段落統計："
TBD_COUNT=$(grep -c '\[TBD' "$PRD_FILE" || true)
echo "   [TBD] 佔位符：${TBD_COUNT} 個"
echo ""
echo "下一步：開 Preview 看 PRD，告訴我要從哪裡開始填。"
