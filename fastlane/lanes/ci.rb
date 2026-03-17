platform :ios do
  desc "Full CI pipeline: sync certificates, build, and deploy"
  lane :ci do |options|
    UI.header("Runway CI Pipeline")

    begin
      create_keychain(
        name: "runway_ci",
        password: "runway_ci_password",
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
      delete_keychain(name: "runway_ci") rescue nil
    end
  end

  desc "CI build only — no deploy"
  lane :ci_build do
    begin
      create_keychain(
        name: "runway_ci",
        password: "runway_ci_password",
        default_keychain: true,
        unlock: true,
        timeout: 3600,
        lock_when_sleeps: false
      )

      certificates_sync
      build_app

      UI.success("CI build complete!")
    ensure
      delete_keychain(name: "runway_ci") rescue nil
    end
  end
end
