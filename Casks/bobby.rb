cask "bobby" do
  version "0.999.3"

  if Hardware::CPU.intel?
    arch = "x86"
    sha256 "abcdef"
  else
    arch = "arm64"
    sha256 "012345"
  end

  url "https://github.com/nlydv/bob-wallet/releases/download/v#{version}/Bob-#{version}-#{arch}.dmg",
      verified: "github.com/nlydv/bob-wallet/"
  name "Bob Wallet"
  desc "Handshake wallet application for managing transactions, domain name auctions, and DNS records"
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
