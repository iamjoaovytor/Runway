require "securerandom"

platform :ios do
  KEYCHAIN_NAME = "runway_ci"
  KEYCHAIN_PASSWORD = ENV.fetch("CI_KEYCHAIN_PASSWORD") { SecureRandom.hex(16) }

  desc "Full CI pipeline: sync certificates, build, and deploy"
  lane :ci do |options|
    UI.header("Runway CI Pipeline")

    begin
      create_keychain(
        name: KEYCHAIN_NAME,
        password: KEYCHAIN_PASSWORD,
        default_keychain: true,
        unlock: true,
        timeout: 3600,
        lock_when_sleeps: false
      )

      branch = git_branch

      if branch == "main" || branch&.start_with?("release/")
        deploy_release(submit: false)
      else
        deploy_beta
      end

      UI.success("CI pipeline complete!")
    ensure
      begin
        delete_keychain(name: KEYCHAIN_NAME)
      rescue => e
        UI.important("Keychain cleanup failed: #{e.message}")
      end
    end
  end

  desc "CI build only — no deploy"
  lane :ci_build do
    begin
      create_keychain(
        name: KEYCHAIN_NAME,
        password: KEYCHAIN_PASSWORD,
        default_keychain: true,
        unlock: true,
        timeout: 3600,
        lock_when_sleeps: false
      )

      certificates_sync
      build_app

      UI.success("CI build complete!")
    ensure
      begin
        delete_keychain(name: KEYCHAIN_NAME)
      rescue => e
        UI.important("Keychain cleanup failed: #{e.message}")
      end
    end
  end
end
