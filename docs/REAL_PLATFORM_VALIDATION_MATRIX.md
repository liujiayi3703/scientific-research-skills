# Real Platform Validation Matrix

Generated: 2026-06-21 11:45:41

This matrix is for real app verification. Local proxy routing tests are useful, but they do not prove a vendor app's internal skill router.

## Evidence Levels

| Evidence | Meaning |
| --- | --- |
| Local connected | Skills exist in the platform's default local directory. |
| Proxy top-1 pass | `tools/Test-SkillRouting.py` selected the expected skill. |
| Real app pass | The named app actually selected or applied the expected skill for the prompt. |

## Local Connection Status

| Platform target | Path | Status | Skill count | Missing shared skills |
| --- | --- | --- | ---: | ---: |
| Claude Code default | `C:\Users\liuji\.claude\skills` | connected | 66 | 0 |
| Codex default | `C:\Users\liuji\.codex\skills` | connected | 67 | 0 |
| Generic agents default | `C:\Users\liuji\.agents\skills` | connected | 66 | 0 |

Trae IDE/SOLO, Doubao, Marvis, GLM, and other apps do not have a universal default skills path. Use `docs/skills-manifest.json` if they cannot scan `library/skills` directly.

Per-platform prompt packs are in `docs/platform-prompt-packs/`.

## How To Run Real Platform Checks

1. Connect or point the app at `library/skills`, or give it `docs/skills-manifest.json`.
2. Use each prompt below in a fresh or neutral session.
3. Record the skill the app selected or visibly applied.
4. Mark pass only when the expected skill is selected or its instructions are clearly applied.
5. If a related skill appears but expected skill still wins, note it; if related skill replaces expected skill, mark fail.

## Platform Result Summary

| Platform | Local connected | Real routing tested | Pass count | Fail count | Notes |
| --- | --- | --- | ---: | ---: | --- |
| Claude Code | pending manual confirmation | no | 0 | 0 | Use `.claude/skills` default path. |
| Codex | pending manual confirmation | no | 0 | 0 | Use `.codex/skills` default path. |
| Trae IDE / SOLO | app-specific | no | 0 | 0 | Point app to `library/skills` or import manifest. |
| Generic agents: Doubao / Marvis / GLM | app-specific | no | 0 | 0 | Start with `docs/skills-manifest.json`. |

## Prompt Checklist

| Case | Expected skill | Claude Code | Codex | Trae/SOLO | Generic agents | Prompt |
| --- | --- | --- | --- | --- | --- | --- |
| spreadsheet-clean-xlsx | xlsx | [ ] | [ ] | [ ] | [ ] | I have an Excel file with messy headers and blank rows. Clean it up, add formulas, and return a polished xlsx. |
| word-report-template | docx | [ ] | [ ] | [ ] | [ ] | Create a formatted Word report template with headings, page numbers, a table of contents, and tracked comment placeholders. |
| slide-deck-edit | pptx | [ ] | [ ] | [ ] | [ ] | Open this pptx deck, rewrite the speaker notes, and combine it with another presentation. |
| pdf-extract-merge | pdf | [ ] | [ ] | [ ] | [ ] | Extract the tables from this PDF, rotate page 3, and merge it with another PDF. |
| scientific-figure-from-csv | sci-figure | [ ] | [ ] | [ ] | [ ] | Use this CSV to make a publication-ready scientific figure with error bars, statistical annotations, and a caption. |
| frontend-dashboard | frontend-design | [ ] | [ ] | [ ] | [ ] | Build a polished React dashboard UI with filters, table view, chart panel, and responsive layout. |
| complex-html-artifact | web-artifacts-builder | [ ] | [ ] | [ ] | [ ] | Create a multi-view HTML artifact with React state, Tailwind styling, shadcn components, and client-side routing. |
| playwright-localhost-test | webapp-testing | [ ] | [ ] | [ ] | [ ] | Use Playwright to click through my localhost app, capture screenshots, and inspect browser console errors. |
| web-search-current-info | web-access-main | [ ] | [ ] | [ ] | [ ] | Search the web for the latest policy details, open the pages, and summarize the sources with links. |
| claude-api-prompt-cache | claude-api | [ ] | [ ] | [ ] | [ ] | This repo imports @anthropic-ai/sdk. Add Claude prompt caching and debug why cache hit rate is low. |
| openclaw-memory-setup | openclaw | [ ] | [ ] | [ ] | [ ] | Set up Claude-Mem on an OpenClaw gateway with memory slots, worker startup, and observation feed. |
| knowledge-agent-memory-brain | knowledge-agent | [ ] | [ ] | [ ] | [ ] | Build a focused knowledge base from my past observations and query it for recurring project patterns. |
| memory-search-prior-solution | mem-search | [ ] | [ ] | [ ] | [ ] | Did we already solve this auth redirect issue before? Search memory for the earlier solution. |
| timeline-project-history | timeline-report | [ ] | [ ] | [ ] | [ ] | Generate a journey report of this project from the full development timeline and summarize major phases. |
| learn-codebase-prime | learn-codebase | [ ] | [ ] | [ ] | [ ] | Learn this unfamiliar codebase by reading the source files and getting up to speed before changes. |
| smart-structural-search | smart-explore | [ ] | [ ] | [ ] | [ ] | Use structural search to find where this function is defined and map related symbols without reading every file. |
| architecture-pathfinder | pathfinder | [ ] | [ ] | [ ] | [ ] | Find the ideal path through this codebase, map duplicated flows, and propose a unified architecture before refactor. |
| implementation-plan | make-plan | [ ] | [ ] | [ ] | [ ] | Make a phased implementation plan for this feature with documentation discovery and clear verification gates. |
| execute-plan | do | [ ] | [ ] | [ ] | [ ] | Execute the phased plan we already wrote and carry out the implementation steps. |
| subagent-tech-lead | p9 | [ ] | [ ] | [ ] | [ ] | Act as P9 tech lead, split this project into task prompts, and coordinate multiple P8 agents. |
| cto-strategy | p10 | [ ] | [ ] | [ ] | [ ] | Use CTO mode to define strategic direction, architecture governance, and org topology across teams. |
| academic-lit-review | academic-research-suite | [ ] | [ ] | [ ] | [ ] | Help me do a systematic literature review, refine the research question, and draft an academic paper plan. |
| research-idea-battle | research-idea-and-battle | [ ] | [ ] | [ ] | [ ] | I have an AI/ML research idea. Battle-test the novelty, tell me what reviewers would attack, and help position it. |
| paper-download-doi | scansci-pdf | [ ] | [ ] | [ ] | [ ] | Download these DOI papers, get BibTeX citations, and save the PDFs for later reading. |
| nsfc-proposal | nsfc-grant-writing | [ ] | [ ] | [ ] | [ ] | 帮我写国自然基金本子，重点打磨立项依据、科学问题、技术路线和创新点。 |
| xgboost-tabular-model | xgboost-lightgbm | [ ] | [ ] | [ ] | [ ] | Train an XGBoost or LightGBM model on this tabular CSV, check leakage, tune parameters, and report feature importance. |
| nano-banana-image | nanobanana | [ ] | [ ] | [ ] | [ ] | Use Nano Banana style image editing prompts to turn this product photo into a clean studio mockup. |
| algorithmic-p5-art | algorithmic-art | [ ] | [ ] | [ ] | [ ] | Create generative art with p5.js, seeded randomness, flow fields, and interactive parameters. |
| static-poster-design | canvas-design | [ ] | [ ] | [ ] | [ ] | Design a polished static poster as a PNG/PDF with strong typography and visual composition. |
| theme-artifact | theme-factory | [ ] | [ ] | [ ] | [ ] | Apply a coherent visual theme with colors, typography, and layout rules to this slide/report artifact. |
| anthropic-brand | brand-guidelines | [ ] | [ ] | [ ] | [ ] | Apply Anthropic brand colors, typography, and official visual guidelines to this artifact. |
| internal-status-update | internal-comms | [ ] | [ ] | [ ] | [ ] | Write a concise internal 3P update for leadership with progress, plans, problems, and next steps. |
| doc-coauthor-spec | doc-coauthoring | [ ] | [ ] | [ ] | [ ] | Co-author a technical spec with me, refine it iteratively, and make sure it works for readers. |
| slack-gif | slack-gif-creator | [ ] | [ ] | [ ] | [ ] | Make a Slack emoji GIF that loops cleanly, stays small enough to upload, and uses the right frame rate. |
| wowerpoint-deck | wowerpoint | [ ] | [ ] | [ ] | [ ] | Wowerpoint this report into a cute NotebookLM-style slide-deck PDF. |
| debugging-pua-en | pua-en | [ ] | [ ] | [ ] | [ ] | This failed twice and you keep tweaking the same thing. Stop giving up, verify the environment, and figure it out. |
| yes-encouragement-mode | yes | [ ] | [ ] | [ ] | [ ] | 开启夸夸模式，给我一点情绪价值，但底层做事标准不要降低。 |
| mama-mode | mama | [ ] | [ ] | [ ] | [ ] | 妈妈模式，唠叨一点也行，盯着我把这个问题彻底解决。 |
| release-plugin-version | version-bump | [ ] | [ ] | [ ] | [ ] | Bump the plugin version, update package.json and plugin.json, publish to npm, tag git, and write the changelog. |
| babysit-pr | babysit | [ ] | [ ] | [ ] | [ ] | Babysit this pull request: keep checking CI, review comments, and merge readiness until all actionable issues are resolved. |
| claude-mem-how-it-works | how-it-works | [ ] | [ ] | [ ] | [ ] | How does claude-mem work? Explain how observations are captured, when memory injection happens, and where the data lives. |
| build-mcp-server | mcp-builder | [ ] | [ ] | [ ] | [ ] | Help me build a high-quality MCP server for an external API with well-designed tools and schemas. |
| p7-senior-engineer-mode | p7 | [ ] | [ ] | [ ] | [ ] | Use P7 senior engineer mode to implement this solution under P8 supervision and include the three-question self-review. |
| pua-pro-extensions | pro | [ ] | [ ] | [ ] | [ ] | Use PUA Pro extensions: KPI report, leaderboard, compaction-state protection, and self-evolution tracking. |
| pua-main-mode | pua | [ ] | [ ] | [ ] | [ ] | 开启 PUA 模式，别再被动等指令，系统性排查、搜索源码、验证结论，把这个问题彻底解决。 |
| pua-cancel-loop-alias | pua-cancel-loop | [ ] | [ ] | [ ] | [ ] | Invoke the $pua-cancel-loop alias to cancel the current autonomous loop cleanly. |
| pua-flavor-alias | pua-flavor | [ ] | [ ] | [ ] | [ ] | Invoke $pua-flavor and show me the available PUA flavor options. |
| pua-ja-mode | pua-ja | [ ] | [ ] | [ ] | [ ] | 日本語の詰め文化で pua-ja mode にして、同じ失敗を繰り返さず徹底的にデバッグして。 |
| pua-kpi-alias | pua-kpi | [ ] | [ ] | [ ] | [ ] | Run $pua-kpi and generate the current PUA KPI report. |
| pua-loop-mode | pua-loop | [ ] | [ ] | [ ] | [ ] | Start /pua:pua-loop 自动循环 and keep iterating until independent verification says the task is done. |
| pua-mama-alias | pua-mama | [ ] | [ ] | [ ] | [ ] | Invoke $pua-mama as the alias form of mama mode. |
| pua-off-alias | pua-off | [ ] | [ ] | [ ] | [ ] | Run $pua-off to turn off PUA mode for this session. |
| pua-offline-alias | pua-offline | [ ] | [ ] | [ ] | [ ] | Invoke $pua-offline so the PUA workflow runs without network access. |
| pua-on-alias | pua-on | [ ] | [ ] | [ ] | [ ] | Run $pua-on to enable PUA mode. |
| pua-p10-alias | pua-p10 | [ ] | [ ] | [ ] | [ ] | Invoke $pua-p10 for P10 CTO mode with PUA enforcement. |
| pua-p7-alias | pua-p7 | [ ] | [ ] | [ ] | [ ] | Invoke $pua-p7 for P7 senior engineer mode with PUA enforcement. |
| pua-p9-alias | pua-p9 | [ ] | [ ] | [ ] | [ ] | Invoke $pua-p9 for tech-lead task decomposition with PUA enforcement. |
| pua-pro-alias | pua-pro | [ ] | [ ] | [ ] | [ ] | Invoke $pua-pro for the Pro alias command. |
| pua-reap-orphans-alias | pua-reap-orphans | [ ] | [ ] | [ ] | [ ] | Run $pua-reap-orphans to clean up orphaned PUA agents or processes. |
| pua-survey-alias | pua-survey | [ ] | [ ] | [ ] | [ ] | Invoke $pua-survey to inspect the current PUA environment and status. |
| pua-team-status-alias | pua-team-status | [ ] | [ ] | [ ] | [ ] | Run $pua-team-status to report all active PUA team agents and their state. |
| pua-teardown-all-alias | pua-teardown-all | [ ] | [ ] | [ ] | [ ] | Invoke $pua-teardown-all to stop and clean up all PUA agent activity. |
| pua-yes-alias | pua-yes | [ ] | [ ] | [ ] | [ ] | Invoke $pua-yes as the alias form for encouragement mode. |
| pua-shot-mode | shot | [ ] | [ ] | [ ] | [ ] | Use /pua:shot, the concentrated single-file strongest PUA injection for a sub-agent. |
| create-new-skill | skill-creator | [ ] | [ ] | [ ] | [ ] | Create a new Codex skill from scratch, write its SKILL.md, design trigger evals, and package it. |
| shared-skill-install-download | shared-skill-installer | [ ] | [ ] | [ ] | [ ] | ??? GitHub ? openai curated skills ?????? AI skill???? WPS ?? Skills ??????? inbox????? library/skills??????????????? Claude Code?Codex ??? agents? |
