#!/bin/bash

# Script to trigger blog post generation for Radius releases
# This script can be called from the main Radius repository when a new release is published

set -e

# Default values
OWNER="radius-project"
REPO="radius-project"
EVENT_TYPE="radius-release-published"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --tag)
      TAG_NAME="$2"
      shift 2
      ;;
    --owner)
      OWNER="$2"
      shift 2
      ;;
    --repo)
      REPO="$2"
      shift 2
      ;;
    --token)
      GITHUB_TOKEN="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --tag TAG_NAME       Release tag name (required)"
      echo "  --owner OWNER        Repository owner (default: radius-project)"
      echo "  --repo REPO          Repository name (default: radius-project)"
      echo "  --token TOKEN        GitHub personal access token (required)"
      echo "  --help               Show this help message"
      echo ""
      echo "Example:"
      echo "  $0 --tag v0.50.0 --token \$GITHUB_TOKEN"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Validate required parameters
if [ -z "$TAG_NAME" ]; then
  echo "Error: --tag parameter is required"
  echo "Use --help for usage information"
  exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: --token parameter is required"
  echo "Use --help for usage information"
  exit 1
fi

echo "Triggering blog post generation for release: $TAG_NAME"
echo "Repository: $OWNER/$REPO"

# Prepare the payload
PAYLOAD=$(cat <<EOF
{
  "event_type": "$EVENT_TYPE",
  "client_payload": {
    "tag_name": "$TAG_NAME",
    "repository": "radius-project/radius",
    "triggered_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  }
}
EOF
)

# Send repository dispatch event
RESPONSE=$(curl -s -w "%{http_code}" -o /tmp/dispatch_response.json \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$OWNER/$REPO/dispatches" \
  -d "$PAYLOAD")

HTTP_CODE="${RESPONSE: -3}"

if [ "$HTTP_CODE" -eq 204 ]; then
  echo "✅ Successfully triggered blog post generation workflow"
  echo "Check the Actions tab in the $OWNER/$REPO repository for workflow progress"
else
  echo "❌ Failed to trigger workflow. HTTP status code: $HTTP_CODE"
  echo "Response:"
  cat /tmp/dispatch_response.json
  exit 1
fi

# Clean up
rm -f /tmp/dispatch_response.json

echo ""
echo "Blog post generation has been triggered. The workflow will:"
echo "1. Fetch release information for $TAG_NAME"
echo "2. Generate a blog post with release highlights"
echo "3. Create a pull request with the new blog post"
echo ""
echo "You can monitor the progress at:"
echo "https://github.com/$OWNER/$REPO/actions"