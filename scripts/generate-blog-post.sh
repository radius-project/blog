#!/bin/bash
set -e

# Script to generate complete blog post from release tag
# Usage: ./generate-blog-post.sh <release_tag> <github_token>
# Outputs: Complete blog post in radblog/content/posts/

RELEASE_TAG="$1"
GITHUB_TOKEN="$2"

if [ -z "$RELEASE_TAG" ] || [ -z "$GITHUB_TOKEN" ]; then
  echo "Usage: $0 <release_tag> <github_token>" >&2
  exit 1
fi

# Use latest release if tag is empty
if [ "$RELEASE_TAG" = "" ]; then
  echo "Getting latest release..."
  RELEASE_TAG=$(curl -s "https://api.github.com/repos/radius-project/radius/releases/latest" | jq -r '.tag_name')
fi

echo "Generating blog post for Radius $RELEASE_TAG..."

# Cleanup temporary files on exit
trap 'rm -f prompt_template.md final_prompt.md temp_style_guide.txt temp_release_notes.txt release_body.md' EXIT

# =============================================================================
# PREPROCESSING: Gather data
# =============================================================================
echo "=== PREPROCESSING: Gathering data ==="

# Get release data
RELEASE_DATA=$(curl -s "https://api.github.com/repos/radius-project/radius/releases/tags/$RELEASE_TAG")
RELEASE_BODY=$(echo "$RELEASE_DATA" | jq -r '.body')
PUBLISHED_AT=$(echo "$RELEASE_DATA" | jq -r '.published_at')

# Load style guide
if [ -f "radblog/guide/contribution-guide.md" ]; then
  FORMATTING_RULES=$(awk '/## Writing Guidelines/,/## Formatting Standards/ { if (!/## Formatting Standards/) print } /## Formatting Standards/,/## Submission Process/ { if (!/## Submission Process/) print }' "radblog/guide/contribution-guide.md")
  STYLE_GUIDE=$(printf "CRITICAL FORMATTING REQUIREMENTS - THESE RULES ARE MANDATORY:\n%s\n\nCOMPLETE STYLE GUIDE:\n%s" "$FORMATTING_RULES" "$(cat "radblog/guide/contribution-guide.md")")
else
  STYLE_GUIDE="WRITING GUIDELINES: Conversational, user-focused, technical depth, no marketing language, evidence-based content only from release notes."
fi

# Build AI prompt
cp scripts/blog-prompt.md prompt_template.md
sed -i.bak "s/{RELEASE_NAME}/Radius $RELEASE_TAG/g" prompt_template.md && rm -f prompt_template.md.bak
sed -i.bak "s|{RELEASE_URL}|https://github.com/radius-project/radius/releases/tag/$RELEASE_TAG|g" prompt_template.md && rm -f prompt_template.md.bak

echo "$STYLE_GUIDE" > temp_style_guide.txt
echo "$RELEASE_BODY" > temp_release_notes.txt

awk '/{RELEASE_NOTES}/ { while ((getline line < "temp_release_notes.txt") > 0) { print line } close("temp_release_notes.txt"); next } /{STYLE_GUIDE}/ { while ((getline line < "temp_style_guide.txt") > 0) { print line } close("temp_style_guide.txt"); next } /{BLOG_CONTEXT}/ { print "Previous Radius blog posts focus on technical features and developer workflows."; next } { print }' prompt_template.md > final_prompt.md

# =============================================================================
# AI GENERATION: Generate content
# =============================================================================
echo "=== AI GENERATION: Calling GitHub Models API ==="

RESPONSE=$(curl -s -X POST "https://models.inference.ai.azure.com/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -d "{\"model\": \"gpt-4o\", \"messages\": [{\"role\": \"system\", \"content\": \"You are a technical content writer for cloud-native application platforms. You MUST follow all formatting rules and style guidelines exactly as specified. Failure to follow formatting rules is not acceptable.\"}, {\"role\": \"user\", \"content\": \"$(cat final_prompt.md | sed 's/"/\\"/g' | tr '\n' ' ')\"}], \"max_tokens\": 3500, \"temperature\": 0.2}")

# =============================================================================
# POST-PROCESSING: Create blog post
# =============================================================================
echo "=== POST-PROCESSING: Creating blog post ==="

if echo "$RESPONSE" | jq -e '.choices[0].message.content' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq -r '.choices[0].message.content' > ai_content.md

  # Apply style guide fixes
  sed -i.bak 's/\bapplications\b/Applications/g' ai_content.md && rm -f ai_content.md.bak
  sed -i.bak 's/\benvironments\b/Environments/g' ai_content.md && rm -f ai_content.md.bak
  sed -i.bak 's/\brecipes\b/Recipes/g' ai_content.md && rm -f ai_content.md.bak
  sed -i.bak 's/\bresource types\b/Resource Types/g' ai_content.md && rm -f ai_content.md.bak
  sed -i.bak 's/  */ /g' ai_content.md && rm -f ai_content.md.bak

  # Create blog directory
  YEAR=$(date -d "$PUBLISHED_AT" "+%Y" 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$PUBLISHED_AT" "+%Y")
  BLOG_DIR="radblog/content/posts/$YEAR/radius-$RELEASE_TAG-release"
  mkdir -p "$BLOG_DIR"

  # Create blog post with frontmatter
  BLOG_DATE=$(date -d "$PUBLISHED_AT" "+%Y-%m-%dT%H:%M:%S%z" 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$PUBLISHED_AT" "+%Y-%m-%dT%H:%M:%S%z")

  cat > "$BLOG_DIR/index.md" << EOF
---
date: "$BLOG_DATE"
title: "Announcing Radius $RELEASE_TAG"
linkTitle: "Radius $RELEASE_TAG"
author: "Radius Team"
type: blog
---

EOF

  cat ai_content.md >> "$BLOG_DIR/index.md"
  rm ai_content.md

  echo "Blog post created successfully at: $BLOG_DIR/index.md"
  echo "AI_SUCCESS=true"
else
  echo "AI generation failed, using fallback content"

  # Create blog directory
  YEAR=$(date +%Y)
  BLOG_DIR="radblog/content/posts/$YEAR/radius-$RELEASE_TAG-release"
  mkdir -p "$BLOG_DIR"

  cat > "$BLOG_DIR/index.md" << EOF
---
date: "$(date -u +%Y-%m-%dT%H:%M:%S%z)"
title: "Announcing Radius $RELEASE_TAG"
linkTitle: "Radius $RELEASE_TAG"
author: "Radius Team"
type: blog
---

We're excited to announce the release of Radius $RELEASE_TAG!

For detailed information about this release, see the [release notes](https://github.com/radius-project/radius/releases/tag/$RELEASE_TAG).

## Learn More and Get Involved

We would love for you to join us to help build Radius:

- Try the [Radius Tutorial](https://docs.radapp.io/tutorials/new-app/)
- Checkout the Radius roadmap and influence future features at [https://aka.ms/radius-roadmap](https://aka.ms/radius-roadmap)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos
EOF

  echo "Blog post created with fallback content at: $BLOG_DIR/index.md"
  echo "AI_SUCCESS=false"
fi