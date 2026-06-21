# 触发词审计摘要

生成日期：2026-06-21

## 结论

- 标准 skill 数量：65
- 非标准目录：0
- 触发描述需复核：0
- 触发测试覆盖：65/65
- 四类平台代理画像 top-1：100%
- 真正阻塞型 ambiguity：0
- 允许的同族/上下游近邻：43 次，均未超过 expected skill

## 本次处理

1. 清理了 22 个触发描述问题，主要包括：
   - PUA alias 类 skill 去掉非必要的平台绑定词。
   - `mama`、`pua-ja` 改成以 `Use when...` 开头的触发条件。
   - `scansci-pdf` 缩短为论文下载、DOI/arXiv、引文导出、WebVPN/机构访问等核心触发词。
   - `openclaw`、`version-bump` 改成更平台中性的描述。

2. 扩展了 `docs/trigger-evals.json`：
   - 保留 `blocked_skills` 作为真正不希望靠近的竞争项。
   - 新增 `allowed_related_skills` 标注允许出现在 top-3 的同族、别名或上下游 skill。

3. 更新了 `tools/Test-SkillRouting.py`：
   - top-1 命中仍是硬标准。
   - `blocked_top3` 只统计真正风险。
   - `allowed_related_top3` 单独统计可接受近邻，避免误把正常同族关系当成失败。

## 复跑命令

```powershell
.\tools\Audit-Skills.ps1
.\tools\Audit-SkillTriggers.ps1
python .\tools\Test-SkillRouting.py --evals .\docs\trigger-evals.json --skills .\library\skills --out-dir .\docs
```

## 当前报告

- 结构索引：`docs/SKILL_INDEX.md`
- 静态触发审计：`docs/TRIGGER_AUDIT.md`
- 路由测试结果：`docs/TRIGGER_TEST_RESULTS.md`
- 原始审计表：`docs/trigger-audit.csv`
- 原始路由结果：`docs/trigger-test-results.csv`

## 后续注意

这次结果证明当前描述在本地代理测试里可以稳定 top-1 命中。它不是 Claude Code、Codex、Trae/SOLO、豆包、Marvis、GLM 的真实内部路由证明。若要对某个平台宣称 100% 精准，需要在该平台用同一批 `trigger-evals.json` 提示逐条实测并记录结果。
