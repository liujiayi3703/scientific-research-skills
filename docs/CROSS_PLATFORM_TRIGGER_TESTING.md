# 跨平台触发测试流程

目标：让 `library/skills` 里的 skills 在 Claude Code、Codex、Trae IDE/SOLO、豆包、Marvis、GLM 等环境中尽量稳定、精准地被调用。

## 测试分三层

推荐先跑完整质量闸门：

```powershell
.\tools\Invoke-SkillQualityGate.ps1
```

它会顺序运行结构审计、触发词审计、路由测试、manifest 导出、真实平台验证包导出，并检查默认 Claude/Codex/Agents 目录是否包含全部共享 skills。

真实平台结果填完后，用严格模式作为最终 100% 门槛：

```powershell
.\tools\Invoke-SkillQualityGate.ps1 -RequireRealPlatformComplete
```

1. **结构审计**
   确认每个标准 skill 都有 `SKILL.md`。

   ```powershell
   .\tools\Audit-Skills.ps1
   ```

2. **触发词审计**
   检查 `description` 是否过长、缺失、乱码、过泛或容易误触发。

   ```powershell
   .\tools\Audit-SkillTriggers.ps1
   ```

3. **路由测试**
   用真实用户提示测试 expected skill 是否排在 top-1。

   ```powershell
   python .\tools\Test-SkillRouting.py --evals .\docs\trigger-evals.json --skills .\library\skills --out-dir .\docs
   ```

4. **通用 manifest 导出**
   为不支持扫描 skills 目录的通用 agents 生成机器可读清单。

   ```powershell
   .\tools\Export-SkillManifest.ps1
   ```

5. **真实平台验证包**
   生成 Claude Code、Codex、Trae/SOLO、豆包/Marvis/GLM 等平台的手动实测矩阵。

   ```powershell
   .\tools\Export-PlatformValidationPack.ps1
   ```

6. **真实平台结果汇总**
   读取 `docs/platform-validation-prompts.csv` 里的人工实测结果，生成 pass/fail/untested 汇总。

   ```powershell
   .\tools\Summarize-PlatformValidation.ps1
   ```

## 当前通过标准

- `Audit-Skills.ps1`：`Non-standard folders in library/skills: 0`
- `Test-SkillRouting.py`：四个平台代理 profile 的 top-1 都应为 `100.0%`
- `blocked_top3`：应为 `0`，表示没有不该靠近的竞争 skill 进入高相似 top-3
- `allowed_related_top3`：允许大于 `0`，表示同族或上下游 skill 靠近，但 top-1 仍必须是 expected skill

脚本是保守的词法代理测试，不等同于真实平台内部路由。它适合发现明显触发词问题；最终要宣称某个平台 100% 精准，仍需要在该平台用同一批提示做实测。

## 添加新测试

编辑：

```text
docs/trigger-evals.json
```

每个测试包含：

```json
{
  "id": "short-case-id",
  "prompt": "realistic user request",
  "expected_skill": "skill-folder-name",
  "blocked_skills": ["near-miss-skill"],
  "allowed_related_skills": ["acceptable-neighbor-skill"]
}
```

新增 skill 时，至少增加 1 条正向测试；如果它和已有 skill 相近，增加 1 条 near-miss 测试。

- `blocked_skills`：不希望高相似靠近的竞争 skill；如果进入高相似 top-3，会算 ambiguity warning。
- `allowed_related_skills`：允许在 top-3 附近出现的同族、别名、上下游 skill；它不能替代 expected skill，top-1 错了仍然失败。

## 平台实际验证

要宣称某个平台 100% 精准，需要在该平台用 `docs/trigger-evals.json` 的提示逐条测试，并把结果记录回报告。

记录位置：

- `docs/REAL_PLATFORM_VALIDATION_MATRIX.md`
- `docs/REAL_PLATFORM_VALIDATION_SUMMARY.md`
- `docs/platform-validation-prompts.csv`
- `docs/platform-prompt-packs/`
