# Setup Guide

## Prerequisites

- macOS with Xcode 15+ installed
- Ruby 3.0+ (`ruby --version`)
- Bundler (`gem install bundler`)
- An Apple Developer account
- A private git repository for match certificates

## Step 1: Install Runway

Copy the `fastlane/` directory into your iOS project root:

```bash
cp -r Runway/fastlane ./fastlane
cp Runway/.env.example .env
cp Runway/Gemfile .
```

## Step 2: Configure Environment

Edit `.env` with your values:

```bash
APP_IDENTIFIER=com.yourcompany.yourapp
SCHEME=YourApp
APPLE_ID=you@example.com
TEAM_ID=ABCDE12345
ITC_TEAM_ID=12345678
MATCH_GIT_URL=git@github.com:your-org/certificates.git
MATCH_PASSWORD=a-strong-encryption-password
```

## Step 3: Install Dependencies

```bash
bundle install
```

## Step 4: Initialize Match

If this is your first time setting up code signing:

```bash
bundle exec fastlane certificates_setup
```

This creates development and App Store certificates/profiles and stores them encrypted in your match git repo.

## Step 5: Verify Setup

```bash
bundle exec fastlane health
```

This checks that all required environment variables are set and match is configured.

## Step 6: First Build

```bash
bundle exec fastlane build
```

## Customization

### Adding a new lane

Create a new file in `fastlane/lanes/`:

```ruby
# fastlane/lanes/custom.rb
platform :ios do
  desc "My custom lane"
  lane :custom do
    # Your logic here
  end
end
```

Then import it in `Fastfile`:

```ruby
import "lanes/custom.rb"
```

### Multiple targets

For apps with multiple targets, use environment variables per target:

```bash
SCHEME=AppClip APP_IDENTIFIER=com.company.app.clip bundle exec fastlane build
```
