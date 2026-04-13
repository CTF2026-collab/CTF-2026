#!/bin/bash
set -euo pipefail

challenge_dir="$(cd "$(dirname "$0")" && pwd)"
app_file="$challenge_dir/app/app.py"

if [[ -z "${VALIDATION_TOKEN:-}" ]]; then
  echo "Fail: VALIDATION_TOKEN is missing. Open http://54.144.85.14:5000/unlock-ui and unlock validation first."
  exit 1
fi

if grep -q 'super-secret-demo-key' "$app_file"; then
  echo "Fail: the hardcoded secret is still present in app/app.py"
  exit 1
fi

if ! grep -q 'os.environ.get("API_KEY")' "$app_file" && ! grep -q "os.getenv(\"API_KEY\")" "$app_file"; then
  echo "Fail: app/app.py must read the secret from the API_KEY environment variable"
  exit 1
fi

output="$(API_KEY=training-key-123 VALIDATION_TOKEN="$VALIDATION_TOKEN" python3 "$app_file" 2>&1 || true)"

if [[ "$output" == *"FLAG{"* ]]; then
  echo "$output"
  exit 0
fi

echo "Fail: validator did not return the flag"
echo "$output"
exit 1
