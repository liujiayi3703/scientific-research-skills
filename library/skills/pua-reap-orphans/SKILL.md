---
name: pua-reap-orphans
description: "Use when the user invokes $pua-reap-orphans or /pua:reap-orphans to clean up orphaned PUA agents or processes."
license: MIT
---

# pua-reap-orphans

This is a Codex CLI alias for the Claude Code `/pua:reap-orphans` command.

Scan for stale PUA agent state and remove only confirmed orphan records. Report evidence.

When this alias changes `~/.pua/config.json`, preserve unknown fields and create `~/.pua/` if missing. Do not claim completion without command/output evidence.
