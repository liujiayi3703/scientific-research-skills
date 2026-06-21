# Skills Manifest

Generated: 2026-06-21T11:45:41

This file is for apps or agents that cannot directly scan a standard skills directory.

## How Generic Agents Should Use This

1. Read `docs/skills-manifest.json` or this file first.
2. Select candidate skills by `id`, `name`, and `description`.
3. Read the selected `SKILL.md` completely before applying the skill.
4. Use the listed eval cases as smoke tests after connecting a new app.

## Library

- Source root: `C:\Users\liuji\Desktop\Skills`
- Skills directory: `C:\Users\liuji\Desktop\Skills\library\skills`
- Skill count: 66
- JSON manifest: `C:\Users\liuji\Desktop\Skills\docs\skills-manifest.json`

## Skills

| Skill | Name | Eval Cases | Description |
| --- | --- | ---: | --- |
| academic-research-suite | academic-research-suite | 1 | Use when the user asks for academic research tasks: deep research, literature review, systematic review, meta-analysis, research question refinement, academic paper drafting or revision, citation checks, peer review, editorial decisions, research-to-paper pipelines, experiment planning, statistical interpretation, or human study protocol support. Also trigger on ARS aliases such as ars-plan, ars-outline, ars-lit-review, ars-reviewer, and ars-full. |
| algorithmic-art | algorithmic-art | 1 | Use when the user requests code-generated art, generative art, algorithmic art, p5.js sketches, seeded randomness, flow fields, particle systems, or interactive visual parameter exploration. |
| babysit | babysit | 1 | Watch a pull request or review cycle until it is ready to merge. Use when asked to babysit, monitor, or keep checking PR comments, reviews, and CI until all actionable issues are resolved. |
| brand-guidelines | brand-guidelines | 1 | Applies Anthropic's official brand colors and typography to any sort of artifact that may benefit from having Anthropic's look-and-feel. Use it when brand colors or style guidelines, visual formatting, or company design standards apply. |
| canvas-design | canvas-design | 1 | Use when the user asks to create a poster, visual art, static design, PNG/PDF design artifact, print piece, cover, composition, or typography-led visual deliverable. Use for original visual design even when the final export is PDF. |
| claude-api | claude-api | 1 | Use when code imports `anthropic` or `@anthropic-ai/sdk`, or when the user asks for Claude API, Anthropic SDK, Managed Agents, prompt caching, tool use, batch, files, citations, memory, model migration, or cache-hit debugging. Skip provider-neutral, OpenAI, or other-provider SDK work unless the user asks to switch to Claude. |
| do | do | 1 | Execute a phased implementation plan using subagents. Use when asked to execute, run, or carry out a plan — especially one created by make-plan. |
| doc-coauthoring | doc-coauthoring | 1 | Use when the user wants to co-author documentation, proposals, technical specs, decision docs, structured content, writing plans, draft refinement, reader-focused review, or iterative document collaboration. |
| docx | docx | 1 | Use when the user wants to create, read, edit, format, convert, or inspect Word documents (.docx), including reports, memos, letters, templates, headings, page numbers, tables of contents, images, tracked changes, comments, find-and-replace, or polished Word deliverables. Do not use for PDFs, spreadsheets, Google Docs, or unrelated coding tasks. |
| frontend-design | frontend-design | 1 | Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code and UI design that avoids generic AI aesthetics. |
| how-it-works | how-it-works | 1 | Use when the user asks how claude-mem works, what it is doing, how observations are captured, when memory injection happens, where data lives, or how persistent memory is added to sessions. |
| internal-comms | internal-comms | 1 | Use when writing internal communications such as status reports, leadership updates, 3P updates, company newsletters, FAQs, incident reports, project updates, team announcements, or executive summaries. |
| knowledge-agent | knowledge-agent | 1 | Build and query AI-powered knowledge bases from claude-mem observations. Use when users want to create focused "brains" from their observation history, ask questions about past work patterns, or compile expertise on specific topics. |
| learn-codebase | learn-codebase | 1 | Prime a codebase by reading every source file in full. Use when starting work on a new or unfamiliar project, or when the user asks to "learn the codebase", "read the codebase", "prime", or "get up to speed". |
| make-plan | make-plan | 1 | Create a detailed, phased implementation plan with documentation discovery. Use when asked to plan a feature, task, or multi-step implementation — especially before executing with do. |
| mama | mama | 1 | Use when the user asks for 妈妈模式, 妈妈唠叨, mama mode, 唠叨模式, /pua:mama, /pua mama, or $pua-mama; applies a Chinese-mom nagging tone while preserving the same quality bar. |
| mcp-builder | mcp-builder | 1 | Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK). |
| mem-search | mem-search | 1 | Search claude-mem's persistent cross-session memory database. Use when user asks "did we already solve this?", "how did we do X last time?", or needs work from previous sessions. |
| nanobanana | nanobanana | 1 | Use when the user mentions Nano Banana, nanobanana, AI image editing, image generation, prompt-to-image iteration, image-to-image refinement, product mockups, visual concept generation, or local Nano Banana plugin assets. |
| nsfc-grant-writing | nsfc-grant-writing | 1 | Use when the user writes, revises, reviews, or plans a Chinese NSFC grant application, National Natural Science Foundation proposal, guo-zi-ran, 国自然, 基金本子, 立项依据, 科学问题, 研究内容, 技术路线, 创新点, 可行性分析, or grant review response. |
| openclaw | openclaw | 1 | Use when setting up, configuring, or troubleshooting OpenClaw agent memory, memory plugins, gateway memory, persistent observations, memory slots, worker startup, observation feeds, or OpenClaw install commands. |
| p10 | p10 | 1 | P10 CTO mode — define strategic direction, design org topology, manage P9 teams. Use when user says 'CTO模式', 'P10', '战略规划', '架构委员会', or when facing cross-team architectural decisions. Produces: strategic input templates + org design. |
| p7 | p7 | 1 | P7 Senior Engineer mode — solution-driven execution under P8 supervision. Use when user says 'P7模式', '方案驱动', or when spawned as sub-task executor by P8. Produces: implementation plan + code + 3-question self-review, delivered via [P7-COMPLETION]. |
| p9 | p9 | 1 | P9 Tech Lead mode — write Task Prompts, manage P8 agent teams, never write code yourself. Use when user says 'P9模式', 'tech-lead', '帮我管理这个项目', '任务拆解', or when coordinating 3+ parallel agents. Produces: Task Prompts (六要素) + P8 team delivery. |
| pathfinder | pathfinder | 1 | Use when asked to find the ideal path, map a codebase into feature-grouped flowcharts, identify duplicated concerns across features, unify duplicated systems, or audit architecture before a refactor. |
| pdf | pdf | 1 | Use when the user needs PDF document processing: read, extract text/tables/images, merge, split, rotate, watermark, fill forms, encrypt/decrypt, OCR scanned PDFs, inspect PDF layout, or create utility PDFs. Do not use when PDF is only the export format for a poster, slide, visual artwork, or design artifact. |
| pptx | pptx | 1 | Use when a PowerPoint file is involved as input or output: .pptx, slide deck, pitch deck, presentation, speaker notes, templates, layouts, comments, extracting text, editing slides, creating decks, combining files, or splitting presentations. |
| pro | pro | 1 | Use when the user asks for PUA Pro platform extensions: self-evolution tracking, compaction-state protection, KPI reporting, leaderboard, ranking, weekly report, promotion report, 段位, 周报, 述职, 排行榜, 自进化, or /pua:pro features. Do not use for exact alias commands such as $pua-kpi, $pua-flavor, or $pua-pro. |
| pua | pua | 1 | Use when the user explicitly requests PUA mode or signals frustration, repeated failures (2+), passive behavior, quality complaints, unverified completion, giving up, or asks to try harder/change approach. Common triggers: 'try harder', 'figure it out', 'stop giving up', 'you keep failing', '加油', '别偷懒', '你再试试', '为什么还不行', '你怎么又失败了', '又错了', '质量太差', '换个方法', 'stop spinning', 'you broke it', '/pua', 'PUA模式'. Do not trigger for normal first-attempt coding or information requests. |
| pua-cancel-loop | pua-cancel-loop | 1 | Use when the user invokes $pua-cancel-loop or /pua:cancel-loop to cancel the current PUA autonomous loop cleanly. |
| pua-en | pua-en | 1 | Use when a task has failed repeatedly, the agent is stuck tweaking the same approach, suggests manual work too early, blames the environment without verification, or the user says try harder, stop giving up, figure it out, or similar. Also useful for complex debugging, config, deployment, API, research, and writing failures. Do not trigger on first-attempt failures or while a known fix is executing. |
| pua-flavor | pua-flavor | 1 | Use when the user invokes $pua-flavor or /pua:flavor to list or switch PUA flavor options. |
| pua-ja | pua-ja | 1 | Use when the user asks for pua-ja mode or Japanese 詰め style after repeated task failures, same-approach tweaking loops, passive debugging, unverified environment blame, or frustration such as もっと頑張れ / なんとかしろ. |
| pua-kpi | pua-kpi | 1 | Use when the user invokes $pua-kpi or /pua:kpi to generate a PUA KPI report. |
| pua-loop | pua-loop | 1 | Use when the user asks for /pua:pua-loop, $pua-loop, PUA loop mode, 自动循环, 一直跑, or autonomous iterative development that continues until independent verification says the task is done. |
| pua-mama | pua-mama | 1 | Use when the user invokes $pua-mama or /pua:mama as the alias form of mama mode. |
| pua-off | pua-off | 1 | Use when the user invokes $pua-off or /pua:off to turn off PUA mode for the session. |
| pua-offline | pua-offline | 1 | Use when the user invokes $pua-offline or /pua:offline for offline PUA mode, no-network debugging, or local-only task execution. |
| pua-on | pua-on | 1 | Use when the user invokes $pua-on or /pua:on to enable PUA mode, turn on PUA enforcement, or reactivate strict task execution. |
| pua-p10 | pua-p10 | 1 | Use when the user invokes $pua-p10 or /pua:p10 for P10 CTO mode with PUA enforcement. |
| pua-p7 | pua-p7 | 1 | Use when the user invokes $pua-p7 or /pua:p7 for P7 senior engineer mode with PUA enforcement. |
| pua-p9 | pua-p9 | 1 | Use when the user invokes $pua-p9 or /pua:p9 for P9 tech lead mode with PUA enforcement. |
| pua-pro | pua-pro | 1 | Use when the user invokes $pua-pro or /pua:pro for the PUA Pro alias command. |
| pua-reap-orphans | pua-reap-orphans | 1 | Use when the user invokes $pua-reap-orphans or /pua:reap-orphans to clean up orphaned PUA agents or processes. |
| pua-survey | pua-survey | 1 | Use when the user invokes $pua-survey or /pua:survey to inspect the current PUA environment and status. |
| pua-team-status | pua-team-status | 1 | Use when the user invokes $pua-team-status or /pua:team-status to report active PUA team agents and their state. |
| pua-teardown-all | pua-teardown-all | 1 | Use when the user invokes $pua-teardown-all or /pua:teardown-all to stop and clean up all PUA agent activity. |
| pua-yes | pua-yes | 1 | Use when the user invokes $pua-yes or /pua:yes as the alias form for encouragement mode. |
| research-idea-and-battle | research-idea-and-battle | 1 | Use when the user wants rigorous AI/ML research ideation, novelty critique, hypothesis stress-testing, reviewer-style pushback, field positioning, research mentorship, or brainstorming. Trigger on phrases like research idea, battle this, is this novel, what would reviewers think, critique my idea, contribution, positioning, worth pursuing, weaknesses, or who is working on this. |
| scansci-pdf | scansci-pdf | 1 | Use when the user wants to download academic papers, search research literature, fetch DOI/arXiv PDFs, export BibTeX/RIS/EndNote citations, batch-download from a DOI list or .bib file, use Sci-Hub/WebVPN/ institutional access, or says "帮我下载论文", "搜索文献", "批量下载", "论文下载", or "文献检索". Skip ordinary non-academic PDF work. |
| sci-figure | sci-figure | 1 | Use when the user provides Excel, CSV, or structured data and wants publication-grade scientific figures, charts, plotting, exploratory analysis, statistical annotations, captions, figure export, or a traceable analysis report for a paper, thesis, lab report, or formal submission. |
| shared-skill-installer | shared-skill-installer | 1 | Use when the user asks to download, install, import, update, or add new AI skills into the shared WPS/desktop Skills library, especially when they mention placing skills in the correct folder, using the inbox, GitHub skill repos, curated skills, .skill packages, or making newly downloaded skills available to local coding agents, IDE agents, or generic agents. Do not use for designing a brand-new skill from scratch; use skill-creator for that. |
| shot | shot | 1 | PUA Shot — v2 原始浓缩版（449行全量注入），拆分前的完整单文件版本，味道最浓。零依赖零 reference，一次性全部注入上下文。适合 sub-agent 注入、需要最强 PUA 效果、或不想渐进式加载的场景。Triggers on: '/pua:shot', '/pua shot', 'PUA浓缩', 'shot mode', '最强PUA', '全量注入'. Also great for injecting into sub-agents via Read tool since it's self-contained. |
| skill-creator | skill-creator | 1 | Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy. |
| slack-gif-creator | slack-gif-creator | 1 | Use when the user wants an animated GIF optimized for Slack, including emoji GIFs, message GIFs, looped animations, size constraints, frame-rate tuning, palette reduction, or validation before upload. |
| smart-explore | smart-explore | 1 | Use when exploring a codebase efficiently with structural search, tree-sitter AST parsing, function discovery, symbol lookup, or token-optimized code navigation instead of reading full files. |
| theme-factory | theme-factory | 1 | Use when the user wants to apply or create a visual theme for slides, documents, reports, HTML pages, landing pages, or other artifacts, including color palettes, typography, and reusable style systems. |
| timeline-report | timeline-report | 1 | Use when asked for a timeline report, project history analysis, development journey, full project report, or narrative summary built from memory/timeline observations. |
| version-bump | claude-code-plugin-release | 1 | Use when releasing or versioning an agent plugin/package, including semantic version bumps, package.json, marketplace or plugin manifests, npm publishing, build verification, git tags, GitHub releases, and changelog updates. |
| web-access-main | web-access | 1 | Use when the user needs internet or browser access: web search, latest/current information, opening URLs, scraping pages, fetching web content, logged-in browsing, operating websites, dynamic rendered pages, social media collection, source links, or any task requiring a real browser environment. 也用于搜索信息、查看网页内容、访问登录网站、网页抓取、小红书/微博/推特等社交媒体抓取、 动态页面读取和真实浏览器操作。 |
| webapp-testing | webapp-testing | 1 | Use when interacting with or testing local web applications using Playwright, including verifying frontend behavior, debugging UI issues, capturing screenshots, checking browser logs, and exercising localhost apps. |
| web-artifacts-builder | web-artifacts-builder | 1 | Use when creating complex multi-component HTML/web artifacts with React, Tailwind CSS, shadcn/ui, routing, or state management. Do not use for simple single-file HTML or JSX artifacts. |
| wowerpoint | wowerpoint | 1 | Turn one document into a kawaii NotebookLM slide-deck PDF. Use for "wowerpoint this", "make a deck about <file>", "turn this report into slides", or any request to render a single document as shareable narrative slides. |
| xgboost-lightgbm | xgboost-lightgbm | 1 | Use when the user works with tabular machine learning using XGBoost, LightGBM, gradient boosting decision trees, feature importance, hyperparameter tuning, model validation, leakage checks, or structured-data prediction tasks. |
| xlsx | xlsx | 1 | Use when a spreadsheet is the primary input or output: .xlsx, .xlsm, .csv, .tsv, formulas, formatting, charts, data cleaning, table restructuring, or file conversion. Trigger when the user references a spreadsheet path/name or wants a spreadsheet deliverable. Do not use when the primary deliverable is Word, PDF, HTML, code, a database pipeline, or Google Sheets API integration. |
| yes | yes | 1 | SB Leader 夸夸模式 — ENFP 型领导，懂情绪有节奏。底层行为不变（三条红线、方法论），旁白从施压变成共情+鼓励+偶尔戏谑吐槽。Triggers on: '/pua:yes', '夸夸模式', '唠嗑模式', '情绪价值', 'yes', '夸我', '鼓励模式'. |

## Eval Case Map

### academic-research-suite

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\academic-research-suite\SKILL.md`
- Resource dirs: agents, ars, codex, local-skeletons
- `academic-lit-review`: Help me do a systematic literature review, refine the research question, and draft an academic paper plan.

### algorithmic-art

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\algorithmic-art\SKILL.md`
- Resource dirs: templates
- `algorithmic-p5-art`: Create generative art with p5.js, seeded randomness, flow fields, and interactive parameters.

### babysit

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\babysit\SKILL.md`
- Resource dirs: none
- `babysit-pr`: Babysit this pull request: keep checking CI, review comments, and merge readiness until all actionable issues are resolved.

### brand-guidelines

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\brand-guidelines\SKILL.md`
- Resource dirs: none
- `anthropic-brand`: Apply Anthropic brand colors, typography, and official visual guidelines to this artifact.

### canvas-design

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\canvas-design\SKILL.md`
- Resource dirs: canvas-fonts
- `static-poster-design`: Design a polished static poster as a PNG/PDF with strong typography and visual composition.

### claude-api

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\claude-api\SKILL.md`
- Resource dirs: csharp, curl, go, java, php, python, ruby, shared, typescript
- `claude-api-prompt-cache`: This repo imports @anthropic-ai/sdk. Add Claude prompt caching and debug why cache hit rate is low.

### do

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\do\SKILL.md`
- Resource dirs: none
- `execute-plan`: Execute the phased plan we already wrote and carry out the implementation steps.

### doc-coauthoring

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\doc-coauthoring\SKILL.md`
- Resource dirs: none
- `doc-coauthor-spec`: Co-author a technical spec with me, refine it iteratively, and make sure it works for readers.

### docx

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\docx\SKILL.md`
- Resource dirs: scripts
- `word-report-template`: Create a formatted Word report template with headings, page numbers, a table of contents, and tracked comment placeholders.

### frontend-design

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\frontend-design\SKILL.md`
- Resource dirs: none
- `frontend-dashboard`: Build a polished React dashboard UI with filters, table view, chart panel, and responsive layout.

### how-it-works

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\how-it-works\SKILL.md`
- Resource dirs: none
- `claude-mem-how-it-works`: How does claude-mem work? Explain how observations are captured, when memory injection happens, and where the data lives.

### internal-comms

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\internal-comms\SKILL.md`
- Resource dirs: examples
- `internal-status-update`: Write a concise internal 3P update for leadership with progress, plans, problems, and next steps.

### knowledge-agent

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\knowledge-agent\SKILL.md`
- Resource dirs: none
- `knowledge-agent-memory-brain`: Build a focused knowledge base from my past observations and query it for recurring project patterns.

### learn-codebase

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\learn-codebase\SKILL.md`
- Resource dirs: none
- `learn-codebase-prime`: Learn this unfamiliar codebase by reading the source files and getting up to speed before changes.

### make-plan

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\make-plan\SKILL.md`
- Resource dirs: none
- `implementation-plan`: Make a phased implementation plan for this feature with documentation discovery and clear verification gates.

### mama

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\mama\SKILL.md`
- Resource dirs: none
- `mama-mode`: 妈妈模式，唠叨一点也行，盯着我把这个问题彻底解决。

### mcp-builder

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\mcp-builder\SKILL.md`
- Resource dirs: reference, scripts
- `build-mcp-server`: Help me build a high-quality MCP server for an external API with well-designed tools and schemas.

### mem-search

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\mem-search\SKILL.md`
- Resource dirs: none
- `memory-search-prior-solution`: Did we already solve this auth redirect issue before? Search memory for the earlier solution.

### nanobanana

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\nanobanana\SKILL.md`
- Resource dirs: .claude-plugin, references, scripts
- `nano-banana-image`: Use Nano Banana style image editing prompts to turn this product photo into a clean studio mockup.

### nsfc-grant-writing

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\nsfc-grant-writing\SKILL.md`
- Resource dirs: dist, output, proposals, references
- `nsfc-proposal`: 帮我写国自然基金本子，重点打磨立项依据、科学问题、技术路线和创新点。

### openclaw

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\openclaw\SKILL.md`
- Resource dirs: skills, src
- `openclaw-memory-setup`: Set up Claude-Mem on an OpenClaw gateway with memory slots, worker startup, and observation feed.

### p10

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\p10\SKILL.md`
- Resource dirs: none
- `cto-strategy`: Use CTO mode to define strategic direction, architecture governance, and org topology across teams.

### p7

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\p7\SKILL.md`
- Resource dirs: none
- `p7-senior-engineer-mode`: Use P7 senior engineer mode to implement this solution under P8 supervision and include the three-question self-review.

### p9

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\p9\SKILL.md`
- Resource dirs: none
- `subagent-tech-lead`: Act as P9 tech lead, split this project into task prompts, and coordinate multiple P8 agents.

### pathfinder

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pathfinder\SKILL.md`
- Resource dirs: none
- `architecture-pathfinder`: Find the ideal path through this codebase, map duplicated flows, and propose a unified architecture before refactor.

### pdf

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pdf\SKILL.md`
- Resource dirs: scripts
- `pdf-extract-merge`: Extract the tables from this PDF, rotate page 3, and merge it with another PDF.

### pptx

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pptx\SKILL.md`
- Resource dirs: scripts
- `slide-deck-edit`: Open this pptx deck, rewrite the speaker notes, and combine it with another presentation.

### pro

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pro\SKILL.md`
- Resource dirs: none
- `pua-pro-extensions`: Use PUA Pro extensions: KPI report, leaderboard, compaction-state protection, and self-evolution tracking.

### pua

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua\SKILL.md`
- Resource dirs: references
- `pua-main-mode`: 开启 PUA 模式，别再被动等指令，系统性排查、搜索源码、验证结论，把这个问题彻底解决。

### pua-cancel-loop

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-cancel-loop\SKILL.md`
- Resource dirs: none
- `pua-cancel-loop-alias`: Invoke the $pua-cancel-loop alias to cancel the current autonomous loop cleanly.

### pua-en

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-en\SKILL.md`
- Resource dirs: none
- `debugging-pua-en`: This failed twice and you keep tweaking the same thing. Stop giving up, verify the environment, and figure it out.

### pua-flavor

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-flavor\SKILL.md`
- Resource dirs: none
- `pua-flavor-alias`: Invoke $pua-flavor and show me the available PUA flavor options.

### pua-ja

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-ja\SKILL.md`
- Resource dirs: none
- `pua-ja-mode`: 日本語の詰め文化で pua-ja mode にして、同じ失敗を繰り返さず徹底的にデバッグして。

### pua-kpi

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-kpi\SKILL.md`
- Resource dirs: none
- `pua-kpi-alias`: Run $pua-kpi and generate the current PUA KPI report.

### pua-loop

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-loop\SKILL.md`
- Resource dirs: none
- `pua-loop-mode`: Start /pua:pua-loop 自动循环 and keep iterating until independent verification says the task is done.

### pua-mama

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-mama\SKILL.md`
- Resource dirs: none
- `pua-mama-alias`: Invoke $pua-mama as the alias form of mama mode.

### pua-off

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-off\SKILL.md`
- Resource dirs: none
- `pua-off-alias`: Run $pua-off to turn off PUA mode for this session.

### pua-offline

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-offline\SKILL.md`
- Resource dirs: none
- `pua-offline-alias`: Invoke $pua-offline so the PUA workflow runs without network access.

### pua-on

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-on\SKILL.md`
- Resource dirs: none
- `pua-on-alias`: Run $pua-on to enable PUA mode.

### pua-p10

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-p10\SKILL.md`
- Resource dirs: none
- `pua-p10-alias`: Invoke $pua-p10 for P10 CTO mode with PUA enforcement.

### pua-p7

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-p7\SKILL.md`
- Resource dirs: none
- `pua-p7-alias`: Invoke $pua-p7 for P7 senior engineer mode with PUA enforcement.

### pua-p9

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-p9\SKILL.md`
- Resource dirs: none
- `pua-p9-alias`: Invoke $pua-p9 for tech-lead task decomposition with PUA enforcement.

### pua-pro

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-pro\SKILL.md`
- Resource dirs: none
- `pua-pro-alias`: Invoke $pua-pro for the Pro alias command.

### pua-reap-orphans

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-reap-orphans\SKILL.md`
- Resource dirs: none
- `pua-reap-orphans-alias`: Run $pua-reap-orphans to clean up orphaned PUA agents or processes.

### pua-survey

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-survey\SKILL.md`
- Resource dirs: none
- `pua-survey-alias`: Invoke $pua-survey to inspect the current PUA environment and status.

### pua-team-status

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-team-status\SKILL.md`
- Resource dirs: none
- `pua-team-status-alias`: Run $pua-team-status to report all active PUA team agents and their state.

### pua-teardown-all

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-teardown-all\SKILL.md`
- Resource dirs: none
- `pua-teardown-all-alias`: Invoke $pua-teardown-all to stop and clean up all PUA agent activity.

### pua-yes

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\pua-yes\SKILL.md`
- Resource dirs: none
- `pua-yes-alias`: Invoke $pua-yes as the alias form for encouragement mode.

### research-idea-and-battle

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\research-idea-and-battle\SKILL.md`
- Resource dirs: none
- `research-idea-battle`: I have an AI/ML research idea. Battle-test the novelty, tell me what reviewers would attack, and help position it.

### scansci-pdf

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\scansci-pdf\SKILL.md`
- Resource dirs: none
- `paper-download-doi`: Download these DOI papers, get BibTeX citations, and save the PDFs for later reading.

### sci-figure

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\sci-figure\SKILL.md`
- Resource dirs: agents, references
- `scientific-figure-from-csv`: Use this CSV to make a publication-ready scientific figure with error bars, statistical annotations, and a caption.

### shared-skill-installer

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\shared-skill-installer\SKILL.md`
- Resource dirs: scripts
- `shared-skill-install-download`: ??? GitHub ? openai curated skills ?????? AI skill???? WPS ?? Skills ??????? inbox????? library/skills??????????????? Claude Code?Codex ??? agents?

### shot

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\shot\SKILL.md`
- Resource dirs: none
- `pua-shot-mode`: Use /pua:shot, the concentrated single-file strongest PUA injection for a sub-agent.

### skill-creator

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\skill-creator\SKILL.md`
- Resource dirs: agents, assets, eval-viewer, references, scripts
- `create-new-skill`: Create a new Codex skill from scratch, write its SKILL.md, design trigger evals, and package it.

### slack-gif-creator

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\slack-gif-creator\SKILL.md`
- Resource dirs: core
- `slack-gif`: Make a Slack emoji GIF that loops cleanly, stays small enough to upload, and uses the right frame rate.

### smart-explore

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\smart-explore\SKILL.md`
- Resource dirs: none
- `smart-structural-search`: Use structural search to find where this function is defined and map related symbols without reading every file.

### theme-factory

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\theme-factory\SKILL.md`
- Resource dirs: themes
- `theme-artifact`: Apply a coherent visual theme with colors, typography, and layout rules to this slide/report artifact.

### timeline-report

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\timeline-report\SKILL.md`
- Resource dirs: none
- `timeline-project-history`: Generate a journey report of this project from the full development timeline and summarize major phases.

### version-bump

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\version-bump\SKILL.md`
- Resource dirs: scripts
- `release-plugin-version`: Bump the plugin version, update package.json and plugin.json, publish to npm, tag git, and write the changelog.

### web-access-main

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\web-access-main\SKILL.md`
- Resource dirs: .claude-plugin, references, scripts, templates
- `web-search-current-info`: Search the web for the latest policy details, open the pages, and summarize the sources with links.

### webapp-testing

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\webapp-testing\SKILL.md`
- Resource dirs: examples, scripts
- `playwright-localhost-test`: Use Playwright to click through my localhost app, capture screenshots, and inspect browser console errors.

### web-artifacts-builder

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\web-artifacts-builder\SKILL.md`
- Resource dirs: scripts
- `complex-html-artifact`: Create a multi-view HTML artifact with React state, Tailwind styling, shadcn components, and client-side routing.

### wowerpoint

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\wowerpoint\SKILL.md`
- Resource dirs: none
- `wowerpoint-deck`: Wowerpoint this report into a cute NotebookLM-style slide-deck PDF.

### xgboost-lightgbm

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\xgboost-lightgbm\SKILL.md`
- Resource dirs: none
- `xgboost-tabular-model`: Train an XGBoost or LightGBM model on this tabular CSV, check leakage, tune parameters, and report feature importance.

### xlsx

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\xlsx\SKILL.md`
- Resource dirs: scripts
- `spreadsheet-clean-xlsx`: I have an Excel file with messy headers and blank rows. Clean it up, add formulas, and return a polished xlsx.

### yes

- `SKILL.md`: `C:\Users\liuji\Desktop\Skills\library\skills\yes\SKILL.md`
- Resource dirs: none
- `yes-encouragement-mode`: 开启夸夸模式，给我一点情绪价值，但底层做事标准不要降低。

