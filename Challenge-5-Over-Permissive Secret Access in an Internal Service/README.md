# Challenge 5: Over-Permissive Secret Access in an Internal Service

## Story

An internal deployment helper service retrieves secrets from a central secret
broker before starting a release. The service works, but it requests a broader
set of secrets than it actually needs. In a real environment, this would create
unnecessary blast radius if the service were compromised.

## Goal

Review the service logic and fix it so the service retrieves only the minimum
required secret and forwards only the minimum required secret downstream.

## Files

- `app.py`: vulnerable service flow
- `.env.example`: sample runtime variables
- `verify.sh`: checks whether the challenge is solved
- `reset.sh`: restores the original vulnerable version
- 

## Runtime Values

- `VALIDATION_TOKEN=<copied from the unlock page after solving the unlock puzzle>`

## Validation Token Generation URL : http://54.144.85.14:5002/unlock-ui
