# Certificate Management

Runway uses [match](https://docs.fastlane.tools/actions/match/) for code signing. Match stores certificates and provisioning profiles in a private git repository, encrypted.

## How It Works

1. Certificates and profiles are generated via Apple Developer Portal
2. They're encrypted and stored in a git repo you control
3. Team members and CI pull from this repo — everyone uses the same signing identity
4. No more "missing provisioning profile" errors

## Initial Setup

### 1. Create a private git repository

Create a new **private** repository (e.g., `your-org/certificates`). Do not add any files.

### 2. Run setup

```bash
bundle exec fastlane certificates_setup
```

This will:
- Generate development certificates and profiles
- Generate App Store distribution certificates and profiles
- Encrypt and push them to your match repo

### 3. Share with your team

Team members only need:
- Access to the match git repo
- The `MATCH_PASSWORD` value

Then they run:

```bash
bundle exec fastlane certificates_sync
```

## CI Configuration

In CI, certificates are synced in **read-only** mode — CI never modifies your certificates.

Required secrets:
- `MATCH_GIT_URL` — your certificates repo URL
- `MATCH_PASSWORD` — encryption password
- `MATCH_GIT_BASIC_AUTHORIZATION` — base64-encoded `username:token` for git auth

Generate the auth token:

```bash
echo -n "your-github-username:your-personal-access-token" | base64
```

## Renewal

When certificates expire (annually):

```bash
bundle exec fastlane certificates_nuke
```

This revokes old certificates and generates new ones. All team members must re-sync afterward.

## Troubleshooting

### "Could not create another certificate"

Apple limits the number of distribution certificates per account. Revoke unused ones in the Apple Developer Portal or use `certificates_nuke`.

### "Profile doesn't match certificate"

Run `certificates_nuke` to regenerate everything from scratch.

### CI can't access match repo

Verify `MATCH_GIT_BASIC_AUTHORIZATION` is correctly base64-encoded and the token has repo access.
