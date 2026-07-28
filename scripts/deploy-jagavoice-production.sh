#!/usr/bin/env bash
# Deploy Jaga Voice Agent Control UI files on the gateway host.
# Run on the server after: git pull origin main

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${OPENCLAW_UI_ROOT:-/usr/lib/node_modules/openclaw/dist/control-ui}"

echo "Deploying from: $REPO_ROOT/dist/control-ui"
echo "Deploying to:   $TARGET"

install -d "$TARGET/assets"
install -m 0644 "$REPO_ROOT/dist/control-ui/index.html" "$TARGET/index.html"
install -m 0644 "$REPO_ROOT/dist/control-ui/sw.js" "$TARGET/sw.js"
install -m 0644 "$REPO_ROOT/dist/control-ui/assets/jagavoice-kiosk.css" "$TARGET/assets/jagavoice-kiosk.css"
install -m 0644 "$REPO_ROOT/dist/control-ui/assets/index-Bvtt7vVx.js" "$TARGET/assets/index-Bvtt7vVx.js"
install -m 0644 "$REPO_ROOT/dist/control-ui/assets/app-route-paths-Ckh-KQjG.js" "$TARGET/assets/app-route-paths-Ckh-KQjG.js"

echo "Restarting gateway..."
systemctl --user restart openclaw-gateway.service

echo "Done. Test: https://openclaw.jagavision.com/jagavoiceagent#token=YOUR_TOKEN"
