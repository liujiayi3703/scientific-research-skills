---
name: pua-survey
description: "Use when the user invokes $pua-survey or /pua:survey to inspect the current PUA environment and status."
license: MIT
---

# pua-survey

This is a Codex CLI alias for the Claude Code `/pua:survey` command.

Guide the user through the PUA survey and save the local response. Ask before any upload.

When this alias changes `~/.pua/config.json`, preserve unknown fields and create `~/.pua/` if missing. Do not claim completion without command/output evidence.
