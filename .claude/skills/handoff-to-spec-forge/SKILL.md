---
name: handoff-to-spec-forge
description: |
  將產品企劃成果轉化為 spec-forge-agent 能消費的 PRD.md。
  觸發詞：「交付」「handoff」「交給 spec-forge」「產出 PRD」
disable-model-invocation: true
---

# Handoff Protocol: product-planning-agent → spec-forge-agent

> 將產品企劃成果轉化為 spec-forge-agent 能消費的 PRD.md。

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
| Cynefin 情境 | <Clear / Complicated / Complex / Chaotic> |
```

### 2. Goals（PRD §1）— 雙層目標

**來源**：產品規格摘要的「核心問題」+「解決方案」

#### 1.1 商業目標（Business Goal）

一段文字描述長期方向：
- 為什麼要做這件事（HMW 問題的背景）
- 預期達成的商業效果

#### 1.2 版本目標（Version Goal）

本次 MVP 的具體 scope：
- 這個版本要解決哪些特定痛點
- 核心假設是什麼

### 3. User Request（PRD §2）

#### 2.1 痛點

**來源**：痛點彙整表 + 設計問題分層

每個痛點一個子段落，格式：

```markdown
#### P1. <痛點標題>
- <具體描述>
- 來源 Persona：<名稱>
- 影響程度：<高/中/低>
- 需求來源角色：<立法者/使用者/客戶/設計師>
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

### 5. User Story Map（PRD §4）— 新增

**來源**：User Story Map

按 Activity → Task → Story 結構呈現：

```markdown
### Activity 1: <活動名稱>
#### Task 1.1: <任務名稱>
- MVP: US-01, US-02
- V2: US-03

#### Task 1.2: <任務名稱>
- MVP: US-04
```

如果企劃階段未產出 Story Map，標記 `[TBD — 建議在 spec-forge 中補充]`。

### 6. User Story（PRD §5）— 升級版

**來源**：User Story 表（含 GWT 驗收標準）+ INVEST 檢查結果

按功能模組分群：

```markdown
| 編號 | User Story | 驗收標準 (GWT) | INVEST | 對應需求 |
|------|-----------|---------------|--------|---------|
| US-01 | 身為[Persona]，我想要[功能]，以便[價值] | **Given** [條件] **When** [操作] **Then** [結果] | ✅ 通過 | R1 |
```

- Persona 名稱從 User Story 表的 `[Persona]` 直接帶入
- 對應需求從 §2.2 的需求編號對應
- INVEST 狀態標記：✅ 通過 / ⚠️ 部分通過（附註哪項未過）

### 7. Use Case（PRD §6）— 新增（可選）

**來源**：Use Case 產出

如果企劃階段有產出 Use Case，直接帶入：

```markdown
### UC-01: <用例名稱>
- **Primary Actor**：<Persona>
- **利害關係人與關注點**：<HMW 對應>
- **前置條件**：<條件>
- **後置條件**：<條件>

**主要成功場景：**
1. <步驟>

**替代場景：**
- 1a. <替代>

**開放式問題：** <待釐清>
```

如果未產出 Use Case，可不包含此段落，或標記 `[建議在 spec-forge 的 Phase 0 中補充關鍵流程的 Use Case]`。

### 8. User Journey（PRD §7）

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

### 9. 非功能性需求（PRD §8）— 新增

**來源**：非功能性需求清單 + 技術風險雷達

```markdown
| 類別 | 需求描述 | 目標值 | 備註 |
|------|---------|--------|------|
| 效能 | | | |
| 可靠性 | | | |
| 安全性 | | | |
| 易用性 | | | |
| 可支持性 | | | |
```

**技術風險摘要：**

```markdown
| 功能 | 風險信號 | 風險等級 | 建議 |
|------|---------|---------|------|
| <功能名> | <整合點/持續性/時間頻率/數量規模/類別擴充> | 高/中/低 | <建議工程師提前評估的項目> |
```

如果企劃階段未產出 NFR，標記 `[TBD — 建議在 spec-forge 中與工程師共同定義]`。

### 10. 測試驗收（PRD §9）— 新增

**來源**：User Story 的 GWT 驗收標準彙整

```markdown
### UAT 測試案例初稿

| 測試編號 | 來源 Story | 測試場景 | Given | When | Then | 狀態 |
|---------|-----------|---------|-------|------|------|------|
| TC-01 | US-01 | 正常流程 | | | | 待測 |
| TC-02 | US-01 | 例外流程 | | | | 待測 |
```

### 11. 成功指標（PRD §10）

**來源**：成功指標表

```markdown
| 指標類型 | 指標名稱 | 定義 | 目標值 | 衡量方式 |
|---------|---------|------|-------|---------|
| 核心指標 | | | | |
| 次要指標 | | | | |
| 護欄指標 | | | | |
```

### 12. 未來展望（PRD §11）

**來源**：MVP 範圍定義中的「V2 再加入」+「未來考慮」

```markdown
| 功能 | 說明 | 預計版本 |
|------|------|---------|
| <V2 項目> | <描述> | V2 |
| <未來考慮項目> | <描述> | Future |
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
| Cynefin 情境 | <情境判斷> |

---

## 1. Goals
### 1.1 商業目標
### 1.2 版本目標（MVP scope）

---

## 2. User Request
### 2.1 痛點
### 2.2 需求

---

## 3. Feature List

---

## 4. User Story Map

---

## 5. User Story（含 GWT 驗收標準）

---

## 6. Use Case（可選）

---

## 7. User Journey

---

## 8. 非功能性需求

---

## 9. 測試驗收（UAT 初稿）

---

## 10. 成功指標

---

## 11. 未來展望
```

---

## 執行步驟

1. **檢查前置條件**：確認 `deliverables/` 下有完成的企劃報告，且至少完成 Define + Develop
2. **載入企劃報告**：讀取 `deliverables/<產品名>-report.md`（或對話中已有的企劃產出）
3. **逐段映射**：依上方映射規則，從企劃產出中萃取內容，填入 PRD 結構
4. **處理新增段落**：
   - 如果企劃有 User Story Map → 填入 §4
   - 如果企劃有 Use Case → 填入 §6
   - 如果企劃有 NFR / 技術風險雷達 → 填入 §8
   - 如果企劃有 GWT → 彙整為 §9 UAT 測試案例
   - 缺少的段落標記 `[TBD]`，不硬編
5. **產出 PRD**：寫入 `deliverables/<產品名>-PRD.md`
6. **六大浪費預防檢查**：在交付前掃描 PRD：
   - [ ] User Story 是否切分夠小（避免半成品浪費）
   - [ ] 是否有多餘功能超出 MVP scope（避免 scope creep）
   - [ ] 驗收標準是否明確（避免缺陷浪費）
   - [ ] 是否有過多交接點（避免 handoff 浪費）
7. **品質檢查**：確認 PRD 包含 spec-forge-agent Phase 0 所需的元素：
   - [ ] **Actor**（角色）：至少一個明確的 Actor（來自 Persona）
   - [ ] **Event**（事件）：至少有用戶操作描述（來自 Journey / User Story）
   - [ ] **Command**（命令）：至少有功能描述（來自 Feature List）
   - [ ] **Rule**（規則）：至少有 GWT 驗收標準或業務規則（來自 User Story）
8. **告知使用者下一步**：
   - PRD 已產出在 `deliverables/<產品名>-PRD.md`
   - 複製到 `spec-forge-agent/Projects/<專案名>/PRD.md`
   - 在 spec-forge-agent 中執行 `/spec-formulate`

---

## 映射速查表（完整版）

| 產品企劃產出 | PRD 對應段落 | spec-forge 用途 |
|---|---|---|
| Cynefin 情境判斷 | PRD 表頭 | 開發策略參考 |
| Target Persona | Actor 定義 | Gherkin Given 主語 |
| 核心問題 (HMW) | §1 Goals / §2.2 需求 | Feature 描述 |
| 設計問題分層 | §2.1 痛點（需求來源角色） | 優先級判斷 |
| 解決方案 | §1.2 版本目標 | Command context |
| MVP 範圍 | §3 Feature List | spec-formulate 範圍界定 |
| User Story Map | §4 Story Map | Story 結構與開發順序 |
| User Story（含 GWT） | §5 User Story | Command + Rule 來源 |
| Use Case（可選） | §6 Use Case | Gherkin Scenario + Alternative |
| Journey Map | §7 User Journey | Phase 0 情境補充 |
| 非功能性需求 | §8 NFR | 架構決策參考 |
| 技術風險雷達 | §8 技術風險摘要 | 技術 Spike 識別 |
| GWT 彙整 | §9 測試驗收 | Acceptance criteria / UAT |
| 成功指標 | §10 成功指標 | 驗收標準參考 |
| V2 + 未來考慮 | §11 未來展望 | Roadmap 參考 |

---

## 行為規則

- **不腦補**：只映射企劃報告中已有的內容，不補充或推測
- **標記缺口**：企劃報告中缺少的段落，在 PRD 中標記 `[TBD — 需在 spec-forge 中補充]`
- **保留原始術語**：企劃報告中的用語直接帶入 PRD，不做同義詞替換
- **品質 > 完整**：寧可少一段清楚的 PRD，也不要多一段模糊的 PRD
- **向下相容**：即使企劃只用了基礎功能（沒有 NFR、Use Case、Story Map），PRD 仍可正常產出，只是相應段落標記 TBD
