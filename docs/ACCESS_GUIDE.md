# 多平台接入指南

## 一键接入推荐命令

```powershell
cd C:\Users\liuji\Desktop\Skills
Set-ExecutionPolicy -Scope Process Bypass -Force
.\运行-接入全部AI平台skills.ps1
```

## 内置目标

根目录入口默认接入全部内置目标：

| 目标 | 接入目录 | 适用 |
| --- | --- | --- |
| Claude | `%USERPROFILE%\.claude\skills` | Claude Code |
| Codex | `%USERPROFILE%\.codex\skills` | Codex |
| Agents | `%USERPROFILE%\.agents\skills` | 通用 agents |

如果只想接入某一个目标，使用底层脚本：

```powershell
.\tools\Connect-Skills.ps1 -Targets Claude
.\tools\Connect-Skills.ps1 -Targets Codex
.\tools\Connect-Skills.ps1 -Targets Agents
```

## Trae IDE / SOLO / 豆包 / Marvis / GLM 等通用接入

这些平台没有统一的本地 skills 目录时，优先使用以下两种方式：

1. 如果 app 支持指定技能目录，直接指向：

```text
C:\Users\liuji\Desktop\Skills\library\skills
```

2. 如果 app 要求复制到某个本地目录，用：

```powershell
.\tools\Connect-Skills.ps1 -CustomTargetDirs "D:\AppName\skills"
```

如果不支持目录接入，则让 agent 读取：

- `docs/skills-manifest.json`
- `docs/SKILLS_MANIFEST.md`
- `docs/SKILL_INDEX.md`
- `docs/TRIGGER_TEST_RESULTS.md`
- 需要用到的具体 `library/skills/<skill-name>/SKILL.md`

## 链接模式和复制模式

默认 `Auto` 会优先创建目录链接，失败后复制：

```powershell
.\tools\Connect-Skills.ps1 -Mode Auto -Targets All
```

强制复制：

```powershell
.\tools\Connect-Skills.ps1 -Mode Copy -Targets All -Force
```

强制重建链接或副本：

```powershell
.\tools\Connect-Skills.ps1 -Targets All -Force
```

注意：不要让 AI 自动使用 `-Force`，除非你明确要求覆盖已有接入目录。

## 根目录验证入口

| 文件 | 功能 |
| --- | --- |
| `运行-一键质量闸门.ps1` | 本地结构、触发词、路由和文档产物检查。 |
| `运行-生成真实平台验证包.ps1` | 生成真实 app 测试 prompt pack。 |
| `运行-汇总真实平台验证结果.ps1` | 汇总人工填写的真实平台结果。 |
| `运行-严格检查真实平台100%.ps1` | 真实平台结果全部通过时才会通过。 |

普通质量闸门：

```powershell
.\运行-一键质量闸门.ps1
```

真实 app 结果填完后：

```powershell
.\运行-严格检查真实平台100%.ps1
```

检查报告：

- `docs/skills-manifest.json`
- `docs/SKILLS_MANIFEST.md`
- `docs/SKILL_INDEX.md`
- `docs/TRIGGER_AUDIT.md`
- `docs/TRIGGER_TEST_RESULTS.md`
- `docs/REAL_PLATFORM_VALIDATION_MATRIX.md`
- `docs/REAL_PLATFORM_VALIDATION_SUMMARY.md`
- `docs/platform-prompt-packs/`
- `docs/QUALITY_GATE_REPORT.md`

