#!/bin/bash
set -e

# Script to fetch release information from GitHub API
# Usage: ./get-release-info.sh [release_tag]
# If no tag provided, fetches latest release

RELEASE_TAG="$1"

# Use latest release if no tag specified
if [ -z "$RELEASE_TAG" ]; then
  RELEASE_TAG=$(curl -s "https://api.github.com/repos/radius-project/radius/releases/latest" | jq -r '.tag_name')
fi

if [ -z "$RELEASE_TAG" ] || [ "$RELEASE_TAG" = "null" ]; then
  echo "Error: Could not determine release tag" >&2
  exit 1
fi

echo "Fetching release information for tag: $RELEASE_TAG" >&2

RELEASE_DATA=$(curl -s "https://api.github.com/repos/radius-project/radius/releases/tags/$RELEASE_TAG")

if [ "$(echo "$RELEASE_DATA" | jq -r '.message // empty')" = "Not Found" ]; then
  echo "Error: Release not found for tag: $RELEASE_TAG" >&2
  exit 1
fi

RELEASE_NAME=$(echo "$RELEASE_DATA" | jq -r '.name')
RELEASE_BODY=$(echo "$RELEASE_DATA" | jq -r '.body')
PUBLISHED_AT=$(echo "$RELEASE_DATA" | jq -r '.published_at')
HTML_URL=$(echo "$RELEASE_DATA" | jq -r '.html_url')

BLOG_DATE=$(date -d "$PUBLISHED_AT" "+%Y-%m-%dT%H:%M:%S%z" 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$PUBLISHED_AT" "+%Y-%m-%dT%H:%M:%S%z")
YEAR=$(date -d "$PUBLISHED_AT" "+%Y" 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$PUBLISHED_AT" "+%Y")

# Output release information for consumption by other scripts
echo "TAG_NAME=$RELEASE_TAG"
echo "RELEASE_NAME=$RELEASE_NAME"
echo "BLOG_DATE=$BLOG_DATE"
echo "YEAR=$YEAR"
echo "HTML_URL=$HTML_URL"

# Write release body to file for use by other scripts
echo "$RELEASE_BODY" > release_body.md
echo "Release body written to release_body.md" >&2