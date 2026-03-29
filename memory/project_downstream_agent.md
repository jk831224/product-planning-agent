---
name: downstream agent reference
description: spec-forge-agent is the downstream agent that consumes PRD.md from this agent
type: project
---

本 agent 的下游：spec-forge-agent（/Users/vm5_andrew/spec-forge-agent/），接收 PRD.md 產出 DBML + Gherkin。

**Why:** 兩個 agent 之間透過 PRD.md 銜接。本 agent 完成 Double Diamond 企劃後，透過 `/handoff-to-spec-forge` skill 產出 PRD.md。

**How to apply:** 當使用者說「交付」「handoff」時，執行 handoff skill 產出 PRD.md。PRD.md 是唯一的交接介面。
