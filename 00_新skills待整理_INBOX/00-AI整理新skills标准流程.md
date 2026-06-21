# AI 整理新 skills 标准流程

这个文件夹是新 skills 的收件夹。用户可以把新 skill、`.skill` 包、压缩包、Markdown、项目文件夹或零散说明先放到这里，再让 AI 整理。

## AI 执行规则

1. 先盘点本文件夹内容，列出每个输入的来源、类型和可能用途。
2. 不直接删除、覆盖或改写原始输入。
3. 判断输入是否已经是标准 skill：
   - 标准 skill 必须位于独立文件夹中。
   - 必须包含 `SKILL.md`。
   - `SKILL.md` 必须有 YAML frontmatter。
   - frontmatter 至少包含 `name` 和 `description`。
4. 如果不是标准 skill，复制或转换到 `library/skills/<skill-name>/SKILL.md`。
5. `description` 优先写成 `Use when...`，只描述触发条件，不塞完整执行流程。
6. 同步补充或更新 `docs/trigger-evals.json`，至少加入一个真实触发案例。
7. 运行普通质量闸门：`.\运行-一键质量闸门.ps1`。
8. 质量闸门通过后，再运行：`.\运行-接入全部AI平台skills.ps1`。
9. 整理完成后，把原始输入移动到 `archive/new-skill-intake/YYYY-MM-DD/`，并保留来源说明。

## 禁止事项

- 不要把半成品直接放进 `library/skills/`。
- 不要跳过 `docs/trigger-evals.json`。
- 不要用 `-Force` 覆盖本地接入目录，除非用户明确要求。
- 不要声称真实多平台 100% 可用，除非严格真实平台闸门通过。

