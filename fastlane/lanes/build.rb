platform :ios do
  desc "Build the app with automatic version and build number management"
  desc "Options: type (patch|minor|major)"
  lane :build do |options|
    bump_type = options[:type] || "patch"

    increment_version_number_in_xcodeproj(bump_type: bump_type, scheme: ENV["SCHEME"])
    increment_build_number_in_xcodeproj(scheme: ENV["SCHEME"])

    version = get_version_number_from_xcodeproj(scheme: ENV["SCHEME"])
    build = get_build_number_from_xcodeproj(scheme: ENV["SCHEME"])

    UI.message("Building v#{version} (#{build})")

    build_app

    UI.success("Build complete: v#{version} (#{build})")
  end

  desc "Bump version without building"
  lane :bump do |options|
    bump_type = options[:type] || "patch"

    increment_version_number_in_xcodeproj(bump_type: bump_type, scheme: ENV["SCHEME"])
    increment_build_number_in_xcodeproj(scheme: ENV["SCHEME"])

    version = get_version_number_from_xcodeproj(scheme: ENV["SCHEME"])
    build = get_build_number_from_xcodeproj(scheme: ENV["SCHEME"])

    commit_version_bump(
      message: "chore: bump version to #{version} (#{build})",
      xcodeproj: ENV["XCODEPROJ"]
    )

    UI.success("Bumped to v#{version} (#{build})")
  end
end
