# Copilot Agent Instructions for Monthly Community Updates

## Your Task

When assigned an issue with the "Monthly Community Update" template, generate a blog post summarizing activity across **all public repositories** in the `radius-project` GitHub organization for the specified month.

## Data Collection

Use the `gh` CLI to gather the following data for the specified date range:

### 1. Releases
```bash
gh api "/orgs/radius-project/repos?per_page=100&type=public" --jq '.[].name' | while read repo; do
  gh release list --repo "radius-project/$repo" --limit 10 | grep -i "<month>"
done
```

### 2. Merged Pull Requests
```bash
gh search prs --org radius-project --merged-at "START_DATE..END_DATE" --limit 50 --json title,number,repository,author,url
```

### 3. New Issues
```bash
gh search issues --org radius-project --created "START_DATE..END_DATE" --limit 50 --json title,number,repository,author,url
```

### 4. Contributors
Extract unique authors from the merged PRs above.

## Blog Post Structure

Create the post at: `radblog/content/posts/<YEAR>/monthly-update-<month>/index.md`

### Frontmatter
```yaml
---
date: "<last-day-of-month>T07:00:00-07:00"
title: "Radius Monthly Update: <Month> <Year>"
linkTitle: "<Month> <Year> Update"
author: "Radius Team"
type: blog
---
```

### Content Structure
1. **Opening paragraph** (no heading) — summarize the month's highlights in 2-3 sentences
2. **## Releases** — list any new releases with version, repo, and key changes
3. **## Highlights** — curate 5-10 most impactful merged PRs grouped by theme (features, fixes, docs). Don't list every PR.
4. **## Community** — new contributors, issue activity, notable discussions
5. **## Get Involved** — use this exact section:

```markdown
## Get Involved

We would love for you to join us to help build Radius:

- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/)
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
```

## Style Guide

Follow the contribution guide at `radblog/guide/contribution-guide.md`. Key rules:
- Conversational and friendly tone, user-focused ("you" not "we")
- Active voice, present tense
- No promotional language or superlatives
- Capitalize Radius proper nouns: Applications, Environments, Recipes, Resource Types, Containers, Secrets, Routes, Gateways, Resource Groups
- 800-1000 words target length
- American English spelling
- Evidence-based — only include information from actual GitHub data

## Critical Rules
- **ONLY** include information gathered from the GitHub API — never make up PRs, issues, or contributors
- **DO NOT** speculate about future plans
- **DO NOT** include code snippets unless they are directly from a release or PR
- If a section has no data, omit it
- Verify all PR numbers, issue numbers, and usernames are real
