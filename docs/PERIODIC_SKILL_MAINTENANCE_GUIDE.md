# 定期整理 skills 流程

这个流程用于每周或每月让 AI 检查一次 skills 总库。默认目标是发现问题、生成报告、做必要的标准化修复，不自动删除旧 skill。

## 建议频率

- 新增或修改 skill 后：立即运行普通质量闸门。
- 每周：运行结构审计、触发词审计和普通质量闸门。
- 每月：检查是否有重复 skill、过期 skill、触发边界模糊、说明文档失效。

## 标准步骤

1. 读取 `AGENTS.md`、`README.md` 和本文件。
2. 盘点 `library/skills/`，确认每个 skill 都有 `SKILL.md`。
3. 检查 `SKILL.md` frontmatter 是否包含 `name` 和 `description`。
4. 检查 `description` 是否适合作为触发条件。
5. 运行：

```powershell
.\运行-结构审计.ps1
.\运行-触发词审计.ps1
.\运行-一键质量闸门.ps1
```

6. 如有新增或修改 skill，更新 `docs/trigger-evals.json`。
7. 如需验证真实 app，先生成平台验证包，再让真实 app 按 CSV 填结果。
8. 只有 `.\运行-严格检查真实平台100%.ps1` 通过，才可以说真实多平台 100%。

## 维护限制

- 不自动删除旧 skill。
- 不把原始资料直接塞进 `library/skills/`。
- 不随意重命名已有 skill。
- 不为了通过测试而把 `description` 写得过宽。
- 不跳过普通质量闸门。
- 不用本地代理测试替代真实 app 验证。

## 允许的修复

- 修复乱码、frontmatter 缺失、目录结构错误。
- 精简过长或过宽的 `description`。
- 给缺少触发案例的 skill 补充 `docs/trigger-evals.json`。
- 更新 README、索引、manifest 和平台验证包。
- 把非标准材料移出 `library/skills/`，放到更合适的资料目录或归档目录。

