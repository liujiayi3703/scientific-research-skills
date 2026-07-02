# Codex Skill Validation Prompts

Generated: 2026-07-02 23:45:23

Setup: Use the default local skills directory `%USERPROFILE%\.codex\skills`.

Record results in `docs/platform-validation-prompts.csv`, column `codex_result`.

Use a fresh or neutral session when possible. Mark pass only when the expected skill is selected or clearly applied.

## spreadsheet-clean-xlsx

- Expected skill: `xlsx`
- Should not win: docx; pptx; pdf

Prompt:

```text
I have an Excel file with messy headers and blank rows. Clean it up, add formulas, and return a polished xlsx.
```

Result to record:

## word-report-template

- Expected skill: `docx`
- Should not win: xlsx; pptx; pdf

Prompt:

```text
Create a formatted Word report template with headings, page numbers, a table of contents, and tracked comment placeholders.
```

Result to record:

## slide-deck-edit

- Expected skill: `pptx`
- Should not win: docx; xlsx; pdf

Prompt:

```text
Open this pptx deck, rewrite the speaker notes, and combine it with another presentation.
```

Result to record:

## pdf-extract-merge

- Expected skill: `pdf`
- Should not win: docx; pptx; xlsx

Prompt:

```text
Extract the tables from this PDF, rotate page 3, and merge it with another PDF.
```

Result to record:

## scientific-figure-from-csv

- Expected skill: `sci-figure`
- Should not win: xlsx; canvas-design; algorithmic-art

Prompt:

```text
Use this CSV to make a publication-ready scientific figure with error bars, statistical annotations, and a caption.
```

Result to record:

## frontend-dashboard

- Expected skill: `frontend-design`
- Allowed nearby skills: web-artifacts-builder
- Should not win: web-artifacts-builder; xlsx

Prompt:

```text
Build a polished React dashboard UI with filters, table view, chart panel, and responsive layout.
```

Result to record:

## complex-html-artifact

- Expected skill: `web-artifacts-builder`
- Allowed nearby skills: frontend-design
- Should not win: frontend-design; webapp-testing

Prompt:

```text
Create a multi-view HTML artifact with React state, Tailwind styling, shadcn components, and client-side routing.
```

Result to record:

## playwright-localhost-test

- Expected skill: `webapp-testing`
- Should not win: frontend-design; web-access-main

Prompt:

```text
Use Playwright to click through my localhost app, capture screenshots, and inspect browser console errors.
```

Result to record:

## web-search-current-info

- Expected skill: `web-access-main`
- Should not win: academic-research-suite; browser:control-in-app-browser

Prompt:

```text
Search the web for the latest policy details, open the pages, and summarize the sources with links.
```

Result to record:

## claude-api-prompt-cache

- Expected skill: `claude-api`
- Should not win: openai-docs; Codex-api

Prompt:

```text
This repo imports @anthropic-ai/sdk. Add Claude prompt caching and debug why cache hit rate is low.
```

Result to record:

## openclaw-memory-setup

- Expected skill: `openclaw`
- Should not win: knowledge-agent; how-it-works

Prompt:

```text
Set up Claude-Mem on an OpenClaw gateway with memory slots, worker startup, and observation feed.
```

Result to record:

## knowledge-agent-memory-brain

- Expected skill: `knowledge-agent`
- Should not win: mem-search; timeline-report

Prompt:

```text
Build a focused knowledge base from my past observations and query it for recurring project patterns.
```

Result to record:

## memory-search-prior-solution

- Expected skill: `mem-search`
- Should not win: knowledge-agent; timeline-report

Prompt:

```text
Did we already solve this auth redirect issue before? Search memory for the earlier solution.
```

Result to record:

## timeline-project-history

- Expected skill: `timeline-report`
- Should not win: mem-search; knowledge-agent

Prompt:

```text
Generate a journey report of this project from the full development timeline and summarize major phases.
```

Result to record:

## learn-codebase-prime

- Expected skill: `learn-codebase`
- Should not win: smart-explore; pathfinder

Prompt:

```text
Learn this unfamiliar codebase by reading the source files and getting up to speed before changes.
```

Result to record:

## smart-structural-search

- Expected skill: `smart-explore`
- Should not win: learn-codebase; pathfinder

Prompt:

```text
Use structural search to find where this function is defined and map related symbols without reading every file.
```

Result to record:

## architecture-pathfinder

- Expected skill: `pathfinder`
- Should not win: learn-codebase; make-plan

Prompt:

```text
Find the ideal path through this codebase, map duplicated flows, and propose a unified architecture before refactor.
```

Result to record:

## implementation-plan

- Expected skill: `make-plan`
- Allowed nearby skills: do
- Should not win: do; p9

Prompt:

```text
Make a phased implementation plan for this feature with documentation discovery and clear verification gates.
```

Result to record:

## execute-plan

- Expected skill: `do`
- Allowed nearby skills: make-plan
- Should not win: make-plan; p9

Prompt:

```text
Execute the phased plan we already wrote and carry out the implementation steps.
```

Result to record:

## subagent-tech-lead

- Expected skill: `p9`
- Should not win: p7; p10; do

Prompt:

```text
Act as P9 tech lead, split this project into task prompts, and coordinate multiple P8 agents.
```

Result to record:

## cto-strategy

- Expected skill: `p10`
- Should not win: p9; p7

Prompt:

```text
Use CTO mode to define strategic direction, architecture governance, and org topology across teams.
```

Result to record:

## academic-lit-review

- Expected skill: `academic-research-suite`
- Should not win: research-idea-and-battle; scansci-pdf

Prompt:

```text
Help me do a systematic literature review, refine the research question, and draft an academic paper plan.
```

Result to record:

## research-idea-battle

- Expected skill: `research-idea-and-battle`
- Should not win: academic-research-suite; p10

Prompt:

```text
I have an AI/ML research idea. Battle-test the novelty, tell me what reviewers would attack, and help position it.
```

Result to record:

## paper-download-doi

- Expected skill: `scansci-pdf`
- Should not win: academic-research-suite; pdf

Prompt:

```text
Download these DOI papers, get BibTeX citations, and save the PDFs for later reading.
```

Result to record:

## nsfc-proposal

- Expected skill: `nsfc-grant-writing`
- Should not win: academic-research-suite; internal-comms

Prompt:

```text
帮我写国自然基金本子，重点打磨立项依据、科学问题、技术路线和创新点。
```

Result to record:

## xgboost-tabular-model

- Expected skill: `xgboost-lightgbm`
- Should not win: xlsx; academic-research-suite

Prompt:

```text
Train an XGBoost or LightGBM model on this tabular CSV, check leakage, tune parameters, and report feature importance.
```

Result to record:

## nano-banana-image

- Expected skill: `nanobanana`
- Should not win: imagegen; canvas-design

Prompt:

```text
Use Nano Banana style image editing prompts to turn this product photo into a clean studio mockup.
```

Result to record:

## algorithmic-p5-art

- Expected skill: `algorithmic-art`
- Should not win: canvas-design; frontend-design

Prompt:

```text
Create generative art with p5.js, seeded randomness, flow fields, and interactive parameters.
```

Result to record:

## static-poster-design

- Expected skill: `canvas-design`
- Should not win: algorithmic-art; frontend-design

Prompt:

```text
Design a polished static poster as a PNG/PDF with strong typography and visual composition.
```

Result to record:

## theme-artifact

- Expected skill: `theme-factory`
- Allowed nearby skills: brand-guidelines
- Should not win: brand-guidelines; frontend-design

Prompt:

```text
Apply a coherent visual theme with colors, typography, and layout rules to this slide/report artifact.
```

Result to record:

## anthropic-brand

- Expected skill: `brand-guidelines`
- Should not win: theme-factory; canvas-design

Prompt:

```text
Apply Anthropic brand colors, typography, and official visual guidelines to this artifact.
```

Result to record:

## internal-status-update

- Expected skill: `internal-comms`
- Should not win: doc-coauthoring; docx

Prompt:

```text
Write a concise internal 3P update for leadership with progress, plans, problems, and next steps.
```

Result to record:

## doc-coauthor-spec

- Expected skill: `doc-coauthoring`
- Should not win: internal-comms; docx

Prompt:

```text
Co-author a technical spec with me, refine it iteratively, and make sure it works for readers.
```

Result to record:

## slack-gif

- Expected skill: `slack-gif-creator`
- Should not win: canvas-design; imagegen

Prompt:

```text
Make a Slack emoji GIF that loops cleanly, stays small enough to upload, and uses the right frame rate.
```

Result to record:

## wowerpoint-deck

- Expected skill: `wowerpoint`
- Should not win: pptx; theme-factory

Prompt:

```text
Wowerpoint this report into a cute NotebookLM-style slide-deck PDF.
```

Result to record:

## debugging-pua-en

- Expected skill: `pua-en`
- Allowed nearby skills: pua
- Should not win: pua; yes

Prompt:

```text
This failed twice and you keep tweaking the same thing. Stop giving up, verify the environment, and figure it out.
```

Result to record:

## yes-encouragement-mode

- Expected skill: `yes`
- Should not win: pua; mama

Prompt:

```text
开启夸夸模式，给我一点情绪价值，但底层做事标准不要降低。
```

Result to record:

## mama-mode

- Expected skill: `mama`
- Should not win: yes; pua-en

Prompt:

```text
妈妈模式，唠叨一点也行，盯着我把这个问题彻底解决。
```

Result to record:

## release-plugin-version

- Expected skill: `version-bump`
- Should not win: plugin-creator; skill-creator

Prompt:

```text
Bump the plugin version, update package.json and plugin.json, publish to npm, tag git, and write the changelog.
```

Result to record:

## babysit-pr

- Expected skill: `babysit`
- Should not win: webapp-testing; do

Prompt:

```text
Babysit this pull request: keep checking CI, review comments, and merge readiness until all actionable issues are resolved.
```

Result to record:

## claude-mem-how-it-works

- Expected skill: `how-it-works`
- Should not win: mem-search; knowledge-agent

Prompt:

```text
How does claude-mem work? Explain how observations are captured, when memory injection happens, and where the data lives.
```

Result to record:

## build-mcp-server

- Expected skill: `mcp-builder`
- Should not win: plugin-creator; claude-api

Prompt:

```text
Help me build a high-quality MCP server for an external API with well-designed tools and schemas.
```

Result to record:

## p7-senior-engineer-mode

- Expected skill: `p7`
- Allowed nearby skills: pua-p7
- Should not win: p9; p10; pua-p7

Prompt:

```text
Use P7 senior engineer mode to implement this solution under P8 supervision and include the three-question self-review.
```

Result to record:

## pua-pro-extensions

- Expected skill: `pro`
- Should not win: pua-pro; pua-kpi

Prompt:

```text
Use PUA Pro extensions: KPI report, leaderboard, compaction-state protection, and self-evolution tracking.
```

Result to record:

## pua-main-mode

- Expected skill: `pua`
- Should not win: pua-en; yes; mama

Prompt:

```text
开启 PUA 模式，别再被动等指令，系统性排查、搜索源码、验证结论，把这个问题彻底解决。
```

Result to record:

## pua-cancel-loop-alias

- Expected skill: `pua-cancel-loop`
- Should not win: pua-loop; pua-off

Prompt:

```text
Invoke the $pua-cancel-loop alias to cancel the current autonomous loop cleanly.
```

Result to record:

## pua-flavor-alias

- Expected skill: `pua-flavor`
- Should not win: pua; pro

Prompt:

```text
Invoke $pua-flavor and show me the available PUA flavor options.
```

Result to record:

## pua-ja-mode

- Expected skill: `pua-ja`
- Allowed nearby skills: pua
- Should not win: pua-en; pua

Prompt:

```text
日本語の詰め文化で pua-ja mode にして、同じ失敗を繰り返さず徹底的にデバッグして。
```

Result to record:

## pua-kpi-alias

- Expected skill: `pua-kpi`
- Should not win: pro; pua-pro

Prompt:

```text
Run $pua-kpi and generate the current PUA KPI report.
```

Result to record:

## pua-loop-mode

- Expected skill: `pua-loop`
- Allowed nearby skills: pua
- Should not win: pua-cancel-loop; pua

Prompt:

```text
Start /pua:pua-loop 自动循环 and keep iterating until independent verification says the task is done.
```

Result to record:

## pua-mama-alias

- Expected skill: `pua-mama`
- Allowed nearby skills: mama
- Should not win: mama; yes

Prompt:

```text
Invoke $pua-mama as the alias form of mama mode.
```

Result to record:

## pua-off-alias

- Expected skill: `pua-off`
- Should not win: pua-on; pua

Prompt:

```text
Run $pua-off to turn off PUA mode for this session.
```

Result to record:

## pua-offline-alias

- Expected skill: `pua-offline`
- Should not win: pua-off; pua-on

Prompt:

```text
Invoke $pua-offline so the PUA workflow runs without network access.
```

Result to record:

## pua-on-alias

- Expected skill: `pua-on`
- Should not win: pua-off; pua

Prompt:

```text
Run $pua-on to enable PUA mode.
```

Result to record:

## pua-p10-alias

- Expected skill: `pua-p10`
- Should not win: p10; pua-p9

Prompt:

```text
Invoke $pua-p10 for P10 CTO mode with PUA enforcement.
```

Result to record:

## pua-p7-alias

- Expected skill: `pua-p7`
- Should not win: p7; pua-p9

Prompt:

```text
Invoke $pua-p7 for P7 senior engineer mode with PUA enforcement.
```

Result to record:

## pua-p9-alias

- Expected skill: `pua-p9`
- Should not win: p9; pua-p10

Prompt:

```text
Invoke $pua-p9 for tech-lead task decomposition with PUA enforcement.
```

Result to record:

## pua-pro-alias

- Expected skill: `pua-pro`
- Allowed nearby skills: pro
- Should not win: pro; pua-kpi

Prompt:

```text
Invoke $pua-pro for the Pro alias command.
```

Result to record:

## pua-reap-orphans-alias

- Expected skill: `pua-reap-orphans`
- Should not win: pua-team-status; pua-teardown-all

Prompt:

```text
Run $pua-reap-orphans to clean up orphaned PUA agents or processes.
```

Result to record:

## pua-survey-alias

- Expected skill: `pua-survey`
- Should not win: pua-team-status; pua-kpi

Prompt:

```text
Invoke $pua-survey to inspect the current PUA environment and status.
```

Result to record:

## pua-team-status-alias

- Expected skill: `pua-team-status`
- Should not win: pua-survey; pua-reap-orphans

Prompt:

```text
Run $pua-team-status to report all active PUA team agents and their state.
```

Result to record:

## pua-teardown-all-alias

- Expected skill: `pua-teardown-all`
- Should not win: pua-reap-orphans; pua-off

Prompt:

```text
Invoke $pua-teardown-all to stop and clean up all PUA agent activity.
```

Result to record:

## pua-yes-alias

- Expected skill: `pua-yes`
- Should not win: yes; pua

Prompt:

```text
Invoke $pua-yes as the alias form for encouragement mode.
```

Result to record:

## pua-shot-mode

- Expected skill: `shot`
- Allowed nearby skills: pua
- Should not win: pua; pua-pro

Prompt:

```text
Use /pua:shot, the concentrated single-file strongest PUA injection for a sub-agent.
```

Result to record:

## create-new-skill

- Expected skill: `skill-creator`
- Should not win: mcp-builder; plugin-creator

Prompt:

```text
Create a new Codex skill from scratch, write its SKILL.md, design trigger evals, and package it.
```

Result to record:

## shared-skill-install-download

- Expected skill: `shared-skill-installer`
- Should not win: skill-creator; mcp-builder; plugin-creator

Prompt:

```text
Download an AI skill from GitHub or OpenAI curated skills into my shared Skills library, stage it in the inbox, standardize it into library/skills, then connect it to Claude Code, Codex, and generic agents.
```

Result to record:

## buy-side-equity-memo

- Expected skill: `buy-side-equity-research-memo`
- Should not win: tam-adj-peg; bayesian-intrinsic-growth-valuation; gf-dma-health-index

Prompt:

```text
Analyze NVDA as a source-backed buy-side memo with investment view, bull/base/bear target price scenarios, valuation, catalysts, risks, and monitoring dashboard.
```

Result to record:

## bayesian-growth-valuation

- Expected skill: `bayesian-intrinsic-growth-valuation`
- Should not win: buy-side-equity-research-memo; tam-adj-peg; gf-dma-health-index

Prompt:

```text
Use Bayesian intrinsic-growth valuation to judge whether this company's current market value already prices in its real 3-5 year growth, TAM, margins, and FOMO.
```

Result to record:

## gf-dma-health-score

- Expected skill: `gf-dma-health-index`
- Should not win: buy-side-equity-research-memo; tam-adj-peg; bayesian-intrinsic-growth-valuation

Prompt:

```text
Score this ticker with the GF-DMA Health Index using 20/50/100/200DMA trend, price-to-DMA divergence, ATR divergence, estimate revisions, and fundamental support.
```

Result to record:

## tam-adjusted-peg

- Expected skill: `tam-adj-peg`
- Allowed nearby skills: bayesian-intrinsic-growth-valuation
- Should not win: buy-side-equity-research-memo; gf-dma-health-index

Prompt:

```text
Use TAM-Adj-PEG to decide whether this growth stock is cheap or expensive after adjusting for TAM runway, quality, margins, and growth durability.
```

Result to record:

## serenity-alpha-news

- Expected skill: `serenity-alpha`
- Should not win: buy-side-equity-research-memo; bayesian-intrinsic-growth-valuation; tam-adj-peg

Prompt:

```text
Turn this supply-chain news into Serenity-style alpha: identify small-cap beneficiaries, financial-statement transmission, validation metrics, downside risks, and position-sizing conditions.
```

Result to record:

## desktop-screenshot-capture

- Expected skill: `screenshot`
- Should not win: xlsx; pdf; frontend-design

Prompt:

```text
Take a screenshot of my desktop and save it as a PNG file.
```

Result to record:

