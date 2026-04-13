# Challenge 1: Hardcoded API Key in Source Code

## Story

A developer hardcoded an API key into the application source to finish a demo
quickly. The app still runs, but the secret is embedded directly in code and the
remote validator rejects the demo key.

## Goal

Fix the application so it no longer stores the API key in code and instead uses
secure runtime configuration.

## Files

- `app/app.py`: vulnerable client application
- `.env.example`: sample runtime variables
- `verify.sh`: checks whether the challenge is solved
- `reset.sh`: restores the original vulnerable version

## What You Need To Do

1. Inspect `app/app.py`
2. Identify the hardcoded secret pattern
3. Replace it with an environment variable lookup
4. Open `http://54.144.85.14:5000/unlock-ui` in a browser and click `Unlock Validation`
5. Copy the validation token shown in the page
6. Run `./verify.sh` with both runtime variables set

## Runtime Values

- `API_KEY=training-key-123`
- `VALIDATION_TOKEN=<copied from the unlock page>`
