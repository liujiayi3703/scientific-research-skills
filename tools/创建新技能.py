#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
一键创建新技能 - 小白友好版

用法：python 创建新技能.py <技能名>

示例：python 创建新技能.py my-data-analyzer

新技能会生成在 output/ 文件夹下。
"""

import sys
import re
from pathlib import Path

# 添加 scripts 目录到路径
SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR / "scripts"))

from init_skill import init_skill


def main():
    print("=" * 50)
    print("  创建新技能")
    print("=" * 50)

    if len(sys.argv) < 2:
        print("\n请输入技能名称（仅小写字母、数字、连字符）")
        print("示例：my-pdf-tool, data-analyzer\n")
        skill_name = input("技能名称: ").strip()
        if not skill_name:
            print("[错误] 未输入技能名称")
            sys.exit(1)
    else:
        skill_name = sys.argv[1].strip()

    # 校验命名规则
    if not re.match(r"^[a-z0-9-]+$", skill_name):
        print(f"\n[错误] 技能名「{skill_name}」不符合规则")
        print("规则：仅小写字母、数字、连字符，如 my-pdf-tool")
        sys.exit(1)
    if skill_name.startswith("-") or skill_name.endswith("-") or "--" in skill_name:
        print(f"\n[错误] 技能名不能以连字符开头/结尾，也不能有连续连字符")
        sys.exit(1)

    output_dir = SCRIPT_DIR / "output"
    output_dir.mkdir(exist_ok=True)

    print(f"\n[创建] 技能名：{skill_name}")
    print(f"       位置：{output_dir}\n")

    result = init_skill(skill_name, str(output_dir))

    if result:
        print("\n" + "=" * 50)
        print(f"完成！请编辑：output/{skill_name}/SKILL.md")
        print("=" * 50)
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
