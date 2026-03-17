platform :ios do
  desc "Full CI pipeline: sync certificates, build, and deploy to TestFlight"
  lane :ci do |options|
    UI.header("Runway CI Pipeline")

    # Setup CI keychain
    create_keychain(
      name: "runway_ci",
      password: "runway_ci_password",
      default_keychain: true,
      unlock: true,
      timeout: 3600,
      lock_when_sleeps: false
    )

    # Sync certificates (read-only in CI)
    match(
      type: "appstore",
      readonly: true,
      keychain_name: "runway_ci",
      keychain_password: "runway_ci_password"
    )

    # Build
    increment_build_number
    build_app

    # Deploy (TestFlight by default, App Store if release branch)
    branch = git_branch

    if branch == "main" || branch&.start_with?("release/")
      deploy_release(submit: false)
    else
      deploy_beta
    end

    # Cleanup
    delete_keychain(name: "runway_ci")

    UI.success("CI pipeline complete!")
  end

  desc "CI build only — no deploy"
  lane :ci_build do
    create_keychain(
      name: "runway_ci",
      password: "runway_ci_password",
      default_keychain: true,
      unlock: true,
      timeout: 3600,
      lock_when_sleeps: false
    )

    match(
      type: "appstore",
      readonly: true,
      keychain_name: "runway_ci",
      keychain_password: "runway_ci_password"
    )

    build_app

    delete_keychain(name: "runway_ci")

    UI.success("CI build complete!")
  end
end
