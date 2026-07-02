# Skill Quality Gate Report

Generated: 2026-07-02T23:45:24

- Overall result: PASS
- Iterations requested: 1
- Iterations completed: 1
- Require real platform complete: False
- Source root: `C:\Users\liuji\Desktop\scientific-research-skills`

This gate verifies local structure, trigger descriptions, proxy routing, manifest consistency, and default local target coverage. It does not prove real app internal routing.

## Iteration 1: PASS

### Commands

| Command | Result | Seconds |
| --- | --- | ---: |
| Audit-Skills | PASS | 0.103 |
| Audit-SkillTriggers | PASS | 0.179 |
| Test-SkillRouting | PASS | 6.441 |
| Export-SkillManifest | PASS | 0.272 |
| Export-PlatformValidationPack | PASS | 0.11 |
| Summarize-PlatformValidation | PASS | 0.095 |

### Artifact Checks

| Check | Result | Detail |
| --- | --- | --- |
| standard-skills-present | PASS | 72 standard skills |
| no-nonstandard-skill-folders | PASS | 0 nonstandard folders |
| eval-coverage | PASS | 72 cases, missing coverage: 0 |
| trigger-audit-clean | PASS | 0 descriptions need review |
| routing-top1-100-and-no-blocked | PASS | all profiles pass |
| manifest-consistent | PASS | 72 manifest skills |
| platform-prompts-consistent | PASS | 72 platform prompts |
| platform-results-summarized | PASS | 72 platform result rows summarized; all platforms perfect: False |
| default-targets-contain-shared-skills | PASS | Claude/Codex/Agents default targets contain all shared skills |

### Default Target Checks

| Target | Result | Skill count | Missing | Path |
| --- | --- | ---: | ---: | --- |
| Claude Code default | PASS | 72 | 0 | `C:\Users\liuji\.claude\skills` |
| Codex default | PASS | 73 | 0 | `C:\Users\liuji\.codex\skills` |
| Generic agents default | PASS | 72 | 0 | `C:\Users\liuji\.agents\skills` |

## Files

- JSON: `docs/quality-gate-report.json`
- Markdown: `docs/QUALITY_GATE_REPORT.md`
- Real platform matrix: `docs/REAL_PLATFORM_VALIDATION_MATRIX.md`
