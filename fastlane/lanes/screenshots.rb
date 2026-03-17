platform :ios do
  desc "Generate localized screenshots for all configured devices"
  lane :screenshots do
    capture_screenshots

    frame_screenshots(
      white: false,
      path: "./fastlane/screenshots"
    )

    UI.success("Screenshots captured and framed successfully!")
  end

  desc "Upload screenshots to App Store Connect"
  lane :screenshots_upload do
    upload_to_app_store(
      skip_binary_upload: true,
      skip_metadata: true,
      screenshots_path: "./fastlane/screenshots"
    )
  end
end
