# AI skills 定期维护提示词

把下面这段话复制给负责整理的 AI 或 agent。

```text
请维护 C:\Users\liuji\Desktop\Skills 这个共享 AI skills 总库。

执行前请先读取：
- AGENTS.md
- README.md
- docs/PERIODIC_SKILL_MAINTENANCE_GUIDE.md
- docs/NEW_SKILL_INTAKE_GUIDE.md

任务：
1. 盘点 00_新skills待整理_INBOX 中是否有新内容。
2. 如果有新内容，按照 00_新skills待整理_INBOX/00-AI整理新skills标准流程.md 转换成标准 skill。
3. 检查 library/skills 中所有 skill 是否符合标准结构。
4. 检查每个 SKILL.md 的 name 和 description 是否存在、清晰、适合触发。
5. 对新增或修改的 skill，同步更新 docs/trigger-evals.json。
6. 运行普通质量闸门：.\运行-一键质量闸门.ps1
7. 如普通质量闸门通过，再运行：.\运行-接入全部AI平台skills.ps1
8. 输出维护报告：修改了哪些文件、发现哪些风险、哪些事项需要用户决定。

限制：
- 不要直接删除 inbox 原始文件，只能归档。
- 不要用 -Force 覆盖接入目录，除非我明确要求。
- 不要随意删除或重命名已有 skill。
- 不要声称真实多平台 100%，除非 .\运行-严格检查真实平台100%.ps1 通过。
```

