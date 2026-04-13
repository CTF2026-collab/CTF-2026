#!/bin/bash
set -euo pipefail

challenge_dir="$(cd "$(dirname "$0")" && pwd)"
app_file="$challenge_dir/app.py"

cat > "$app_file" <<'EOF'
import json
import os
import urllib.error
import urllib.request


START_URL = "http://54.144.85.14:5002/start"
VALIDATOR_URL = "http://54.144.85.14:5002/validate"

SERVICE_IDENTITY = "deploy-platform"
REQUESTED_SECRETS = [
    "billing_release_token",
    "db_admin_password",
    "signing_key",
]


def fetch_secrets_from_broker(service_identity: str, requested_secrets: list[str]) -> dict:
    secret_catalog = {
        "billing_release_token": "brt-prod-731",
        "db_admin_password": "db-admin-prod!",
        "signing_key": "signing-key-prod-2026",
    }
    return {name: secret_catalog[name] for name in requested_secrets if name in secret_catalog}


def build_deployment_payload(broker_response: dict) -> dict:
    return {
        "release_id": "rel-billing-731",
        "environment": "prod",
        "secrets": broker_response,
    }


def fetch_nonce() -> str:
    with urllib.request.urlopen(START_URL, timeout=5) as response:
        data = json.loads(response.read().decode("utf-8"))
        return data["nonce"]


def main() -> int:
    validation_token = os.environ.get("VALIDATION_TOKEN")
    if not validation_token:
        print("Missing VALIDATION_TOKEN. Open http://54.144.85.14:5002/unlock-ui.")
        return 1

    broker_response = fetch_secrets_from_broker(SERVICE_IDENTITY, REQUESTED_SECRETS)
    deployment_payload = build_deployment_payload(broker_response)

    payload = {
        "service_identity": SERVICE_IDENTITY,
        "requested_secrets": REQUESTED_SECRETS,
        "broker_response_keys": sorted(list(broker_response.keys())),
        "deployment_payload": deployment_payload,
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

echo "Challenge 3 reset complete."
