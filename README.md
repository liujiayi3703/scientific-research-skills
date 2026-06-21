# Shared AI Skills Library

这个文件夹是你的网盘同步版 AI skills 总库，目标是让同一套 skills 能在多台电脑、多个 AI app 或 IDE 中复用。

## 当前状态

- 标准 skills 目录：`library/skills/`
- 新 skills 收件夹：`00_新skills待整理_INBOX/`
- 当前标准 skills 数量：66
- 一键质量闸门：`运行-一键质量闸门.ps1`
- 多平台接入：`运行-接入全部AI平台skills.ps1`
- 技能索引：`docs/SKILL_INDEX.md`
- 通用 manifest：`docs/skills-manifest.json`
- 真实平台验证表：`docs/platform-validation-prompts.csv`

## 根目录运行入口

优先使用根目录这些脚本，不需要记住 `tools/` 里的底层脚本名。

| 文件 | 功能 |
| --- | --- |
| `运行-一键质量闸门.ps1` | 运行结构审计、触发词审计、路由测试、manifest 导出和平台验证汇总。 |
| `运行-接入全部AI平台skills.ps1` | 接入 Claude Code、Codex 和通用 agents 默认目录。 |
| `运行-结构审计.ps1` | 检查 `library/skills/` 是否都是标准 skill。 |
| `运行-触发词审计.ps1` | 检查 skill 描述是否容易误触发或触发不足。 |
| `运行-导出通用Agents技能清单.ps1` | 导出 `docs/skills-manifest.json` 和 `docs/SKILLS_MANIFEST.md`。 |
| `运行-生成真实平台验证包.ps1` | 生成真实 app 测试用 prompt pack 和 CSV。 |
| `运行-汇总真实平台验证结果.ps1` | 汇总 `platform-validation-prompts.csv` 的真实测试结果。 |
| `运行-严格检查真实平台100%.ps1` | 只有真实平台测试全部通过时才会通过。 |

## 目录功能

| 目录 | 功能 |
| --- | --- |
| `00_新skills待整理_INBOX/` | 新 skill 收件夹。先把新内容放这里，再让 AI 按标准流程整理。 |
| `library/skills/` | 标准 skill 库。每个子目录必须包含 `SKILL.md`。 |
| `library/research-kits/` | 研究资料包、半成品、待整理内容。 |
| `library/source-projects/` | 源码项目或第三方工具项目。 |
| `library/references/` | 通用参考资料。 |
| `docs/` | 使用说明、技能索引、触发测试报告、真实平台验证结果。 |
| `tools/` | 接入、审计、测试、创建、打包的底层脚本。一般优先用根目录入口。 |
| `archive/` | 原始包、旧版本、数据库导出和备份。 |

## 新 skills 怎么加入

1. 把新 skill 或原始材料放进：

```text
C:\Users\liuji\Desktop\Skills\00_新skills待整理_INBOX
```

2. 对 AI 说：

```text
请读取 00_新skills待整理_INBOX，按照里面的 00-AI整理新skills标准流程.md，把新内容整理成标准 skill，并跑普通质量闸门。
```

3. AI 整理完成后，标准 skill 应位于：

```text
library/skills/<skill-name>/SKILL.md
```

4. 原始输入归档到：

```text
archive/new-skill-intake/YYYY-MM-DD/
```

更详细流程见 `docs/NEW_SKILL_INTAKE_GUIDE.md`。

如果你要让 AI 从 GitHub、OpenAI curated skills、`.skill` 包或本地文件夹下载并安装新 skill，可以直接说：

```text
请使用 shared-skill-installer，把这个新 skill 下载到共享 Skills 库的正确位置，并按标准流程整理、测试和接入。
```

`shared-skill-installer` 会先把原始内容放进 `00_新skills待整理_INBOX/`，再按标准流程整理到 `library/skills/`。

## 新电脑第一次接入

在 PowerShell 里进入本目录：

```powershell
cd C:\Users\liuji\Desktop\Skills
Set-ExecutionPolicy -Scope Process Bypass -Force
.\运行-接入全部AI平台skills.ps1
```

这个入口会接入：

- Claude Code：`%USERPROFILE%\.claude\skills`
- Codex：`%USERPROFILE%\.codex\skills`
- 通用 agents：`%USERPROFILE%\.agents\skills`

如果某个 app 有自己的 skills 目录，用底层脚本指定自定义目标：

```powershell
.\tools\Connect-Skills.ps1 -CustomTargetDirs "D:\YourApp\skills"
```

## 日常维护

新增或修改 skill 后，先跑：

```powershell
.\运行-一键质量闸门.ps1
```

每周或每月整理时，按 `docs/PERIODIC_SKILL_MAINTENANCE_GUIDE.md` 执行。

真实平台结果填完后，才能用严格模式确认是否真的全平台 100%：

```powershell
.\运行-严格检查真实平台100%.ps1
```

注意：普通质量闸门只能证明本地结构、触发词和代理路由测试通过，不能替代真实 app 测试。
