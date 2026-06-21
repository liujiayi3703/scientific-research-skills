---
name: nanobanana
description: Use when the user mentions Nano Banana, nanobanana, AI image editing, image generation, prompt-to-image iteration, image-to-image refinement, product mockups, visual concept generation, or local Nano Banana plugin assets.
---

# Nano Banana

## Purpose

Use this skill as the local entry point for Nano Banana-style image generation and image editing workflows. It is intentionally lightweight because the bundled `references/` and `scripts/` directories are currently placeholders.

## When To Use

- The user asks to create, edit, or iterate images with Nano Banana or a similar image model.
- The user wants prompts for product shots, character consistency, visual concepts, thumbnails, posters, or ad creatives.
- The user wants to organize or extend the local Nano Banana plugin materials in this folder.

## Workflow

1. Clarify the target output: image type, subject, style, aspect ratio, and whether an input image is involved.
2. If the user provides an image, inspect it before proposing edits.
3. Produce a concise image prompt with subject, composition, lighting, material, background, and constraints.
4. For edits, describe only the intended changes and preserve the user's requested unchanged elements.
5. If this local folder later gains scripts or references, read only the files relevant to the requested workflow.

## Prompt Template

```text
Subject:
Scene/composition:
Style/reference direction:
Lighting/color:
Camera/framing:
Must preserve:
Must avoid:
Output format/aspect ratio:
```

## Local Resources

- `.claude-plugin/`: plugin metadata if later restored.
- `references/`: place prompt guides, style guides, or model notes here.
- `scripts/`: place repeatable prompt or asset utilities here.

## Guardrails

- Do not claim a model-specific capability unless it is verified in the active tool or app.
- Do not invent missing local scripts or references.
- If the user needs an actual generated image, use the available image generation tool or the app-specific image workflow.
