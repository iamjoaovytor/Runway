platform :ios do
  desc "Post-deploy monitoring and verification"
  lane :monitor do
    version = get_version_number_from_xcodeproj(scheme: ENV["SCHEME"])
    build = get_build_number_from_xcodeproj(scheme: ENV["SCHEME"])

    UI.header("Monitoring v#{version} (#{build})")

    # Check TestFlight processing status
    UI.message("Checking TestFlight processing status...")

    begin
      latest = latest_testflight_build_number
      UI.success("Latest TestFlight build: #{latest}")
    rescue => e
      UI.important("Could not fetch TestFlight status: #{e.message}")
    end

    # Verify App Store Connect status
    UI.message("Verifying App Store Connect...")

    begin
      deliver(
        skip_binary_upload: true,
        skip_screenshots: true,
        skip_metadata: true,
        precheck_include_in_app_purchases: false,
        run_precheck_before_submit: true,
        submit_for_review: false
      )
      UI.success("Precheck passed — no submission issues detected")
    rescue => e
      UI.error("Precheck found issues: #{e.message}")
    end

    # Notify team
    if ENV["SLACK_WEBHOOK_URL"]
      slack(
        message: "Deploy monitoring complete for v#{version} (#{build})",
        success: true,
        default_payloads: [:git_branch, :last_git_commit]
      )
    end
  end

  desc "Quick health check — verify credentials and configuration"
  lane :health do
    UI.header("Runway Health Check")

    # Verify environment
    required_vars = %w[APP_IDENTIFIER APPLE_ID TEAM_ID]
    missing = required_vars.select { |var| ENV[var].nil? || ENV[var].empty? }

    if missing.any?
      UI.user_error!("Missing environment variables: #{missing.join(', ')}")
    else
      UI.success("All required environment variables set")
    end

    # Verify match
    if ENV["MATCH_GIT_URL"]
      UI.success("Match configured: #{ENV['MATCH_GIT_URL']}")
    else
      UI.important("Match not configured — set MATCH_GIT_URL")
    end

    # Verify Slack
    if ENV["SLACK_WEBHOOK_URL"]
      UI.success("Slack notifications configured")
    else
      UI.important("Slack not configured — set SLACK_WEBHOOK_URL for notifications")
    end

    UI.success("Health check complete!")
  end
end
