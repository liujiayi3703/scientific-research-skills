# Skill Trigger Audit

Generated: 2026-06-21 11:45:23

## Summary

- Total standard skills: 66
- Clean descriptions: 66
- Descriptions needing review: 0
- Raw CSV: docs/trigger-audit.csv

## What The Checks Mean

- mojibake-or-garbled-text: Chinese or punctuation appears corrupted, which can hurt matching.
- too-long: description is over 500 characters; it may dilute trigger signals.
- too-long-critical: description is over 900 characters and should be shortened soon.
- process-summary-risk: description may summarize workflow instead of only trigger conditions.
- provider-specific-wording: wording mentions a provider in a skill that should probably be app-neutral.
- weak-opening: description does not start with a clear trigger phrase.
- too-short: description may not include enough trigger keywords.

## Priority Fixes

No trigger description issues found.

## Clean Descriptions

- academic-research-suite
- algorithmic-art
- babysit
- brand-guidelines
- canvas-design
- claude-api
- do
- doc-coauthoring
- docx
- frontend-design
- how-it-works
- internal-comms
- knowledge-agent
- learn-codebase
- make-plan
- mama
- mcp-builder
- mem-search
- nanobanana
- nsfc-grant-writing
- openclaw
- p10
- p7
- p9
- pathfinder
- pdf
- pptx
- pro
- pua
- pua-cancel-loop
- pua-en
- pua-flavor
- pua-ja
- pua-kpi
- pua-loop
- pua-mama
- pua-off
- pua-offline
- pua-on
- pua-p10
- pua-p7
- pua-p9
- pua-pro
- pua-reap-orphans
- pua-survey
- pua-team-status
- pua-teardown-all
- pua-yes
- research-idea-and-battle
- scansci-pdf
- sci-figure
- shared-skill-installer
- shot
- skill-creator
- slack-gif-creator
- smart-explore
- theme-factory
- timeline-report
- version-bump
- web-access-main
- webapp-testing
- web-artifacts-builder
- wowerpoint
- xgboost-lightgbm
- xlsx
- yes

## Recommended Next Pass

1. Fix mojibake-or-garbled-text first because corrupted text directly damages trigger matching.
2. Shorten too-long-critical descriptions to clear trigger conditions.
3. Resolve overlaps among similarly named workflow skills only after the text is readable.
4. Re-run tools/Audit-SkillTriggers.ps1, then tools/Audit-Skills.ps1.
