# Handoff Protocol: product-planning-agent → spec-forge-agent

> 將產品企劃成果轉化為 spec-forge-agent 能消費的 PRD.md。
> 觸發詞：「交付」「handoff」「交給 spec-forge」「產出 PRD」

---

## 前置條件

至少完成 Double Diamond 的 **Define + Develop** 階段（有 HMW、User Story、MVP 範圍定義）。

如果只完成 Discover，資訊不足以產出有意義的 PRD — 提醒使用者先完成 Define。

---

## 映射規則

### 1. PRD 表頭

從產品規格摘要萃取：

```markdown
| 項目 | 內容 |
|------|------|
| PM | <使用者名稱> |
| 優先度 | <從機會評估表的優先級排序> |
| 狀態 | Planning |
| 需求來源 | <Persona 暱稱，逗號分隔> |
```

### 2. Goals（PRD §1）

**來源**：產品規格摘要的「核心問題」+「解決方案」

一段文字描述：
- 為什麼要做這件事（HMW 問題的背景）
- 預期達成的效果（解決方案的核心價值）

### 3. User Request（PRD §2）

#### 2.1 痛點

**來源**：痛點彙整表

每個痛點一個子段落，格式：

```markdown
#### P1. <痛點標題>
- <具體描述>
- 來源 Persona：<名稱>
- 影響程度：<高/中/低>
```

#### 2.2 需求

**來源**：HMW 問題轉化為需求陳述

將「我們可以如何...」改為明確的需求描述：

```markdown
#### R1. <需求標題>
- <需求描述，從 HMW 轉換>
```

### 4. Feature List（PRD §3）

**來源**：MVP 範圍定義

- **MVP 必須有** → 列為 Feature List 主體
- 按功能模組分群，每項用 `- [ ]` 格式
- V2 和未來考慮的項目不放在 Feature List，留到「未來展望」段落

### 5. User Journey（PRD §5）

**來源**：User Journey Map

每個關鍵 Journey 一個段落：

```markdown
### Journey N：<標題>

**情境：** <從 Journey Map 的階段情境描述>

| 階段 | 使用者操作 | 系統行為 |
|------|-----------|---------|
| <階段名> | <Doing 維度> | <系統應有的回應> |

**解決痛點：** <對應的痛點編號>
```

如果企劃階段的 Journey Map 沒有「系統行為」欄（通常不會有），該欄填 `-` 或標記 `[TBD]`。

### 6. User Story（PRD §6）

**來源**：User Story 表

按功能模組分群：

```markdown
| 編號 | User Story | 對應需求 |
|------|-----------|---------|
| US-01 | 身為[Persona]，我想要[功能]，以便[價值] | R1 |
```

- Persona 名稱從 User Story 表的 `[Persona]` 直接帶入
- 對應需求從 §2.2 的需求編號對應

### 7. 成功指標（PRD §附錄）

**來源**：成功指標表

```markdown
| 指標類型 | 指標名稱 | 定義 | 目標值 | 衡量方式 |
|---------|---------|------|-------|---------|
| 核心指標 | | | | |
| 次要指標 | | | | |
| 護欄指標 | | | | |
```

### 8. 未來展望（PRD §末段）

**來源**：MVP 範圍定義中的「V2 再加入」+「未來考慮」

```markdown
| 功能 | 說明 |
|------|------|
| <V2 項目> | <描述> |
| <未來考慮項目> | <描述> |
```

---

## PRD 完整結構

產出的 PRD 遵循以下結構：

```markdown
# <產品名稱> PRD

| 項目 | 內容 |
|------|------|
| PM | <名稱> |
| 優先度 | <優先級> |
| 狀態 | Planning |
| 需求來源 | <Persona 暱稱> |

---

## 1. Goals

<從產品規格摘要>

---

## 2. User Request

### 2.1 痛點

<從痛點彙整表>

### 2.2 需求

<從 HMW 轉需求>

---

## 3. Feature List

<從 MVP 範圍>

---

## 4. User Journey

<從 User Journey Map>

---

## 5. User Story

<從 User Story 表>

---

## 6. 成功指標

<從成功指標表>

---

## 7. 未來展望

<從 MVP 的 V2 + 未來考慮>
```

---

## 執行步驟

1. **檢查前置條件**：確認 `deliverables/` 下有完成的企劃報告，且至少完成 Define + Develop
2. **載入企劃報告**：讀取 `deliverables/<產品名>-report.html`（或對話中已有的企劃產出）
3. **逐段映射**：依上方映射規則，從企劃產出中萃取內容，填入 PRD 結構
4. **產出 PRD**：寫入 `deliverables/<產品名>-PRD.md`
5. **品質檢查**：確認 PRD 包含 spec-forge-agent Phase 0 所需的元素：
   - [ ] **Actor**（角色）：至少一個明確的 Actor（來自 Persona）
   - [ ] **Event**（事件）：至少有用戶操作描述（來自 Journey / User Story）
   - [ ] **Command**（命令）：至少有功能描述（來自 Feature List）
   - [ ] **Rule**（規則）：至少有驗收標準或業務規則（來自 User Story 驗收標準）
6. **告知使用者下一步**：
   - PRD 已產出在 `deliverables/<產品名>-PRD.md`
   - 複製到 `spec-forge-agent/Projects/<專案名>/PRD.md`
   - 在 spec-forge-agent 中執行 `/spec-formulate`

---

## 行為規則

- **不腦補**：只映射企劃報告中已有的內容，不補充或推測
- **標記缺口**：企劃報告中缺少的段落，在 PRD 中標記 `[TBD — 需在 spec-forge 中補充]`
- **保留原始術語**：企劃報告中的用語直接帶入 PRD，不做同義詞替換
- **品質 > 完整**：寧可少一段清楚的 PRD，也不要多一段模糊的 PRD
