#!/usr/bin/env bash
# Deploy Jaga Voice Agent Control UI files on the gateway host.
# Run on the server after: git pull origin main

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE="${REPO_ROOT}/dist/control-ui"
TARGET="${OPENCLAW_UI_ROOT:-/usr/lib/node_modules/openclaw/dist/control-ui}"

echo "Deploying from: $SOURCE"
echo "Deploying to:   $TARGET"

install -d "$TARGET/assets"

SRC_ROOT="$(cd "$SOURCE" && pwd -P)"
DST_ROOT="$(cd "$TARGET" && pwd -P)"

if [ "$SRC_ROOT" = "$DST_ROOT" ]; then
  echo "Source and target are the same directory; skipping file copy."
  echo "Ensure you already ran: git pull origin main"
else
  install -m 0644 "$SOURCE/index.html" "$TARGET/index.html"
  install -m 0644 "$SOURCE/sw.js" "$TARGET/sw.js"
  install -m 0644 "$SOURCE/assets/jagavoice-kiosk.css" "$TARGET/assets/jagavoice-kiosk.css"
  install -m 0644 "$SOURCE/assets/index-Bvtt7vVx.js" "$TARGET/assets/index-Bvtt7vVx.js"
  install -m 0644 "$SOURCE/assets/app-route-paths-Ckh-KQjG.js" "$TARGET/assets/app-route-paths-Ckh-KQjG.js"
fi

if ! grep -q "jagavoice-20260728b" "$TARGET/index.html"; then
  echo "ERROR: $TARGET/index.html does not contain the jagavoice cache-bust marker."
  echo "Run: git pull origin main"
  exit 1
fi

echo "Restarting gateway..."
systemctl --user restart openclaw-gateway.service

echo "Done. Test: https://openclaw.jagavision.com/jagavoiceagent#token=YOUR_TOKEN"
