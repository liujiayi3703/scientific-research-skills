---
name: pua-offline
description: "Use when the user invokes $pua-offline or /pua:offline for offline PUA mode, no-network debugging, or local-only task execution."
license: MIT
---

# pua-offline

This is a Codex CLI alias for the Claude Code `/pua:offline` command.

Enable offline mode by setting ~/.pua/config.json offline=true and feedback_frequency=0 while preserving other fields. Then report [PUA OFFLINE].

When this alias changes `~/.pua/config.json`, preserve unknown fields and create `~/.pua/` if missing. Do not claim completion without command/output evidence.
