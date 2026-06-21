#!/usr/bin/env python3
"""Platform-neutral trigger tests for a shared skill library.

This is not a vendor-internal router. It is a conservative proxy: if concise
skill names and descriptions can route realistic prompts correctly here, they
are more likely to route well across Claude Code, Codex, Trae/SOLO, and generic
agent apps.
"""

from __future__ import annotations

import argparse
import csv
import json
import math
import re
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any


STOPWORDS = {
    "a",
    "an",
    "and",
    "are",
    "as",
    "at",
    "be",
    "by",
    "for",
    "from",
    "in",
    "into",
    "is",
    "it",
    "of",
    "on",
    "or",
    "the",
    "this",
    "to",
    "use",
    "using",
    "when",
    "with",
    "work",
    "working",
    "works",
    "want",
    "wants",
    "user",
    "users",
}

PROFILES = {
    "claude-code": {"name": 2.6, "description": 3.0, "body": 0.25},
    "codex": {"name": 3.0, "description": 2.7, "body": 0.2},
    "trae-solo": {"name": 3.4, "description": 2.2, "body": 0.35},
    "generic-agents": {"name": 3.8, "description": 2.0, "body": 0.4},
}


@dataclass
class Skill:
    folder: str
    name: str
    description: str
    body_head: str


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig")


def parse_frontmatter(text: str) -> tuple[dict[str, str], str]:
    if not text.startswith("---"):
        return {}, text

    lines = text.splitlines()
    end_index = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end_index = i
            break
    if end_index is None:
        return {}, text

    fields: dict[str, str] = {}
    current_key: str | None = None
    current_parts: list[str] = []

    def flush() -> None:
        nonlocal current_key, current_parts
        if current_key:
            fields[current_key] = " ".join(part.strip() for part in current_parts if part.strip()).strip()
        current_key = None
        current_parts = []

    for raw in lines[1:end_index]:
        if not raw.strip():
            continue
        match = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", raw)
        if match:
            flush()
            current_key = match.group(1)
            value = match.group(2).strip()
            if value in {"|", ">"}:
                current_parts = []
            elif value:
                current_parts = [value.strip("\"'")]
            else:
                current_parts = []
        elif current_key and raw.startswith((" ", "\t")):
            current_parts.append(raw.strip().strip("\"'"))
    flush()

    body = "\n".join(lines[end_index + 1 :])
    return fields, body


def cjk_ngrams(token: str) -> list[str]:
    chars = [ch for ch in token if "\u4e00" <= ch <= "\u9fff"]
    grams = chars[:]
    grams.extend("".join(chars[i : i + 2]) for i in range(max(0, len(chars) - 1)))
    grams.extend("".join(chars[i : i + 3]) for i in range(max(0, len(chars) - 2)))
    return grams


def tokenize(text: str) -> list[str]:
    text = text.lower()
    raw_tokens = re.findall(r"[a-z0-9][a-z0-9+#.@_-]*|[\u4e00-\u9fff]+|[\u3040-\u30ff]+", text)
    out: list[str] = []
    for token in raw_tokens:
        if re.fullmatch(r"[\u4e00-\u9fff]+", token):
            out.extend(cjk_ngrams(token))
            continue
        parts = re.split(r"[-_/]", token)
        for part in parts + [token]:
            part = part.strip()
            if len(part) < 2 or part in STOPWORDS:
                continue
            out.append(part)
    return out


def load_skills(skills_dir: Path) -> list[Skill]:
    skills: list[Skill] = []
    for folder in sorted(path for path in skills_dir.iterdir() if path.is_dir()):
        skill_md = folder / "SKILL.md"
        if not skill_md.exists():
            continue
        text = read_text(skill_md)
        fields, body = parse_frontmatter(text)
        body_head = "\n".join(body.splitlines()[:40])
        skills.append(
            Skill(
                folder=folder.name,
                name=fields.get("name", folder.name).strip() or folder.name,
                description=fields.get("description", "").strip(),
                body_head=body_head,
            )
        )
    return skills


def load_evals(path: Path) -> list[dict[str, Any]]:
    data = json.loads(read_text(path))
    if isinstance(data, dict):
        cases = data.get("cases", [])
    else:
        cases = data
    if not isinstance(cases, list):
        raise ValueError("Eval file must contain a list or an object with a 'cases' list.")
    return cases


def build_idf(skills: list[Skill]) -> dict[str, float]:
    docs: list[set[str]] = []
    for skill in skills:
        docs.append(set(tokenize(" ".join([skill.folder, skill.name, skill.description, skill.body_head]))))
    df: Counter[str] = Counter()
    for doc in docs:
        df.update(doc)
    total = max(1, len(docs))
    return {token: math.log((1 + total) / (1 + count)) + 1 for token, count in df.items()}


def skill_vector(skill: Skill, profile: dict[str, float]) -> Counter[str]:
    vector: Counter[str] = Counter()
    for token in tokenize(skill.folder.replace("-", " ") + " " + skill.name):
        vector[token] += profile["name"]
    for token in tokenize(skill.description):
        vector[token] += profile["description"]
    for token in tokenize(skill.body_head):
        vector[token] += profile["body"]
    return vector


def score_prompt(prompt: str, skill: Skill, vector: Counter[str], idf: dict[str, float]) -> float:
    prompt_tokens = Counter(tokenize(prompt))
    score = 0.0
    for token, count in prompt_tokens.items():
        if token in vector:
            score += min(count, 3) * vector[token] * idf.get(token, 1.0)

    prompt_l = prompt.lower()
    folder_phrase = skill.folder.replace("-", " ").lower()
    name_phrase = skill.name.replace("-", " ").lower()
    folder_l = skill.folder.lower()
    name_l = skill.name.lower()
    exact_markers = {
        f"${folder_l}",
        f"${name_l}",
        f"/{folder_l}",
        f"/{name_l}",
        f"/pua:{folder_l}",
    }
    if folder_l.startswith("pua-"):
        exact_markers.add("/pua:" + folder_l.removeprefix("pua-"))

    def has_explicit_marker(marker: str) -> bool:
        escaped = re.escape(marker)
        if marker.startswith(("$", "/")):
            return re.search(escaped + r"(?![a-z0-9_-])", prompt_l) is not None
        return marker in prompt_l

    if any(has_explicit_marker(marker) for marker in exact_markers):
        score += 250.0

    alias_command_present = "$pua-" in prompt_l or "/pua:" in prompt_l
    if skill.folder == "pua" and not alias_command_present:
        if (
            re.search(r"(^|\s)/pua(\s|$)", prompt_l)
            or "pua mode" in prompt_l
            or "pua 模式" in prompt_l
            or "pua模式" in prompt_l
            or "开启 pua" in prompt_l
        ):
            score += 120.0

    if skill.folder == "canvas-design" and any(
        phrase in prompt_l
        for phrase in [
            "poster",
            "static design",
            "visual composition",
            "typography",
            "visual art",
            "design artifact",
            "print piece",
        ]
    ):
        score += 140.0

    if skill.folder == "pdf" and any(
        phrase in prompt_l
        for phrase in ["poster", "static design", "visual artwork", "visual composition", "typography-led"]
    ):
        score -= 120.0

    if skill.folder.lower() in prompt_l or folder_phrase in prompt_l:
        score += 18.0
    if skill.name.lower() in prompt_l or name_phrase in prompt_l:
        score += 16.0

    return round(score, 4)


def rank_skills(prompt: str, skills: list[Skill], profile_name: str, idf: dict[str, float]) -> list[dict[str, Any]]:
    profile = PROFILES[profile_name]
    ranked = []
    for skill in skills:
        vector = skill_vector(skill, profile)
        ranked.append(
            {
                "skill": skill.folder,
                "score": score_prompt(prompt, skill, vector, idf),
            }
        )
    ranked.sort(key=lambda item: (-item["score"], item["skill"]))
    return ranked


def evaluate(cases: list[dict[str, Any]], skills: list[Skill], ambiguity_ratio: float) -> dict[str, Any]:
    idf = build_idf(skills)
    results: list[dict[str, Any]] = []
    summary: dict[str, dict[str, int]] = {
        profile: {"total": 0, "top1": 0, "top3": 0, "blocked_top3": 0, "allowed_related_top3": 0}
        for profile in PROFILES
    }

    skill_names = {skill.folder for skill in skills}

    for case in cases:
        expected = case["expected_skill"]
        blocked_raw = set(case.get("blocked_skills", []))
        allowed_related = set(case.get("allowed_related_skills", []))
        blocked = blocked_raw - allowed_related
        if expected not in skill_names:
            results.append(
                {
                    "id": case.get("id", ""),
                    "expected_skill": expected,
                    "error": f"Expected skill '{expected}' is not in library/skills.",
                }
            )
            continue

        profile_results = {}
        for profile in PROFILES:
            ranked = rank_skills(case["prompt"], skills, profile, idf)
            top3 = ranked[:3]
            top1_hit = bool(top3 and top3[0]["skill"] == expected)
            top3_hit = any(item["skill"] == expected for item in top3)
            expected_score = next((item["score"] for item in top3 if item["skill"] == expected), 0.0)
            if not expected_score and top3:
                expected_score = top3[0]["score"]
            ambiguous_blocked = [
                item["skill"]
                for item in top3
                if item["skill"] in blocked and expected_score > 0 and item["score"] >= expected_score * ambiguity_ratio
            ]
            allowed_related_hits = [
                item["skill"]
                for item in top3
                if item["skill"] in allowed_related and expected_score > 0 and item["score"] >= expected_score * ambiguity_ratio
            ]
            blocked_hit = bool(ambiguous_blocked)

            summary[profile]["total"] += 1
            summary[profile]["top1"] += int(top1_hit)
            summary[profile]["top3"] += int(top3_hit)
            summary[profile]["blocked_top3"] += int(blocked_hit)
            summary[profile]["allowed_related_top3"] += int(bool(allowed_related_hits))

            profile_results[profile] = {
                "top1_hit": top1_hit,
                "top3_hit": top3_hit,
                "blocked_top3": sorted(ambiguous_blocked),
                "allowed_related_top3": sorted(allowed_related_hits),
                "top3": top3,
            }

        results.append(
            {
                "id": case.get("id", ""),
                "prompt": case["prompt"],
                "expected_skill": expected,
                "blocked_skills": sorted(blocked_raw),
                "allowed_related_skills": sorted(allowed_related),
                "profiles": profile_results,
            }
        )

    return {"summary": summary, "results": results}


def percent(numerator: int, denominator: int) -> str:
    if denominator == 0:
        return "0.0%"
    return f"{(100 * numerator / denominator):.1f}%"


def write_reports(evaluation: dict[str, Any], out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    json_path = out_dir / "trigger-test-results.json"
    md_path = out_dir / "TRIGGER_TEST_RESULTS.md"
    csv_path = out_dir / "trigger-test-results.csv"

    json_path.write_text(json.dumps(evaluation, ensure_ascii=False, indent=2), encoding="utf-8")

    rows = []
    for result in evaluation["results"]:
        if "error" in result:
            rows.append(
                {
                    "id": result["id"],
                    "expected_skill": result["expected_skill"],
                    "profile": "",
                    "top1": "",
                    "top3": "",
                    "blocked_top3": "",
                    "error": result["error"],
                }
            )
            continue
        for profile, profile_result in result["profiles"].items():
            rows.append(
                {
                    "id": result["id"],
                    "expected_skill": result["expected_skill"],
                    "profile": profile,
                    "top1": profile_result["top3"][0]["skill"] if profile_result["top3"] else "",
                    "top3": ", ".join(item["skill"] for item in profile_result["top3"]),
                    "blocked_top3": ", ".join(profile_result["blocked_top3"]),
                    "allowed_related_top3": ", ".join(profile_result.get("allowed_related_top3", [])),
                    "error": "",
                }
            )

    with csv_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "id",
                "expected_skill",
                "profile",
                "top1",
                "top3",
                "blocked_top3",
                "allowed_related_top3",
                "error",
            ],
        )
        writer.writeheader()
        writer.writerows(rows)

    lines: list[str] = []
    lines.append("# Trigger Test Results")
    lines.append("")
    lines.append("These tests use a conservative lexical router as a cross-platform proxy, not a vendor-internal model.")
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    lines.append("| Profile | Total | Top-1 | Top-3 | Blocked In Top-3 | Allowed Related In Top-3 |")
    lines.append("| --- | ---: | ---: | ---: | ---: | ---: |")
    for profile, stats in evaluation["summary"].items():
        total = stats["total"]
        lines.append(
            f"| {profile} | {total} | {percent(stats['top1'], total)} | {percent(stats['top3'], total)} | {stats['blocked_top3']} | {stats['allowed_related_top3']} |"
        )

    lines.append("")
    lines.append("## Failures")
    lines.append("")
    failure_count = 0
    ambiguity_count = 0
    for result in evaluation["results"]:
        if "error" in result:
            failure_count += 1
            lines.append(f"- `{result['id']}`: {result['error']}")
            continue
        bad_profiles = []
        warning_profiles = []
        for profile, profile_result in result["profiles"].items():
            if not profile_result["top1_hit"]:
                top3 = ", ".join(f"{item['skill']} ({item['score']})" for item in profile_result["top3"])
                bad_profiles.append(f"{profile}: top3=[{top3}]")
            elif profile_result["blocked_top3"]:
                top3 = ", ".join(f"{item['skill']} ({item['score']})" for item in profile_result["top3"])
                blocked = ", ".join(profile_result["blocked_top3"]) or "none"
                warning_profiles.append(f"{profile}: top3=[{top3}], ambiguous={blocked}")
        if bad_profiles:
            failure_count += 1
            lines.append(f"- `{result['id']}` expected `{result['expected_skill']}`")
            for item in bad_profiles:
                lines.append(f"  - {item}")
        if warning_profiles:
            ambiguity_count += 1
    if failure_count == 0:
        lines.append("No failures.")

    lines.append("")
    lines.append("## Ambiguity Warnings")
    lines.append("")
    if ambiguity_count == 0:
        lines.append("No high-similarity blocked candidates.")
    else:
        for result in evaluation["results"]:
            if "error" in result:
                continue
            warning_profiles = []
            for profile, profile_result in result["profiles"].items():
                if profile_result["top1_hit"] and profile_result["blocked_top3"]:
                    top3 = ", ".join(f"{item['skill']} ({item['score']})" for item in profile_result["top3"])
                    blocked = ", ".join(profile_result["blocked_top3"]) or "none"
                    warning_profiles.append(f"{profile}: top3=[{top3}], ambiguous={blocked}")
            if warning_profiles:
                lines.append(f"- `{result['id']}` expected `{result['expected_skill']}`")
                for item in warning_profiles:
                    lines.append(f"  - {item}")

    allowed_related_count = 0
    lines.append("")
    lines.append("## Allowed Related Candidates")
    lines.append("")
    for result in evaluation["results"]:
        if "error" in result:
            continue
        related_profiles = []
        for profile, profile_result in result["profiles"].items():
            related = profile_result.get("allowed_related_top3", [])
            if profile_result["top1_hit"] and related:
                top3 = ", ".join(f"{item['skill']} ({item['score']})" for item in profile_result["top3"])
                related_profiles.append(f"{profile}: top3=[{top3}], related={', '.join(related)}")
        if related_profiles:
            allowed_related_count += 1
            lines.append(f"- `{result['id']}` expected `{result['expected_skill']}`")
            for item in related_profiles:
                lines.append(f"  - {item}")
    if allowed_related_count == 0:
        lines.append("No allowed related candidates appeared near the expected skill.")
    else:
        lines.append("")
        lines.append("These are intentionally allowed as nearby top-3 candidates, but top-1 must still be the expected skill.")

    lines.append("")
    lines.append("## Files")
    lines.append("")
    lines.append("- JSON: `docs/trigger-test-results.json`")
    lines.append("- CSV: `docs/trigger-test-results.csv`")
    lines.append("- Eval set: `docs/trigger-evals.json`")

    md_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Run platform-neutral skill routing tests.")
    parser.add_argument("--evals", default="docs/trigger-evals.json", type=Path)
    parser.add_argument("--skills", default="library/skills", type=Path)
    parser.add_argument("--out-dir", default="docs", type=Path)
    parser.add_argument(
        "--ambiguity-ratio",
        default=0.55,
        type=float,
        help="Blocked skills only count as ambiguous when their score is at least this fraction of the expected score.",
    )
    args = parser.parse_args()

    skills = load_skills(args.skills)
    cases = load_evals(args.evals)
    evaluation = evaluate(cases, skills, args.ambiguity_ratio)
    write_reports(evaluation, args.out_dir)

    failed = 0
    ambiguous = 0
    allowed_related = 0
    for stats in evaluation["summary"].values():
        failed += stats["total"] - stats["top1"]
        ambiguous += stats["blocked_top3"]
        allowed_related += stats["allowed_related_top3"]

    print(f"Loaded skills: {len(skills)}")
    print(f"Loaded evals: {len(cases)}")
    for profile, stats in evaluation["summary"].items():
        total = stats["total"]
        print(
            f"{profile}: top1={percent(stats['top1'], total)} top3={percent(stats['top3'], total)} blocked_top3={stats['blocked_top3']} allowed_related_top3={stats['allowed_related_top3']}"
        )
    if ambiguous:
        print(f"Ambiguity warnings: {ambiguous}. See docs/TRIGGER_TEST_RESULTS.md")
    if allowed_related:
        print(f"Allowed related candidates: {allowed_related}. See docs/TRIGGER_TEST_RESULTS.md")
    if failed:
        print("Routing test completed with failures. See docs/TRIGGER_TEST_RESULTS.md")
        return 1
    print("Routing test passed for all profiles.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
