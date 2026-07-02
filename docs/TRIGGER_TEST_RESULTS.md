# Trigger Test Results

These tests use a conservative lexical router as a cross-platform proxy, not a vendor-internal model.

## Summary

| Profile | Total | Top-1 | Top-3 | Blocked In Top-3 | Allowed Related In Top-3 |
| --- | ---: | ---: | ---: | ---: | ---: |
| claude-code | 72 | 100.0% | 100.0% | 0 | 12 |
| codex | 72 | 100.0% | 100.0% | 0 | 11 |
| trae-solo | 72 | 100.0% | 100.0% | 0 | 12 |
| generic-agents | 72 | 100.0% | 100.0% | 0 | 12 |

## Failures

No failures.

## Ambiguity Warnings

No high-similarity blocked candidates.

## Allowed Related Candidates

- `frontend-dashboard` expected `frontend-design`
  - claude-code: top3=[frontend-design (237.2346), web-artifacts-builder (130.7954), version-bump (52.7402)], related=web-artifacts-builder
  - trae-solo: top3=[frontend-design (180.7882), web-artifacts-builder (118.3454), version-bump (52.0322)], related=web-artifacts-builder
  - generic-agents: top3=[frontend-design (167.699), web-artifacts-builder (118.5973), version-bump (53.8586)], related=web-artifacts-builder
- `complex-html-artifact` expected `web-artifacts-builder`
  - claude-code: top3=[web-artifacts-builder (352.3323), frontend-design (273.096), theme-factory (75.7617)], related=frontend-design
  - codex: top3=[web-artifacts-builder (310.5319), frontend-design (244.3481), theme-factory (66.7049)], related=frontend-design
  - trae-solo: top3=[web-artifacts-builder (302.1582), frontend-design (209.8595), theme-factory (65.429)], related=frontend-design
  - generic-agents: top3=[web-artifacts-builder (296.1818), frontend-design (195.4887), buy-side-equity-research-memo (67.5185)], related=frontend-design
- `implementation-plan` expected `make-plan`
  - claude-code: top3=[make-plan (433.6418), do (261.8083), p7 (77.2534)], related=do
  - codex: top3=[make-plan (409.3589), do (234.5068), p7 (69.5281)], related=do
  - trae-solo: top3=[make-plan (405.8232), do (231.1972), pathfinder (88.1341)], related=do
  - generic-agents: top3=[make-plan (411.1657), do (228.065), pathfinder (97.126)], related=do
- `execute-plan` expected `do`
  - claude-code: top3=[do (366.864), make-plan (272.1255), mem-search (134.5489)], related=make-plan
  - codex: top3=[do (327.5352), make-plan (255.2559), mem-search (120.059)], related=make-plan
  - trae-solo: top3=[do (286.6496), make-plan (239.9821), mem-search (105.5692)], related=make-plan
  - generic-agents: top3=[do (269.2385), make-plan (237.5643), mem-search (99.3592)], related=make-plan
- `theme-artifact` expected `theme-factory`
  - claude-code: top3=[theme-factory (333.5775), canvas-design (294.0013), brand-guidelines (198.4489)], related=brand-guidelines
  - codex: top3=[theme-factory (305.6933), canvas-design (276.4359), brand-guidelines (175.5039)], related=brand-guidelines
- `debugging-pua-en` expected `pua-en`
  - claude-code: top3=[pua-en (407.42), pua (386.1365), sci-figure (114.0576)], related=pua
  - codex: top3=[pua-en (359.9611), pua (347.5229), sci-figure (114.7574)], related=pua
  - trae-solo: top3=[pua-en (343.554), pua (283.1668), sci-figure (126.6529)], related=pua
  - generic-agents: top3=[pua-en (334.3044), pua (257.4243), sci-figure (135.7496)], related=pua
- `p7-senior-engineer-mode` expected `p7`
  - claude-code: top3=[p7 (467.3329), pua-p7 (309.3457), shot (138.5031)], related=pua-p7
  - codex: top3=[p7 (441.6386), pua-p7 (289.4866), shot (114.951)], related=pua-p7
  - trae-solo: top3=[p7 (399.1361), pua-p7 (276.7311), shot (166.2477)], related=pua-p7
  - generic-agents: top3=[p7 (388.519), pua-p7 (275.5553), shot (182.8856)], related=pua-p7
- `pua-ja-mode` expected `pua-ja`
  - claude-code: top3=[pua-ja (201.218), pua (172.7921), shot (161.6706)], related=pua
  - codex: top3=[pua-ja (197.9213), pua (159.8672), shot (144.0551)], related=pua
  - trae-solo: top3=[pua-ja (210.1222), pua (175.5815), shot (128.2148)], related=pua
  - generic-agents: top3=[pua-ja (219.7903), pua (182.061), shot (121.2993)], related=pua
- `pua-loop-mode` expected `pua-loop`
  - claude-code: top3=[pua-loop (925.0987), pua (520.7473), pua-cancel-loop (230.3216)], related=pua
  - codex: top3=[pua-loop (881.133), pua (508.7733), pua-cancel-loop (224.7443)], related=pua
  - trae-solo: top3=[pua-loop (819.8296), pua (518.0981), pua-cancel-loop (225.4284)], related=pua
  - generic-agents: top3=[pua-loop (802.5515), pua (525.9443), pua-cancel-loop (231.9799)], related=pua
- `pua-mama-alias` expected `pua-mama`
  - claude-code: top3=[pua-mama (770.1773), mama (473.7587), pua-yes (155.3091)], related=mama
  - codex: top3=[pua-mama (750.2132), mama (462.6886), pua-yes (142.8328)], related=mama
  - trae-solo: top3=[pua-mama (731.167), mama (433.5659), pua-yes (128.151)], related=mama
  - generic-agents: top3=[pua-mama (733.863), mama (433.8719), pua-yes (123.3592)], related=mama
- `pua-pro-alias` expected `pua-pro`
  - claude-code: top3=[pua-pro (687.7286), pro (378.4877), pua (100.0316)], related=pro
  - codex: top3=[pua-pro (673.3114), pro (370.4728), pua (97.5565)], related=pro
  - trae-solo: top3=[pua-pro (661.5975), pro (370.7207), pua (101.0653)], related=pro
  - generic-agents: top3=[pua-pro (666.2575), pro (380.3332), pua (103.932)], related=pro
- `pua-shot-mode` expected `shot`
  - claude-code: top3=[shot (814.9165), pua (465.5302), pua-on (188.2862)], related=pua
  - codex: top3=[shot (783.3703), pua (461.4179), pua-on (179.1803)], related=pua
  - trae-solo: top3=[shot (727.3339), pua (462.0054), pua-on (177.1242)], related=pua
  - generic-agents: top3=[shot (712.7326), pua (467.2927), pua-on (179.7678)], related=pua
- `tam-adjusted-peg` expected `tam-adj-peg`
  - trae-solo: top3=[tam-adj-peg (761.9997), bayesian-intrinsic-growth-valuation (430.8402), gf-dma-health-index (88.0352)], related=bayesian-intrinsic-growth-valuation
  - generic-agents: top3=[tam-adj-peg (772.8663), bayesian-intrinsic-growth-valuation (449.1055), gf-dma-health-index (85.9747)], related=bayesian-intrinsic-growth-valuation

These are intentionally allowed as nearby top-3 candidates, but top-1 must still be the expected skill.

## Files

- JSON: `docs/trigger-test-results.json`
- CSV: `docs/trigger-test-results.csv`
- Eval set: `docs/trigger-evals.json`
