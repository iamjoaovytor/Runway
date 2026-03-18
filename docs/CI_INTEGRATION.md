# CI Integration

Runway includes a GitHub Actions workflow out of the box. This guide covers setup and customization.

## GitHub Actions

### Required Secrets

Add these in your repo's Settings > Secrets and variables > Actions:

| Secret | Description |
|--------|-------------|
| `APP_IDENTIFIER` | Your app's bundle ID |
| `APPLE_ID` | Apple Developer email |
| `TEAM_ID` | Apple Developer Team ID |
| `ITC_TEAM_ID` | App Store Connect Team ID |
| `MATCH_GIT_URL` | Match certificates repo URL |
| `MATCH_PASSWORD` | Match encryption password |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64 `username:token` for git |
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` | App-specific password for Apple ID |
| `SLACK_WEBHOOK_URL` | (Optional) Slack webhook for notifications |

### How It Works

- **Pull requests**: Runs `ci_build` — syncs certificates and builds (no deploy)
- **Push to main**: Runs `ci` — full pipeline with TestFlight deploy

### Generating App-Specific Password

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in > Security > App-Specific Passwords
3. Generate a new password
4. Add it as `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` secret

### Custom Triggers

To deploy on tags instead of main push:

```yaml
on:
  push:
    tags:
      - "v*"
```

## Bitrise

Runway lanes work on any CI. For Bitrise:

1. Add a **Script** step with:
   ```bash
   bundle exec fastlane ci
   ```

2. Add environment variables in Workflow Editor > Secrets

3. Enable the **Certificate and profile installer** step before the script step (or rely on match via the lane)

## Other CI Providers

The `ci` and `ci_build` lanes handle keychain setup internally, so they work on any macOS-based CI:

```bash
# Build only
bundle exec fastlane ci_build

# Full pipeline
bundle exec fastlane ci
```

Ensure all required environment variables from `.env.example` are set as CI secrets.
