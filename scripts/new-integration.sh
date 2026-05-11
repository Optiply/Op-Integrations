#!/usr/bin/env bash
# Usage: ./scripts/new-integration.sh "Shopify" "E-commerce" "OAuth2" "https://shopify.dev/docs/api"
# Creates repo-local tap, target, ETL, and docs scaffolds.
# Optional: set OP_INTEGRATIONS_VAULT=/path/to/vault to also create a vault project page.

set -euo pipefail

NAME="${1:-}"
TYPE="${2:-E-commerce}"   # E-commerce / ERP / WMS / Marketplace / Data
AUTH="${3:-API Key}"       # OAuth2 / API Key / Basic / Other
API_DOCS="${4:-}"

if [ -z "$NAME" ]; then
  echo "Usage: $0 <IntegrationName> [Type] [AuthMethod] [APIDocsURL]"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
SLUG=$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
VAULT="${OP_INTEGRATIONS_VAULT:-}"
DATE=$(date +%Y-%m-%d)

echo "🔌 Creating integration: $NAME ($SLUG)"

# 1. Optional vault — Integration project page
if [ -n "$VAULT" ]; then
mkdir -p "$VAULT/Projects/Integrations"
cat > "$VAULT/Projects/Integrations/$NAME.md" << EOF
---
tags: [integration, project]
integration: $NAME
type: $TYPE
auth: $AUTH
status: 🔵 Research
updated: $DATE
---

# $NAME Integration

## Overview
| Field | Value |
|-------|-------|
| Platform | $NAME |
| Type | $TYPE |
| Auth | $AUTH |
| API Docs | $API_DOCS |
| Base URL | |
| Rate Limits | |
| Pagination | |

## API Endpoints Used
| Endpoint | Method | Purpose | Replication |
|----------|--------|---------|-------------|
| | | | INCREMENTAL / FULL_TABLE |

## Tap Status
- [ ] Tap code complete
- [ ] \`pip install -e .\` succeeds
- [ ] \`--discover\` produces valid catalog
- [ ] Incremental sync works
- [ ] Error handling (401, 429, 5xx)
- [ ] Committed to repo

## Target Status
- [ ] Target code complete
- [ ] Import test passes
- [ ] Write operations verified
- [ ] Committed to repo

## ETL Status
- [ ] ETL notebook complete
- [ ] Entity mappings verified
- [ ] Snapshot diff logic working
- [ ] Summary cell present

## Docs Status
- [ ] Setup guide written
- [ ] Troubleshooting guide written
- [ ] KB chunks ingested

## Known Issues
- None yet

## Notes
EOF
fi

# 2. Repo — Tap scaffold
TAP_DIR="$REPO/taps/tap-$SLUG/tap_${SLUG//-/_}"
mkdir -p "$TAP_DIR"
touch "$TAP_DIR/__init__.py"
cat > "$TAP_DIR/tap.py" << EOF
"""$NAME tap."""
# TODO: Implement tap
EOF
cat > "$TAP_DIR/streams.py" << EOF
"""$NAME streams."""
# TODO: Implement streams
EOF
cat > "$REPO/taps/tap-$SLUG/config.json.example" << EOF
{
  "api_key": "example-token",
  "start_date": "2024-01-01T00:00:00Z"
}
EOF
cat > "$REPO/taps/tap-$SLUG/README.md" << EOF
# tap-$SLUG

Singer tap for $NAME.

## Streams

- TODO

## Config

Copy \`config.json.example\` to \`config.json\` locally and fill credentials outside Git.

## Smoke

\`\`\`bash
pip install -e .
tap-$SLUG --config config.json --discover
\`\`\`
EOF

# 3. Repo — Target scaffold
TARGET_DIR="$REPO/targets/target-$SLUG/target_${SLUG//-/_}"
mkdir -p "$TARGET_DIR"
touch "$TARGET_DIR/__init__.py"
cat > "$TARGET_DIR/target.py" << EOF
"""$NAME target."""
# TODO: Implement target
EOF
cat > "$REPO/targets/target-$SLUG/config.json.example" << EOF
{
  "api_key": "example-token"
}
EOF
cat > "$REPO/targets/target-$SLUG/README.md" << EOF
# target-$SLUG

Singer target for $NAME.

## Write semantics

- TODO: create/update/upsert behavior
- TODO: delete handling
- TODO: retry/idempotency behavior

## Config

Copy \`config.json.example\` to \`config.json\` locally and fill credentials outside Git.
EOF

# 4. Repo — ETL scaffold
mkdir -p "$REPO/etl/$SLUG"
cat > "$REPO/etl/$SLUG/etl_${SLUG//-/_}.py" << EOF
"""$NAME ETL notebook."""
# TODO: Implement ETL transform
EOF

# 5. Repo — Docs scaffold
mkdir -p "$REPO/docs/$SLUG"
cat > "$REPO/docs/$SLUG/setup.md" << EOF
# $NAME — Setup Guide

## Prerequisites
-

## Configuration
-

## First Sync
-
EOF
cat > "$REPO/docs/$SLUG/troubleshooting.md" << EOF
# $NAME — Troubleshooting

## Common Issues

### Issue:
**Symptoms:**
**Cause:**
**Fix:**
EOF
cat > "$REPO/docs/$SLUG/data-mapping.md" << EOF
# $NAME — Optiply Data Mapping

| Source entity | Source field | Optiply entity | Optiply field | Notes |
|---|---|---|---|---|
| TODO | TODO | TODO | TODO | TODO |
EOF

echo "✅ Created:"
if [ -n "$VAULT" ]; then
  echo "   Vault:  $VAULT/Projects/Integrations/$NAME.md"
else
  echo "   Vault:  skipped (set OP_INTEGRATIONS_VAULT to enable)"
fi
echo "   Tap:    $REPO/taps/tap-$SLUG/"
echo "   Target: $REPO/targets/target-$SLUG/"
echo "   ETL:    $REPO/etl/$SLUG/"
echo "   Docs:   $REPO/docs/$SLUG/"
echo ""
echo "Next: research API → fill vault page → build tap → build target → build ETL → ingest docs"
