# Runway

Production-ready Fastlane template for iOS app deployment.

No more copy-pasting snippets from Stack Overflow. Clone, configure, ship.

## What's Included

| Lane | Description |
|------|-------------|
| `screenshots` | Automated multi-device, multi-language screenshots with frameit |
| `certificates` | Code signing via match — automated setup and renewal |
| `build` | Version bumping, build numbers, changelog generation |
| `deploy_beta` | TestFlight distribution with release notes |
| `deploy_release` | App Store submission with phased rollout |
| `monitor` | Post-deploy health checks + Slack notifications |
| `ci` | Optimized lane for CI environments (GitHub Actions, Bitrise) |

## Quick Start

### 1. Clone into your project

```bash
git clone https://github.com/iamjoaovytor/Runway.git
cp -r Runway/fastlane ./fastlane
cp Runway/.env.example .env
```

### 2. Configure environment

```bash
cp .env.example .env
# Edit .env with your values
```

### 3. Install dependencies

```bash
bundle install
```

### 4. Run your first lane

```bash
# Generate screenshots
bundle exec fastlane screenshots

# Deploy to TestFlight
bundle exec fastlane deploy_beta

# Full release
bundle exec fastlane deploy_release
```

## Project Structure

```
fastlane/
├── Fastfile              # Main entry — imports all lanes
├── Appfile               # App identity config
├── Matchfile             # Code signing config
├── Snapfile              # Screenshot config
├── Gymfile               # Build config
├── Pluginfile            # Required plugins
├── lanes/
│   ├── screenshots.rb    # Screenshot generation + framing
│   ├── certificates.rb   # Match setup + renewal
│   ├── build.rb          # Build + versioning
│   ├── deploy.rb         # TestFlight + App Store
│   ├── monitoring.rb     # Post-deploy health + notifications
│   └── ci.rb             # CI-specific optimizations
├── actions/
│   └── .gitkeep          # Custom actions go here
├── metadata/             # App Store metadata (auto-generated)
└── screenshots/          # Generated screenshots
```

## Environment Variables

All sensitive values live in `.env` (never committed). See [`.env.example`](.env.example) for the full list.

| Variable | Purpose |
|----------|---------|
| `APP_IDENTIFIER` | Bundle ID (e.g., `com.company.app`) |
| `APPLE_ID` | Apple Developer email |
| `TEAM_ID` | Apple Developer Team ID |
| `ITC_TEAM_ID` | App Store Connect Team ID |
| `MATCH_GIT_URL` | Git repo URL for match certificates |
| `MATCH_PASSWORD` | Encryption password for match |
| `SLACK_WEBHOOK_URL` | Slack incoming webhook for notifications |
| `CI` | Set to `true` in CI environments |

## Lanes in Detail

### Screenshots

Generates localized screenshots across multiple devices and frames them with device bezels and captions.

```bash
bundle exec fastlane screenshots
```

- Supports iPhone and iPad simultaneously
- Multi-language via Snapfile config
- Auto-frames with [frameit](https://docs.fastlane.tools/actions/frameit/)

### Certificates

Manages code signing with [match](https://docs.fastlane.tools/actions/match/) — never deal with provisioning profiles manually again.

```bash
# Initial setup (run once)
bundle exec fastlane certificates_setup

# Sync existing certificates (CI-safe, read-only)
bundle exec fastlane certificates_sync
```

### Build

Handles version bumping, build number management, and archive creation.

```bash
# Bump patch version + build
bundle exec fastlane build

# Bump minor version
bundle exec fastlane build type:minor
```

### Deploy

Separate lanes for beta (TestFlight) and production (App Store).

```bash
# TestFlight beta
bundle exec fastlane deploy_beta

# App Store release with phased rollout
bundle exec fastlane deploy_release
```

### Monitor

Post-deploy verification and team notifications.

```bash
bundle exec fastlane monitor
```

- Verifies build is processing on App Store Connect
- Sends Slack notification with build details
- Checks for common submission issues

### CI

Optimized lane for continuous integration. Handles certificate sync, build, and deploy in one step.

```bash
bundle exec fastlane ci
```

- Read-only certificate sync
- Keychain management for CI
- Artifact collection

## CI Integration

### GitHub Actions

Copy the included workflow:

```bash
cp .github/workflows/ios-deploy.yml /path/to/your/project/.github/workflows/
```

See [docs/CI_INTEGRATION.md](docs/CI_INTEGRATION.md) for configuration details.

## Requirements

- Ruby 3.0+
- Bundler 2.0+
- Xcode 15+
- Apple Developer account
- A git repo for match certificates (private)

## Contributing

Contributions are welcome. Please open an issue before submitting a PR for major changes.

## License

MIT — see [LICENSE](LICENSE).
