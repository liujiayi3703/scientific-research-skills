# AGENTS.md

本目录是共享 AI skills 总库。AI 或 agent 修改这里时，请遵循以下规则。

## 核心规则

- 标准 skill 只放在 `library/skills/<skill-name>/`。
- 每个标准 skill 必须包含 `SKILL.md`，并且 frontmatter 至少包含 `name` 和 `description`。
- 新 skill、压缩包、Markdown、项目文件夹或半成品先放在 `00_新skills待整理_INBOX/`，不要直接塞进 `library/skills/`。
- 非标准资料、半成品、源码项目不要放进 `library/skills/`。
- 原始压缩包、旧版本、数据库导出放进 `archive/`，不要随意删除。
- 新增或修改 skill 后必须重新运行普通质量闸门。

## 新 skill 整理流程

当用户要求下载、安装、导入或更新新 skill 到本共享库时，优先使用 `shared-skill-installer`。

1. 先读取 `00_新skills待整理_INBOX/00-AI整理新skills标准流程.md`。
2. 盘点 inbox 内容，说明每个输入准备如何处理。
3. 不直接删除或覆盖原始输入。
4. 转换后的标准 skill 放入 `library/skills/<skill-name>/SKILL.md`。
5. `description` 优先写成 `Use when...`，只写触发条件。
6. 同步更新 `docs/trigger-evals.json`。
7. 运行 `.\运行-一键质量闸门.ps1`。
8. 通过后再运行 `.\运行-接入全部AI平台skills.ps1`。
9. 处理完成的原始输入归档到 `archive/new-skill-intake/YYYY-MM-DD/`。

## 必跑命令

优先运行一键质量闸门：

```powershell
.\运行-一键质量闸门.ps1
```

只有在 `docs/platform-validation-prompts.csv` 已填完真实平台结果后，才运行严格真实平台门禁：

```powershell
.\运行-严格检查真实平台100%.ps1
```

如果需要逐项排查，再运行：

```powershell
.\运行-结构审计.ps1
.\运行-触发词审计.ps1
python .\tools\Test-SkillRouting.py --evals .\docs\trigger-evals.json --skills .\library\skills --out-dir .\docs
.\运行-导出通用Agents技能清单.ps1
.\运行-生成真实平台验证包.ps1
.\运行-汇总真实平台验证结果.ps1
```

## 接入命令

```powershell
.\运行-接入全部AI平台skills.ps1
```

这个入口会接入 Claude Code、Codex 和通用 agents 的默认本地目录。其他 app 使用 `tools\Connect-Skills.ps1 -CustomTargetDirs`。

## 触发精准度要求

- 修改 `description` 时，优先写成 `Use when...`。
- 描述只写触发条件，不要把完整流程塞进 description。
- 避免过长、乱码、第一人称、只适配单一平台的描述。
- 当两个 skill 容易混淆时，用更具体的关键词拉开边界。
- 保持 `docs/trigger-evals.json` 和真实使用场景同步扩展。
- 不支持目录扫描的平台优先读取 `docs/skills-manifest.json`，再读取具体 `SKILL.md`。
- 真实 app 是否 100% 精准调用，只能记录在 `docs/REAL_PLATFORM_VALIDATION_MATRIX.md`，不能用本地代理测试替代。

## 限制

- 不要直接删除 inbox 原始文件，只能归档。
- 不要用 `-Force` 覆盖接入目录，除非用户明确要求。
- 不要随意删除或重命名已有 skill。
- 不要为了测试通过而把 skill 描述写得过宽。
- 不要声称真实多平台 100%，除非严格真实平台闸门通过。
