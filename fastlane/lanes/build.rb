platform :ios do
  desc "Build the app with automatic version and build number management"
  desc "Options: type (patch|minor|major)"
  lane :build do |options|
    bump_type = options[:type] || "patch"

    increment_version_number(bump_type: bump_type)
    increment_build_number

    version = get_version_number
    build = get_build_number

    UI.message("Building v#{version} (#{build})")

    build_app

    UI.success("Build complete: v#{version} (#{build})")
  end

  desc "Bump version without building"
  lane :bump do |options|
    bump_type = options[:type] || "patch"

    increment_version_number(bump_type: bump_type)
    increment_build_number

    version = get_version_number
    build = get_build_number

    commit_version_bump(
      message: "chore: bump version to #{version} (#{build})",
      xcodeproj: ENV["XCODEPROJ"]
    )

    UI.success("Bumped to v#{version} (#{build})")
  end
end
