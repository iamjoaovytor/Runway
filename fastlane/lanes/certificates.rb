platform :ios do
  desc "Setup certificates and provisioning profiles from scratch"
  lane :certificates_setup do
    match(type: "development")
    match(type: "appstore")
  end

  desc "Sync certificates (read-only, safe for CI)"
  lane :certificates_sync do
    args = { type: "appstore", readonly: is_ci }
    if ENV["CI"]
      args[:keychain_name] = KEYCHAIN_NAME
      args[:keychain_password] = KEYCHAIN_PASSWORD
    end
    match(args)
  end

  desc "Nuke and regenerate all certificates (use with caution)"
  lane :certificates_nuke do
    match_nuke(type: "development")
    match_nuke(type: "appstore")
    match(type: "development", force: true)
    match(type: "appstore", force: true)
  end
end
