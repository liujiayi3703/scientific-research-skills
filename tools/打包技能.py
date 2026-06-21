#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
一键打包技能 - 小白友好版

用法：python 打包技能.py [技能路径]

示例：
  python 打包技能.py output/my-skill
  python 打包技能.py                    （打包当前目录，需在技能文件夹内运行）

打包后的 .skill 文件会生成在 dist/ 文件夹。
"""

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR / "scripts"))

from package_skill import package_skill


def main():
    print("=" * 50)
    print("  打包技能")
    print("=" * 50)

    if len(sys.argv) >= 2:
        skill_path = Path(sys.argv[1])
        if not skill_path.is_absolute():
            skill_path = SCRIPT_DIR / skill_path
    else:
        # 默认打包当前目录（假设在技能文件夹内运行）
        skill_path = SCRIPT_DIR
        if not (skill_path / "SKILL.md").exists():
            print("\n[提示] 当前目录不是技能文件夹（未找到 SKILL.md）")
            print("请指定技能路径，例如：python 打包技能.py output/my-skill\n")
            skill_path = None

    if skill_path is None:
        path_input = input("请输入技能路径（如 output/my-skill）: ").strip()
        if not path_input:
            print("[错误] 未输入路径")
            sys.exit(1)
        skill_path = SCRIPT_DIR / path_input

    if not skill_path.exists():
        print(f"\n[错误] 路径不存在：{skill_path}")
        sys.exit(1)

    output_dir = SCRIPT_DIR / "dist"

    print(f"\n[打包] 技能路径：{skill_path}")
    print(f"       输出目录：{output_dir}\n")

    result = package_skill(str(skill_path), str(output_dir))

    if result:
        print("\n" + "=" * 50)
        print(f"完成！文件位置：{result}")
        print("=" * 50)
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
