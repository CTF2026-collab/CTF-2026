#!/bin/bash
set -euo pipefail

challenge_dir="$(cd "$(dirname "$0")" && pwd)"
app_file="$challenge_dir/app/app.py"

cat > "$app_file" <<'EOF'
import json
import os
import sys
import urllib.error
import urllib.request


START_URL = "http://54.144.85.14:5000/start"
VALIDATOR_URL = "http://54.144.85.14:5000/validate"

CONFIG = {
    "service_name": "billing-sync",
    "api_key": "super-secret-demo-key",
    "validation_token": os.environ.get("VALIDATION_TOKEN"),
}


def fetch_nonce() -> str:
    with urllib.request.urlopen(START_URL, timeout=5) as response:
        data = json.loads(response.read().decode("utf-8"))
        return data["nonce"]


def validate() -> int:
    if not CONFIG["validation_token"]:
        print(
            "Missing validation token. Open http://54.144.85.14:5000/unlock-ui and copy the token.",
            file=sys.stderr,
        )
        return 1

    payload = {
        "api_key": CONFIG["api_key"],
        "unlock_token": CONFIG["validation_token"],
        "nonce": fetch_nonce(),
    }

    request = urllib.request.Request(
        VALIDATOR_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=5) as response:
            print(response.read().decode("utf-8"))
            return 0
    except urllib.error.HTTPError as exc:
        print(exc.read().decode("utf-8"), file=sys.stderr)
        return 1
    except urllib.error.URLError as exc:
        print(f"Could not reach validator: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(validate())
EOF

echo "Challenge 1 reset complete."
