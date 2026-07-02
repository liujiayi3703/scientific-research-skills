# Branching And Release Guide

This repository is a reusable AI skills library. Keep the branch model simple so other agents can consume the repository without guessing which version is stable.

## Branches

| Branch pattern | Purpose | Merge requirement |
| --- | --- | --- |
| `main` | Stable skills library for daily use. | Full quality gate passes. |
| `codex/<task>` | Agent-authored fixes, library cleanup, trigger tuning, or documentation updates. | Review diff scope, then merge after quality gate. |
| `sync/<date>` | Batch sync from a local shared Skills library, upstream skill bundle, or external source. | Confirm new/changed skills have eval coverage. |
| `archive/<topic>` | Optional preservation branch for large historical imports. | Do not use as default runtime source. |

## Stable Runtime Contract

Universal agents should rely on these paths:

- `library/skills/<skill-name>/SKILL.md`
- `docs/skills-manifest.json`
- `docs/SKILLS_MANIFEST.md`
- `docs/SKILL_INDEX.md`
- `docs/TRIGGER_TEST_RESULTS.md`

Do not require agents to read `archive/`, `library/source-projects/`, or raw inbox material during normal skill routing.

## Update Checklist

Before opening or merging a PR:

1. Keep standard skills only under `library/skills/<skill-name>/`.
2. Ensure every skill has `SKILL.md` with `name` and `description` frontmatter.
3. Update `docs/trigger-evals.json` for every new, renamed, or trigger-sensitive skill.
4. Run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\运行-一键质量闸门.ps1
```

5. Commit the regenerated docs produced by the gate:
   - `docs/SKILL_INDEX.md`
   - `docs/SKILLS_MANIFEST.md`
   - `docs/skills-manifest.json`
   - `docs/TRIGGER_AUDIT.md`
   - `docs/TRIGGER_TEST_RESULTS.md`
   - `docs/QUALITY_GATE_REPORT.md`
   - `docs/platform-validation-*`
   - `docs/platform-prompt-packs/`

## Release Rule

Use `main` only for versions that pass the ordinary quality gate. Do not claim real multi-platform 100% routing unless `.\运行-严格检查真实平台100%.ps1` passes with real platform results filled in.
