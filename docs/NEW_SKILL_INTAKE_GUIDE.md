# 新 skills 加入指南

## 给用户的用法

以后有新的 skills，只需要先放进：

```text
C:\Users\liuji\Desktop\Skills\00_新skills待整理_INBOX
```

可以放入的内容包括：

- 已经解压的 skill 文件夹
- `.skill` 文件
- `.zip` 或其他压缩包
- 只有说明文档的 Markdown 或 txt
- 第三方项目文件夹
- 你自己写的一段 skill 想法

放好后，对 AI 说：

```text
请读取 00_新skills待整理_INBOX，按照里面的 00-AI整理新skills标准流程.md，把新内容整理成标准 skill，并跑普通质量闸门。
```

如果新 skill 来自 GitHub、OpenAI curated skills、`.skill` 包或其他可下载来源，可以对 AI 说：

```text
请使用 shared-skill-installer 下载这个新 skill，并放到共享 Skills 库的正确位置。
```

## 标准 skill 目标结构

```text
library/skills/<skill-name>/
  SKILL.md
  references/   可选
  scripts/      可选
  assets/       可选
```

`SKILL.md` 至少需要：

```markdown
---
name: example-skill
description: Use when the user asks for a specific workflow or task that this skill should handle.
---

# Example Skill

Instructions for the agent.
```

## AI 整理时必须做

- 给每个新 skill 起稳定、英文、短横线命名的目录名。
- 保留原始输入，不直接删除。
- 如果 skill 名称和现有 skill 冲突，先说明冲突，不要静默覆盖。
- 把流程说明写进 `SKILL.md` body，把触发条件写进 `description`。
- 每个新增或明显改动的 skill 都要补充 `docs/trigger-evals.json`。
- 运行 `.\运行-一键质量闸门.ps1`。

## 整理完成后的归档

通过质量闸门后，AI 才可以把 inbox 中对应原始输入归档到：

```text
archive/new-skill-intake/YYYY-MM-DD/
```

归档不是删除，是保留原始材料，方便以后追溯。
