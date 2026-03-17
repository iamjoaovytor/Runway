platform :ios do
  desc "Deploy a beta build to TestFlight"
  lane :deploy_beta do
    certificates_sync

    increment_build_number_in_xcodeproj(scheme: ENV["SCHEME"])
    build_app

    changelog = changelog_from_git_commits(
      commits_count: 10,
      pretty: "- %s"
    )

    upload_to_testflight(
      changelog: changelog,
      distribute_external: false,
      notify_external_testers: false
    )

    version = get_version_number_from_xcodeproj(scheme: ENV["SCHEME"])
    build = get_build_number_from_xcodeproj(scheme: ENV["SCHEME"])

    if ENV["SLACK_WEBHOOK_URL"]
      slack(
        message: "New beta uploaded to TestFlight",
        payload: {
          "Version" => version,
          "Build" => build,
          "Changelog" => changelog
        },
        default_payloads: [:git_branch]
      )
    end

    UI.success("Beta v#{version} (#{build}) deployed to TestFlight!")
  end

  desc "Deploy to the App Store with phased release"
  lane :deploy_release do |options|
    certificates_sync

    increment_build_number_in_xcodeproj(scheme: ENV["SCHEME"])
    build_app

    upload_to_app_store(
      submit_for_review: options[:submit] != false,
      automatic_release: false,
      phased_release: true,
      precheck_include_in_app_purchases: false,
      submission_information: {
        add_id_info_uses_idfa: false
      }
    )

    version = get_version_number_from_xcodeproj(scheme: ENV["SCHEME"])
    build = get_build_number_from_xcodeproj(scheme: ENV["SCHEME"])

    if ENV["SLACK_WEBHOOK_URL"]
      slack(
        message: "New release submitted to App Store",
        payload: {
          "Version" => version,
          "Build" => build
        },
        default_payloads: [:git_branch]
      )
    end

    UI.success("v#{version} (#{build}) submitted to App Store!")
  end
end
