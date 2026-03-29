# 產品企劃 Copilot（Product Planning Copilot）

一個基於 Claude Code 的產品企劃 AI Agent，用 **Double Diamond 框架** 與你一起從零完成 PRD。

不是問你一堆問題的教練，而是直接動手寫 PRD 的 **Copilot** — 你說想法，它立刻寫入文件，你透過 Preview 即時校對。

---

## 它能幫你做什麼？

```
你：「我想做一個幫自由工作者管理報價單的工具」

Copilot：立刻建立 PRD 骨架 → 推測 Persona → 填入初步 Goals
        「PRD 骨架建好了，開 Preview 看。我們從哪裡開始填？」
```

一份 PRD 從建立到可以交付給工程團隊，全程在對話中完成：

| 階段 | Copilot 做的事 |
|------|---------------|
| **Discover** | 建立 Persona Table & Card、User Journey Map、痛點彙整 |
| **Define** | HMW 問題轉化、設計問題分層、機會評估與優先排序 |
| **Develop** | 解法發想、User Story Map、INVEST 品質檢查、GWT 驗收標準、技術風險雷達、NFR |
| **Deliver** | MVP 範圍定義、成功指標、產品規格摘要、Handoff 至 spec-forge-agent |

---

## 先決條件

| 項目 | 說明 |
|------|------|
| **Claude Desktop App** | 從 [claude.ai/download](https://claude.ai/download) 下載（支援 macOS / Windows） |
| **Claude Code** | 在 Claude App 中開啟 Claude Code 模式 |
| **Claude Pro / Max 方案** | 需要有效的訂閱方案才能使用 Claude Code |

> **不需要** Node.js、Python 或任何額外安裝。只要有 Claude Desktop App + Claude Code 就能用。

---

## 安裝

### 1. 下載專案

```bash
git clone https://github.com/<your-username>/product-planning-agent.git
```

### 2. 用 Claude Code 開啟專案

打開 Claude Desktop App → 開啟 Claude Code 模式 → 將專案資料夾拖入，或在終端輸入：

```bash
cd product-planning-agent
```

Claude Code 會自動讀取 `CLAUDE.md` 和 `.claude/` 下的設定，Copilot 就準備好了。

### 3. 確認 Hooks 生效

開啟新對話時，你應該會在狀態列看到：

```
📭 deliverables/ 下沒有 PRD 檔案。要開始新的產品企劃嗎？
```

看到這個訊息就代表自動化 hooks 已正常運作。

---

## 快速開始

### 開始一個新的產品企劃

在 Claude Code 中輸入：

```
我想做一個產品企劃
```

或直接描述你的產品：

```
我想做一個幫自由工作者管理報價單的工具
```

Copilot 會：
1. 問你一個問題確認產品方向（如果你還沒描述的話）
2. 立刻在 `deliverables/` 建立 `<產品名>-PRD.md`
3. 預填能推測的段落，其餘用 `[TBD]` 佔位
4. 告訴你可以開 Preview 看

### 用 Preview 即時協作

在 Claude App 中，PRD 文件會在右側 Preview 面板即時更新。你的工作流程是：

```
你說想法 → Copilot 寫入 PRD → 你看 Preview → 給回饋 → Copilot 改 PRD → 重複
```

### 繼續進行中的企劃

下次開新對話時，Copilot 會自動偵測既有的 PRD 檔案，告訴你哪些段落還是 `[TBD]`，建議從哪裡繼續。

### 交付給工程團隊

當 PRD 接近完成時，輸入：

```
handoff
```

Copilot 會執行品質檢查（四要素驗證 + 六大浪費預防），確認沒問題後產出最終版 PRD。

---

## 專案結構

```
product-planning-agent/
├── CLAUDE.md                          # Agent 身份與行為準則
├── .claude/
│   ├── settings.json                  # 自動化 Hooks 設定
│   └── skills/
│       ├── product-planning/          # 核心企劃 Skill
│       │   └── SKILL.md
│       └── handoff-to-spec-forge/     # Handoff 轉換 Skill
│           └── SKILL.md
├── deliverables/                      # PRD 產出目錄
│   └── <產品名>-PRD.md               # ← 你的 PRD 活文件
├── scripts/
│   ├── init-prd.sh                    # PRD 骨架初始化
│   ├── prd-status.sh                  # PRD 完成度掃描
│   └── validate-prd.sh               # Handoff 前品質檢查
└── memory/                            # Agent 記憶檔案
```

---

## PRD 結構

Copilot 產出的 PRD 包含 11 個段落，涵蓋從商業目標到未來願景的完整範圍：

| # | 段落 | 內容 |
|---|------|------|
| 1 | **Goals** | 商業目標 + 版本目標（MVP scope） |
| 2 | **User Request** | Persona、痛點、需求（HMW） |
| 3 | **Feature List** | MVP 功能清單 |
| 4 | **User Story Map** | Activity → Task → Story 三層結構 |
| 5 | **User Story** | 含 GWT 驗收標準，通過 INVEST 檢查 |
| 6 | **Use Case** | 複雜流程的系統互動描述（選填） |
| 7 | **User Journey** | 使用者旅程地圖 |
| 8 | **NFR** | 非功能性需求 + 技術風險摘要 |
| 9 | **Testing Acceptance** | UAT 測試案例草稿 |
| 10 | **Success Metrics** | 核心 / 次要 / 護欄指標 |
| 11 | **Future Vision** | V2 + 未來規劃 |

---

## 進階能力

這個 Copilot 整合了 12 項來自軟體需求分析方法論的進階能力：

| 能力 | 用途 |
|------|------|
| **Cynefin Framework** | 判斷問題情境（Clear / Complicated / Complex / Chaotic），調整流程節奏 |
| **需求分層** | 校準討論在商業流程層 / 使用流程層 / 系統流程層的哪一層 |
| **設計問題分層** | 用立法者 / 使用者 / 客戶 / 設計師金字塔排列需求優先級 |
| **INVEST 品質檢查** | 逐項檢查 User Story 的 Independent / Negotiable / Valuable / Estimable / Small / Testable |
| **GWT 驗收標準** | Given / When / Then 格式，確保可測試性 |
| **User Story 拆分** | 8 種技巧：工作流程步驟、角色差異、操作類型、資料邊界等 |
| **User Story Mapping** | Activity → Task → Story 三層結構，定義 MVP 切割線 |
| **技術風險雷達** | 掃描整合點 / 持續性 / 時間頻率 / 數量規模 / 類別擴充五大信號 |
| **非功能性需求** | 易用性 / 可靠性 / 效能 / 可支持性 / 安全五維度 |
| **Use Case** | 適用於複雜業務流程的系統互動描述 |
| **MVP 可疊加性檢查** | 蒙娜麗莎原則，確保 MVP → V2 可平滑疊加 |
| **六大浪費預防** | Handoff 前檢查半成品 / 多餘功能 / 任務切換 / 交接 / 延遲 / 缺陷 |

---

## 自動化 Hooks

專案內建兩個自動化 hook，不需要手動操作：

| Hook | 觸發時機 | 做什麼 |
|------|---------|--------|
| **SessionStart** | 每次開新對話 | 自動掃描 `deliverables/` 的 PRD 完成度，讓 Copilot 一進來就知道現況 |
| **PostToolUse** | 每次編輯 `*-PRD.md` | 自動執行品質驗證，即時回報 pass / warn / fail |

---

## 搭配 spec-forge-agent 使用（選用）

這個 Copilot 的下游是 [spec-forge-agent](https://github.com/<your-username>/spec-forge-agent)，負責將 PRD 轉化為 DBML + Gherkin 技術規格。

```
product-planning-agent          spec-forge-agent
┌──────────────────┐           ┌──────────────────┐
│  Double Diamond  │  handoff  │  PRD → DBML +    │
│  → PRD.md        │ ───────→  │  Gherkin Spec    │
└──────────────────┘           └──────────────────┘
```

Handoff 流程：
1. 在本 agent 中說 `handoff`
2. Copilot 執行品質檢查，產出最終版 PRD
3. 將 `deliverables/<產品名>-PRD.md` 複製到 `spec-forge-agent/Projects/<專案名>/PRD.md`
4. 在 spec-forge-agent 中執行 `/spec-formulate`

---

## 常見問題

### Q: 我可以同時做多個產品企劃嗎？

可以。每個產品會有獨立的 PRD 檔案在 `deliverables/` 下，SessionStart hook 會列出所有 PRD 的完成度。

### Q: PRD 寫到一半，下次怎麼繼續？

直接開新對話。Copilot 會自動偵測既有的 PRD，告訴你還有幾個 `[TBD]`，建議從哪裡繼續。

### Q: 我不需要某些段落（例如 Use Case），可以跳過嗎？

可以。告訴 Copilot「Use Case 不需要」，它會把該段落標記為不適用，不會影響完成度判斷。

### Q: 我可以自己直接編輯 PRD 檔案嗎？

可以。PRD 就是一份 Markdown 檔案，你可以用任何編輯器修改。下次對話時 Copilot 會讀取最新版本。

### Q: Hook 沒有觸發怎麼辦？

確認 `.claude/settings.json` 存在且格式正確。如果剛複製專案，重新開一個 Claude Code 對話讓設定重新載入。

---

## 方法論來源

- [Mr. PM 產品企劃方法論](https://mrpm.cc/)
- Double Diamond Framework（British Design Council）
- Cynefin Framework（Dave Snowden）
- INVEST 原則（Bill Wake）
- User Story Mapping（Jeff Patton）

---

## Author

**Andrew Yen（顏士傑）**

AdTech 產品經理，現任職於第五代虛擬科技（VMFive / ADISON）。

職涯從政府標案新創起步，歷經 QA 測試工程師、CRM 專案經驗，到現在的廣告科技 PM。這條不算典型的路徑，讓我累積了跨領域的產品思維：從搞懂政府標書的眉角、建立系統邊界的概念、梳理企業部門 BPMN 流程，到在 AdTech 領域處理平台規劃、流量數據儀表板、跨部門協作的廣告格式開發 SOP。

我相信 PM 最關鍵的工作發生在 **問題空間** — 搞清楚「該不該做」比「怎麼做」重要得多。但現實是，大量的時間被消耗在文件格式、流程工具、重複的結構化作業上，真正用來思考決策的時間反而被壓縮。

這個專案是我嘗試用 AI Agent 解決這個問題的起點：**讓 PM 專注在做『對』的決策，把結構化的苦力交給 Copilot。**

- GitHub：[@jk831224](https://github.com/jk831224)
- LinkedIn：[Shih-chieh Yen](https://www.linkedin.com/in/shihchiehyen)

---

## License

MIT
