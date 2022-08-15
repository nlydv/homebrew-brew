cask "bobby" do
  version "111.0.2"

  if Hardware::CPU.intel?
    arch = "x86"
    sha256 "a5432e301522ad985533fb8bc129ed1dff65f7cc927a5c8fb7fea4a477edc860"
  else
    arch = "arm64"
    sha256 "74955f7b4ed27fb4325a2cf6e93811c6282ee6589c8f11dda4f034163ac1e401"
  end

  url "https://github.com/nlydv/bob-wallet/releases/download/v#{version}/Bob-#{version}-#{arch}.dmg",
      verified: "github.com/nlydv/bob-wallet/"
  name "Bob Wallet"
  desc "Handshake wallet GUI for managing transactions, name auctions, and DNS records"
  homepage "https://bobwallet.io/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  app "Bob.app"

  zap trash: [
    "~/Library/Application Support/Bob",
    "~/Library/Preferences/com.kyokan.BobRelease.plist",
    "~/Library/Saved Application State/com.kyokan.BobRelease.savedState",
  ]
end
