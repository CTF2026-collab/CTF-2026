#!/bin/bash
set -euo pipefail

challenge_dir="$(cd "$(dirname "$0")" && pwd)"
app_file="$challenge_dir/app.py"

if [[ -z "${VALIDATION_TOKEN:-}" ]]; then
  echo "Fail: VALIDATION_TOKEN is missing. Open http://54.144.85.14:5001/unlock-ui and complete the unlock flow first."
  exit 1
fi

output="$(API_KEY=training-key-123 DB_PASSWORD=fake-db-password VALIDATION_TOKEN="$VALIDATION_TOKEN" python3 "$app_file" 2>&1 || true)"

if [[ "$output" == *"FLAG{"* ]]; then
  echo "$output"
  exit 0
fi

echo "Fail: validator did not return the flag"
echo "$output"
exit 1
