# Trigger Test Results

These tests use a conservative lexical router as a cross-platform proxy, not a vendor-internal model.

## Summary

| Profile | Total | Top-1 | Top-3 | Blocked In Top-3 | Allowed Related In Top-3 |
| --- | ---: | ---: | ---: | ---: | ---: |
| claude-code | 66 | 100.0% | 100.0% | 0 | 11 |
| codex | 66 | 100.0% | 100.0% | 0 | 10 |
| trae-solo | 66 | 100.0% | 100.0% | 0 | 11 |
| generic-agents | 66 | 100.0% | 100.0% | 0 | 11 |

## Failures

No failures.

## Ambiguity Warnings

No high-similarity blocked candidates.

## Allowed Related Candidates

- `frontend-dashboard` expected `frontend-design`
  - claude-code: top3=[frontend-design (231.9858), web-artifacts-builder (127.9651), version-bump (51.3338)], related=web-artifacts-builder
  - trae-solo: top3=[frontend-design (176.8705), web-artifacts-builder (115.7553), version-bump (50.7493)], related=web-artifacts-builder
  - generic-agents: top3=[frontend-design (164.1038), web-artifacts-builder (115.9899), version-bump (52.5689)], related=web-artifacts-builder
- `complex-html-artifact` expected `web-artifacts-builder`
  - claude-code: top3=[web-artifacts-builder (345.5855), frontend-design (266.6121), theme-factory (73.3602)], related=frontend-design
  - codex: top3=[web-artifacts-builder (304.6056), frontend-design (238.5434), theme-factory (64.5779)], related=frontend-design
  - trae-solo: top3=[web-artifacts-builder (296.2385), frontend-design (204.8988), theme-factory (63.4392)], related=frontend-design
  - generic-agents: top3=[web-artifacts-builder (290.3231), frontend-design (190.8779), theme-factory (62.4053)], related=frontend-design
- `implementation-plan` expected `make-plan`
  - claude-code: top3=[make-plan (422.5927), do (256.565), p7 (75.195)], related=do
  - codex: top3=[make-plan (398.8524), do (229.8491), p7 (67.6755)], related=do
  - trae-solo: top3=[make-plan (395.4044), do (226.9442), pathfinder (85.9556)], related=do
  - generic-agents: top3=[make-plan (400.5819), do (223.9985), pathfinder (94.7246)], related=do
- `execute-plan` expected `do`
  - claude-code: top3=[do (357.9442), make-plan (265.1269), mem-search (137.8448)], related=make-plan
  - codex: top3=[do (319.576), make-plan (248.6691), mem-search (122.9999)], related=make-plan
  - trae-solo: top3=[do (279.6511), make-plan (233.7383), mem-search (108.1551)], related=make-plan
  - generic-agents: top3=[do (262.6516), make-plan (231.3548), mem-search (101.793)], related=make-plan
- `theme-artifact` expected `theme-factory`
  - claude-code: top3=[theme-factory (337.8603), canvas-design (289.7987), brand-guidelines (193.5602)], related=brand-guidelines
  - codex: top3=[theme-factory (310.1677), canvas-design (272.7136), brand-guidelines (171.1813)], related=brand-guidelines
- `debugging-pua-en` expected `pua-en`
  - claude-code: top3=[pua-en (408.0096), pua (381.4311), sci-figure (117.2053)], related=pua
  - codex: top3=[pua-en (360.4412), pua (343.288), sci-figure (117.9244)], related=pua
  - trae-solo: top3=[pua-en (344.3233), pua (279.7161), sci-figure (130.1482)], related=pua
  - generic-agents: top3=[pua-en (335.1692), pua (254.2874), sci-figure (139.4959)], related=pua
- `p7-senior-engineer-mode` expected `p7`
  - claude-code: top3=[p7 (457.1333), pua-p7 (301.6825), shot (134.6865)], related=pua-p7
  - codex: top3=[p7 (432.0275), pua-p7 (282.3165), shot (111.769)], related=pua-p7
  - trae-solo: top3=[p7 (390.4888), pua-p7 (269.8998), shot (161.7621)], related=pua-p7
  - generic-agents: top3=[p7 (380.1011), pua-p7 (268.7626), shot (177.9798)], related=pua-p7
- `pua-ja-mode` expected `pua-ja`
  - claude-code: top3=[pua-ja (196.9554), pua (167.8262), shot (155.817)], related=pua
  - codex: top3=[pua-ja (193.753), pua (155.2958), shot (138.8319)], related=pua
  - trae-solo: top3=[pua-ja (205.6709), pua (170.5985), shot (123.622)], related=pua
  - generic-agents: top3=[pua-ja (215.1074), pua (176.8807), shot (116.9766)], related=pua
- `pua-loop-mode` expected `pua-loop`
  - claude-code: top3=[pua-loop (908.1966), pua (512.9741), pua-cancel-loop (222.0494)], related=pua
  - codex: top3=[pua-loop (865.2603), pua (501.2267), pua-cancel-loop (216.6907)], related=pua
  - trae-solo: top3=[pua-loop (805.2694), pua (510.0031), pua-cancel-loop (217.3535)], related=pua
  - generic-agents: top3=[pua-loop (788.2787), pua (517.4344), pua-cancel-loop (223.6777)], related=pua
- `pua-mama-alias` expected `pua-mama`
  - claude-code: top3=[pua-mama (762.0038), mama (464.0071), pua-yes (153.9111)], related=mama
  - codex: top3=[pua-mama (742.1962), mama (453.2456), pua-yes (141.437)], related=mama
  - trae-solo: top3=[pua-mama (723.0078), mama (424.792), pua-yes (126.5272)], related=mama
  - generic-agents: top3=[pua-mama (725.4093), mama (425.1237), pua-yes (121.5953)], related=mama
- `pua-pro-alias` expected `pua-pro`
  - trae-solo: top3=[pua-pro (651.284), pro (361.5308), pua (98.2864)], related=pro
  - generic-agents: top3=[pua-pro (655.8454), pro (370.9332), pua (101.0502)], related=pro
- `pua-shot-mode` expected `shot`
  - claude-code: top3=[shot (798.981), pua (457.5796), pua-on (180.0397)], related=pua
  - codex: top3=[shot (768.6012), pua (453.6474), pua-on (171.3327)], related=pua
  - trae-solo: top3=[shot (714.4517), pua (454.2092), pua-on (169.3665)], related=pua
  - generic-agents: top3=[shot (700.4508), pua (459.2649), pua-on (171.8944)], related=pua

These are intentionally allowed as nearby top-3 candidates, but top-1 must still be the expected skill.

## Files

- JSON: `docs/trigger-test-results.json`
- CSV: `docs/trigger-test-results.csv`
- Eval set: `docs/trigger-evals.json`
