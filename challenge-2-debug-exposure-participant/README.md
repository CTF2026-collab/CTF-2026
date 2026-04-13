# Challenge 2: Debug Endpoint Exposes Secrets

## Story

A troubleshooting feature was added during an incident. The application now
exposes configuration data to help engineers debug problems, but sensitive
values are being returned as well.

## Goal

Fix the application so the debug output no longer exposes secrets.

## Files

- `app.py`: vulnerable application
- `.env.example`: sample runtime variables
- `verify.sh`: checks whether the challenge is solved
- `reset.sh`: restores the original vulnerable version

## What You Need To Do

1. Inspect `app.py`
2. Find the function responsible for returning debug configuration
3. Prevent sensitive values from being exposed
4. Keep non-sensitive values visible
5. Open `http://54.144.85.14:5001/unlock-ui` in a browser
6. Identify the ring marked `live`
7. Type that ring name into the page and submit it
8. Copy the validation token shown in the page
9. Run `./verify.sh` with the runtime values and copied token

## Runtime Values

- `API_KEY=training-key-123`
- `DB_PASSWORD=fake-db-password`
- `VALIDATION_TOKEN=<copied from the unlock page after solving the unlock puzzle>`
