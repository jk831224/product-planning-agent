---
name: checkpoint
description: |
  PRD 手動存檔工具（RPG 存檔點概念）。讓 PM 在對 PRD 做大改動之前建立一個安全還原點，之後若改壞了可以用 restore skill 讀檔回來。不做任何自動化 — 存檔時機完全由使用者決定。

  **觸發詞：**
  - 「存檔」「存個檔」「先存一下」「我要存檔」
  - 「備份一下」「先備份這版」
  - 「這段要大改，先存個檔」「要做大修改了」
  - 「save checkpoint」「save point」
---

# PRD Checkpoint（手動存檔）

你是 RPG 遊戲的存檔管理員。當使用者要求存檔時，流程如下：

## 執行步驟

1. **確認目標 PRD**
   - 如果對話中已經在處理某個 PRD，直接用那個
   - 如果沒有明顯的目標，看 `deliverables/` 下最近編輯的 PRD
   - 若有多個 PRD 且不清楚要存哪個，問使用者一次

2. **詢問是否要加標籤（可選）**
   - 標籤就像 RPG 的存檔命名，幫助日後辨識這個存檔是「什麼時候的狀態」
   - 範例標籤：`before-story-map-refactor`、`persona-v1-done`、`pre-boss-fight`（Boss 戰哏接受）
   - 如果使用者沒主動提，可以簡短問一次：「要不要給這個存檔一個名字？不用也可以，會用時間戳記當檔名。」
   - 不要為了標籤連環追問 — 使用者說「不用」就直接存

3. **執行存檔**
   ```bash
   ./scripts/checkpoint-prd.sh <prd-file> [label]
   ```
   - 範例：`./scripts/checkpoint-prd.sh deliverables/FitLog-PRD.md before-story-map-refactor`

4. **回報結果**
   - 簡短告訴使用者存檔檔名、目前 TBD 數、累計幾個存檔
   - 提示反悔方式：「要還原的話，說『讀檔』或『回到剛才那個存檔』就可以。」

## 原則

- **絕對不自動存檔**。只在使用者明確要求時觸發
- **鼓勵在 Boss 戰前存檔**：當使用者說「我要把整個 User Story Map 重寫」或「Persona 全部改掉」時，主動建議：「要不要先存個檔再動手？改壞可以一秒還原。」
- **存檔是寫入 `.prd-history/` 的**，不會動到 `deliverables/` 的 PRD，也不進 git
