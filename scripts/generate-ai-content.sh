#!/bin/bash
set -e

# Script to generate AI blog content using GitHub Models API
# Usage: ./generate-ai-content.sh <release_tag> [github_token]
# Outputs: ai_content.md file

RELEASE_TAG="$1"
GITHUB_TOKEN="$2"

if [ -z "$RELEASE_TAG" ]; then
  echo "Usage: $0 <release_tag> [github_token]" >&2
  exit 1
fi

# Cleanup temporary files on exit (success or failure)
trap 'rm -f prompt_template.md final_prompt.md temp_style_guide.txt temp_release_notes.txt' EXIT

# =============================================================================
# PREPROCESSING: Gather all data needed for AI generation
# =============================================================================
echo "=== PREPROCESSING: Gathering data ==="

# Get release notes from GitHub API
echo "Fetching release notes for $RELEASE_TAG..."
RELEASE_BODY=$(curl -s "https://api.github.com/repos/radius-project/radius/releases/tags/$RELEASE_TAG" | jq -r '.body')

# Prepare enhanced style guide with critical rules extraction
echo "Loading and processing style guide..."
if [ -f "radblog/guide/contribution-guide.md" ]; then
  # Extract key formatting sections dynamically
  FORMATTING_RULES=$(awk '
  /## Writing Guidelines/,/## Formatting Standards/ {
    if (!/## Formatting Standards/) print
  }
  /## Formatting Standards/,/## Submission Process/ {
    if (!/## Submission Process/) print
  }
  ' "radblog/guide/contribution-guide.md")

  echo "=== EXTRACTED FORMATTING RULES ==="
  echo "$FORMATTING_RULES"
  echo "=== END FORMATTING RULES ==="

  # Combine critical rules with full style guide
  STYLE_GUIDE=$(printf "CRITICAL FORMATTING REQUIREMENTS - THESE RULES ARE MANDATORY:\n%s\n\nCOMPLETE STYLE GUIDE:\n%s" "$FORMATTING_RULES" "$(cat "radblog/guide/contribution-guide.md")")
else
  STYLE_GUIDE="WRITING GUIDELINES: Conversational, user-focused, technical depth, no marketing language, evidence-based content only from release notes."
fi

# Build enhanced prompt using template
echo "Building AI prompt from template..."
cp scripts/blog-prompt.md prompt_template.md

# Replace placeholders with actual content
sed -i '' "s/{RELEASE_NAME}/Radius $RELEASE_TAG/g" prompt_template.md
sed -i '' "s|{RELEASE_URL}|https://github.com/radius-project/radius/releases/tag/$RELEASE_TAG|g" prompt_template.md

# Write style guide and release notes to temp files for awk processing
echo "$STYLE_GUIDE" > temp_style_guide.txt
echo "$RELEASE_BODY" > temp_release_notes.txt

# Insert content using awk with file reading instead of variables
awk '
/{RELEASE_NOTES}/ {
    while ((getline line < "temp_release_notes.txt") > 0) {
        print line
    }
    close("temp_release_notes.txt")
    next
}
/{STYLE_GUIDE}/ {
    while ((getline line < "temp_style_guide.txt") > 0) {
        print line
    }
    close("temp_style_guide.txt")
    next
}
/{BLOG_CONTEXT}/ {
    print "Previous Radius blog posts focus on technical features and developer workflows."
    next
}
{ print }
' prompt_template.md > final_prompt.md

FINAL_PROMPT=$(cat final_prompt.md)

# =============================================================================
# AI GENERATION: Call GitHub Models API
# =============================================================================
echo "=== AI GENERATION: Calling GitHub Models API ==="

RESPONSE=$(curl -s -X POST "https://models.inference.ai.azure.com/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -d "{
    \"model\": \"gpt-4o\",
    \"messages\": [
      {\"role\": \"system\", \"content\": \"You are a technical content writer for cloud-native application platforms. You MUST follow all formatting rules and style guidelines exactly as specified. Failure to follow formatting rules is not acceptable.\"},
      {\"role\": \"user\", \"content\": \"$(echo "$FINAL_PROMPT" | sed 's/"/\\"/g' | tr '\n' ' ')\"}
    ],
    \"max_tokens\": 3500,
    \"temperature\": 0.2
  }")

# =============================================================================
# POST-PROCESSING: Apply style guide compliance
# =============================================================================
echo "=== POST-PROCESSING: Applying style guide ==="

if echo "$RESPONSE" | jq -e '.choices[0].message.content' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq -r '.choices[0].message.content' > ai_content.md

  # Apply style guide rules that AI typically ignores
  echo "Fixing capitalization and formatting..."

  # Capitalize Radius entities
  sed -i '' 's/\bapplications\b/Applications/g' ai_content.md
  sed -i '' 's/\benvironments\b/Environments/g' ai_content.md
  sed -i '' 's/\brecipes\b/Recipes/g' ai_content.md
  sed -i '' 's/\bresource types\b/Resource Types/g' ai_content.md
  sed -i '' 's/\bcontainers\b/Containers/g' ai_content.md
  sed -i '' 's/\bsecrets\b/Secrets/g' ai_content.md
  sed -i '' 's/\broutes\b/Routes/g' ai_content.md
  sed -i '' 's/\bgateways\b/Gateways/g' ai_content.md

  # Clean up formatting
  sed -i '' 's/  */ /g' ai_content.md
  sed -i '' '/^$/N;/^\n$/d' ai_content.md

  echo "AI content generation successful"
else
  echo "AI content generation failed" >&2
  exit 1
fi

# Temporary files will be cleaned up automatically by the EXIT trap