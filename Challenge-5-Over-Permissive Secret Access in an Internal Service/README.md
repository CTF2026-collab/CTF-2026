# Challenge 3: Over-Permissive Secret Access in an Internal Service

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

## What You Need To Do

1. Inspect `app.py`
2. Identify how the service defines its identity
3. Review which secrets the service is requesting
4. Check what secret material is being forwarded downstream
5. Fix the flow so it follows least privilege end to end
6. Open `http://54.144.85.14:5002/unlock-ui` in a browser
7. Click the ring marked `live`
8. Click the ring marked `standby`
9. Complete the CAPTCHA on the page
10. Keep the second ring name in the input and submit it
11. Copy the validation token shown in the page
12. Run `./verify.sh` with the copied token

## Runtime Values

- `VALIDATION_TOKEN=<copied from the unlock page after solving the unlock puzzle>`
