# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is Runway

Production-ready Fastlane template for iOS app deployment. Users clone this repo and copy `fastlane/` into their iOS project. All configuration is environment-driven via `.env`.

## Architecture

The Fastfile is the entry point — it imports six modular lane files from `fastlane/lanes/`. Each lane file owns one domain:

- **certificates.rb** — match-based code signing (setup, sync, nuke)
- **build.rb** — version bumping + archive via `fastlane-plugin-versioning` (reads directly from xcodeproj, not agvtool)
- **deploy.rb** — TestFlight (`deploy_beta`) and App Store (`deploy_release`) with auto-changelog and phased rollout
- **screenshots.rb** — multi-device capture + frameit
- **monitoring.rb** — post-deploy verification (`monitor`) and config validation (`health`)
- **ci.rb** — full pipeline with isolated keychain; auto-routes to App Store on `main`/`release/*`, TestFlight otherwise

Config files (Appfile, Matchfile, Snapfile, Gymfile) read from `ENV` so nothing sensitive is committed.

## Lane dependency graph

```
ci → create_keychain → deploy_release OR deploy_beta → cleanup_keychain
deploy_beta → certificates_sync → [optional version bump] → build_app → upload_to_testflight
deploy_release → certificates_sync → [optional version bump] → build_app → upload_to_app_store
build → version bump → build_app
bump → version bump → commit_version_bump (no build)
```

## Common commands

```bash
# Health check (no Apple account needed)
bundle exec fastlane health

# Build without code signing (local testing)
SKIP_EXPORT=true bundle exec fastlane build

# Build with export
bundle exec fastlane build

# Bump version only (patch|minor|major)
bundle exec fastlane bump type:minor

# Deploy (optional type: bumps version before deploy)
bundle exec fastlane deploy_beta
bundle exec fastlane deploy_beta type:minor
bundle exec fastlane deploy_release
bundle exec fastlane deploy_release type:major submit:false

# CI pipeline (used by GitHub Actions)
bundle exec fastlane ci
bundle exec fastlane ci_build
```

## Key conventions

- All lanes live in `fastlane/lanes/*.rb`, one file per domain — never put lanes directly in Fastfile
- Version management uses `*_in_xcodeproj` actions from `fastlane-plugin-versioning`, not the default agvtool-based actions
- Gymfile supports `SKIP_EXPORT=true` for local builds without provisioning profiles
- `certificates_sync` uses `readonly: true` in CI — never modify certificates from CI
- CI lanes use `ensure` to clean up the keychain even on failure
- Slack notifications are conditional on `SLACK_WEBHOOK_URL` being set
- The CI lane creates/destroys an isolated keychain (`runway_ci`)

## Git workflow

- Use conventional commits, keep them brief
- Do not include "Claude Code" in commit messages
