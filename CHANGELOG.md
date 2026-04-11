# Changelog

All notable changes to **product-planning-agent** will be documented in this file.

本專案的變更紀錄採用 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.1.0/) 格式，版本編號遵循 [Semantic Versioning](https://semver.org/lang/zh-TW/)。

類別說明：
- **Added** — 新增的功能
- **Changed** — 既有功能的改動
- **Deprecated** — 即將移除的功能
- **Removed** — 已移除的功能
- **Fixed** — Bug 修正
- **Security** — 安全性相關修正

## [Unreleased]

### Added
- **PRD Checkpoint（RPG-style 存檔 / 讀檔機制）**
  - `scripts/checkpoint-prd.sh` — 手動存檔當前 PRD 狀態到 `.prd-history/<product>/`，支援自訂標籤
  - `scripts/restore-prd.sh` — 列出所有存檔並還原到指定版本，還原前自動保留 `pre-restore` 副本（雙向可逆）
  - `.claude/skills/checkpoint/` — Skill 觸發詞：「存檔」「備份一下」「先存一下」
  - `.claude/skills/restore/` — Skill 觸發詞：「讀檔」「回到剛才那個」「選錯結局了」
- **CHANGELOG.md** — 本檔，採 Keep a Changelog 格式
- **RELEASE_NOTES.md** — 對外敘事式的版本紀錄

### Changed
- `.gitignore` 新增 `.prd-history/` 路徑，PRD 存檔為本機狀態不進版控
