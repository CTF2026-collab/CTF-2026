# Challenge 3: Debug Endpoint Exposes Secrets

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


## Runtime Values

- `API_KEY=training-key-123`
- `DB_PASSWORD=fake-db-password`
- `VALIDATION_TOKEN=<copied from the unlock page after solving the unlock puzzle>`

## Validation Token Generation URL : http://54.144.85.14:5001/unlock-ui 
