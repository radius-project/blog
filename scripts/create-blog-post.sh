#!/bin/bash
set -e

# Script to create blog post with Hugo frontmatter
# Usage: ./create-blog-post.sh <release_tag> [ai_content_file]

RELEASE_TAG="$1"
AI_CONTENT_FILE="${2:-ai_content.md}"

if [ -z "$RELEASE_TAG" ]; then
  echo "Usage: $0 <release_tag> [ai_content_file]" >&2
  exit 1
fi

# Create blog directory
YEAR=$(date +%Y)
BLOG_DIR="radblog/content/posts/$YEAR/radius-$RELEASE_TAG-release"
mkdir -p "$BLOG_DIR"

# Create blog post with frontmatter
cat > "$BLOG_DIR/index.md" << EOF
---
date: "$(date -u +%Y-%m-%dT%H:%M:%S%z)"
title: "Announcing Radius $RELEASE_TAG"
linkTitle: "Radius $RELEASE_TAG"
author: "Radius Team"
type: blog
---

EOF

# Add content
if [ -f "$AI_CONTENT_FILE" ]; then
  cat "$AI_CONTENT_FILE" >> "$BLOG_DIR/index.md"
else
  echo "We're excited to announce the release of Radius $RELEASE_TAG!" >> "$BLOG_DIR/index.md"
fi

echo "Blog post created at: $BLOG_DIR/index.md"