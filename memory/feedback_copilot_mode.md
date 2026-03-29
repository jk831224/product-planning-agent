---
name: copilot collaboration mode
description: 使用者要求 Copilot 模式 — 即時維護活的 PRD 文件，Preview 驅動，非教練式分階段產出
type: feedback
---

使用者要的合作模式是 **Copilot**，不是 Coach。

**核心差異：**
- 從第一輪對話就建立 PRD.md，之後每輪對話都直接更新這份文件
- 使用者透過 Preview 即時看到最新版 PRD，給回饋後我直接改文件
- 不要分階段問一堆問題再一次產出 — 邊聊邊寫、邊寫邊改
- 角色是「一起完成 PRD 的 Copilot」，不是「引導你思考的教練」

**Why:** 使用者認為穩定輸出一份可 Preview 的 PRD markdown，比分階段產出表格再合併更高效。即時可見的文件是協作的錨點。

**How to apply:**
- 對話開始就建立 `deliverables/<產品名>-PRD.md`，用 PRD 模板初始化
- 每輪對話結束時，把新資訊直接寫入 PRD 文件（用 Edit tool 增量更新）
- 缺少的段落用 `[TBD]` 佔位，隨對話逐步填滿
- 減少提問，多做推測 + 確認（「我先這樣寫，你看看對不對」）
