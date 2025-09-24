#!/bin/bash
set -e

# Script to create pull request for auto-generated blog post
# Usage: ./create-pr.sh <release_tag> <github_token> [ai_success]

RELEASE_TAG="$1"
GITHUB_TOKEN="$2"
AI_SUCCESS="${3:-false}"

if [ -z "$RELEASE_TAG" ] || [ -z "$GITHUB_TOKEN" ]; then
  echo "Usage: $0 <release_tag> <github_token> [ai_success]" >&2
  exit 1
fi

# Set GitHub token for gh CLI
export GITHUB_TOKEN

echo "Creating pull request for Radius $RELEASE_TAG blog post..."

# Get release information
RELEASE_NAME="Radius $RELEASE_TAG"
RELEASE_URL="https://github.com/radius-project/radius/releases/tag/$RELEASE_TAG"

# Determine AI generation status
if [ "$AI_SUCCESS" = "true" ]; then
  AI_STATUS="✅ Yes"
else
  AI_STATUS="❌ No (fallback used)"
fi

# Create branch name
BRANCH_NAME="blog-post-$RELEASE_TAG"

# Stage and commit changes
git add .
git commit -m "Add blog post for $RELEASE_NAME

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to new branch
git push origin HEAD:$BRANCH_NAME

# Create pull request
gh pr create \
  --title "Add blog post for $RELEASE_NAME" \
  --body "Auto-generated blog post for **$RELEASE_NAME**

- **Tag:** $RELEASE_TAG
- **Release:** $RELEASE_URL
- **AI Generated:** $AI_STATUS

🤖 Generated automatically by GitHub Actions" \
  --base main \
  --head $BRANCH_NAME

echo "Pull request created successfully!"