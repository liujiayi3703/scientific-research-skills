# Skill Quality Gate Report

Generated: 2026-06-21T11:45:42

- Overall result: PASS
- Iterations requested: 1
- Iterations completed: 1
- Require real platform complete: False
- Source root: `C:\Users\liuji\Desktop\Skills`

This gate verifies local structure, trigger descriptions, proxy routing, manifest consistency, and default local target coverage. It does not prove real app internal routing.

## Iteration 1: PASS

### Commands

| Command | Result | Seconds |
| --- | --- | ---: |
| Audit-Skills | PASS | 0.331 |
| Audit-SkillTriggers | PASS | 0.59 |
| Test-SkillRouting | PASS | 17.038 |
| Export-SkillManifest | PASS | 0.634 |
| Export-PlatformValidationPack | PASS | 0.229 |
| Summarize-PlatformValidation | PASS | 0.232 |

### Artifact Checks

| Check | Result | Detail |
| --- | --- | --- |
| standard-skills-present | PASS | 66 standard skills |
| no-nonstandard-skill-folders | PASS | 0 nonstandard folders |
| eval-coverage | PASS | 66 cases, missing coverage: 0 |
| trigger-audit-clean | PASS | 0 descriptions need review |
| routing-top1-100-and-no-blocked | PASS | all profiles pass |
| manifest-consistent | PASS | 66 manifest skills |
| platform-prompts-consistent | PASS | 66 platform prompts |
| platform-results-summarized | PASS | 66 platform result rows summarized; all platforms perfect: False |
| default-targets-contain-shared-skills | PASS | Claude/Codex/Agents default targets contain all shared skills |

### Default Target Checks

| Target | Result | Skill count | Missing | Path |
| --- | --- | ---: | ---: | --- |
| Claude Code default | PASS | 66 | 0 | `C:\Users\liuji\.claude\skills` |
| Codex default | PASS | 67 | 0 | `C:\Users\liuji\.codex\skills` |
| Generic agents default | PASS | 66 | 0 | `C:\Users\liuji\.agents\skills` |

## Files

- JSON: `docs/quality-gate-report.json`
- Markdown: `docs/QUALITY_GATE_REPORT.md`
- Real platform matrix: `docs/REAL_PLATFORM_VALIDATION_MATRIX.md`
