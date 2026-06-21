---
name: shared-skill-installer
description: Use when the user asks to download, install, import, update, or add new AI skills into the shared WPS/desktop Skills library, especially when they mention placing skills in the correct folder, using the inbox, GitHub skill repos, curated skills, .skill packages, or making newly downloaded skills available to local coding agents, IDE agents, or generic agents. Do not use for designing a brand-new skill from scratch; use skill-creator for that.
---

# Shared Skill Installer

Use this skill to bring new skills into the shared library safely. The goal is not only to download files, but to put them through the shared library intake flow so future agents can discover, route, test, and connect them.

## Target library

Resolve the shared Skills root before changing anything:

1. Prefer the current working directory if it contains both `library/skills/` and `00_新skills待整理_INBOX/`.
2. Otherwise prefer `C:\Users\liuji\Desktop\Skills` if it exists.
3. If neither path is valid, ask the user for the shared Skills root.

Use these paths under the resolved root:

- Inbox for downloaded raw skills: `00_新skills待整理_INBOX/`
- Standard skill library: `library/skills/`
- Process guide: `00_新skills待整理_INBOX/00-AI整理新skills标准流程.md`
- Quality gate: `运行-一键质量闸门.ps1`
- Connect command: `运行-接入全部AI平台skills.ps1`

## When the user wants to list installable skills

Use the bundled listing script when the user asks what skills can be installed from OpenAI's curated or experimental skill repo.

From the shared root, run:

```powershell
$env:CODEX_HOME = Join-Path (Get-Location) 'library'
python .\library\skills\shared-skill-installer\scripts\list-skills.py
```

For experimental skills:

```powershell
$env:CODEX_HOME = Join-Path (Get-Location) 'library'
python .\library\skills\shared-skill-installer\scripts\list-skills.py --path skills/.experimental
```

The `CODEX_HOME` override makes the script mark skills already present in `library/skills/`, not the local Codex-only install directory.

## When the user provides a GitHub repo or curated skill name

Download into the inbox first. Do not install directly into `library/skills/` until the standardization step has been performed.

Curated skill example:

```powershell
python .\library\skills\shared-skill-installer\scripts\install-skill-from-github.py `
  --repo openai/skills `
  --path skills/.curated/<skill-name> `
  --dest .\00_新skills待整理_INBOX
```

Experimental skill example:

```powershell
python .\library\skills\shared-skill-installer\scripts\install-skill-from-github.py `
  --repo openai/skills `
  --path skills/.experimental/<skill-name> `
  --dest .\00_新skills待整理_INBOX
```

GitHub URL example:

```powershell
python .\library\skills\shared-skill-installer\scripts\install-skill-from-github.py `
  --url https://github.com/<owner>/<repo>/tree/<ref>/<path-to-skill> `
  --dest .\00_新skills待整理_INBOX
```

If the destination folder already exists, do not overwrite it silently. Report the conflict and ask whether the user wants an update flow.

## When the user provides a local .skill, zip, folder, or Markdown draft

Put the raw input in `00_新skills待整理_INBOX/` if it is not already there. Then follow the inbox standardization guide.

## Standardization flow

After downloading or placing the raw skill in the inbox:

1. Read `00_新skills待整理_INBOX/00-AI整理新skills标准流程.md`.
2. Inspect the downloaded folder or package.
3. Confirm it has a `SKILL.md` with frontmatter containing `name` and `description`.
4. Copy or convert the finalized skill into `library/skills/<skill-name>/`.
5. Keep the raw input in the inbox until the quality gate passes.
6. Add or update `docs/trigger-evals.json` for the new skill.
7. Run:

```powershell
.\运行-一键质量闸门.ps1
```

8. If the gate passes, run:

```powershell
.\运行-接入全部AI平台skills.ps1
```

9. Archive the raw inbox input to `archive/new-skill-intake/YYYY-MM-DD/`.

## Update flow

When the user asks to update an existing skill:

1. Download the new version into the inbox.
2. Compare it with `library/skills/<skill-name>/`.
3. Preserve local customizations unless the user explicitly wants a replacement.
4. Update trigger evals if the trigger surface changed.
5. Run the quality gate before reconnecting.

## Safety rules

- Do not use `-Force` unless the user explicitly asks to overwrite existing installs.
- Do not delete inbox originals; archive them after successful processing.
- Do not claim real multi-platform 100% support unless `运行-严格检查真实平台100%.ps1` passes.
- Do not use this skill to invent a new skill from scratch. Use `skill-creator` for creation, then return here only for installation and shared-library placement.
