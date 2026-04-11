# Release Notes

> CHANGELOG.md 是給開發者看的結構化紀錄；本文件則是每次迭代的對外敘事 —— 我們做了什麼、為什麼做、對使用者的意義。

---

## Unreleased — PRD Checkpoint（RPG 存檔概念）

### 我們做了什麼

為 product-planning-agent 加入了一套 **手動存檔 / 讀檔機制**，靈感來自玩 RPG 的存檔點：在 PRD 做大改之前，你可以隨時說「存檔」建立一個安全還原點；若改壞了、或走錯方向，說「讀檔」就能回到任一個存檔狀態。

具體來說：
- `scripts/checkpoint-prd.sh` 把當前 PRD 複製到 `.prd-history/<product>/` 目錄，檔名帶 timestamp
- `scripts/restore-prd.sh` 列出所有存檔，還原到指定版本
- 兩個對應的 Claude Code Skill（`checkpoint` 與 `restore`）讓你用自然語言觸發：
  - 「存檔一下」「我要存檔，標籤叫 before-persona-refactor」
  - 「讀檔」「回到剛才那個存檔」「選錯結局了」
- 還原操作本身也會先把當前狀態另存為 `pre-restore` 存檔，所以**永遠可以雙向反悔**

### 為什麼做

我們原本考慮抄 prd-taskmaster 那套「每次編輯自動快照 + 多重 recovery point」的機制，但討論之後發現：
- 我們是「活文件共筆」模式，不是「多步驟問卷流程」，根本沒有需要恢復的長流程狀態
- SessionStart 的 `prd-status.sh` 本來就會在下次對話提醒進度
- 自動化快照對單人 PM 使用情境是過度設計

但我們仍保留了一個真實存在的風險：**Claude 某次 Edit 把段落意外寫壞、PM 過一段時間才發現**。這時 editor 的 undo 已經失效、git 又還沒 commit。所以我們選擇做一個 **最小可行的手動兜底**：不是自動化，而是把決策權交給 PM —— 就像玩 RPG 時 PM 自己決定什麼時候該存檔，而不是遊戲每 5 秒自動存。

### 對 PM 使用者的意義

- 改 PRD 前先說「存檔」→ 安心做大修
- 改壞了說「讀檔」→ 一秒還原，還可以再反悔一次
- 不污染 git 歷史（`.prd-history/` 已 gitignore）
- 不需要學 git 也能有版本管理的安全感

### 不做的事（刻意保持最小）

- ❌ 不自動存檔（PostToolUse hook 不加新邏輯）
- ❌ 不限制存檔數量（以後若真的吃空間再做 ring buffer）
- ❌ 不做 decision log 旁註檔（PRD 本身就是決策紀錄）

---

## 專案里程碑紀錄

- **2026-03-28** — 專案 scaffold 初建，建立 `product-planning` skill 與 Double Diamond 流程框架
- **2026-03-30** — `CLAUDE.md` 從 Coach 模式改為 Copilot 模式（邊聊邊寫 PRD）
- **2026-04-05** — FitLog PRD 完成 100%，驗證完整流程可行
- **2026-04-06** — 專案加入 README、Author 段落，對外開源準備
