cask "bobby" do
  version "0.8.0"
  sha256 "66a49484070979a3215bf164a47a33d1035795ad3d513a598cbdaa7896c7bf81"

  url "https://github.com/nlydv/bob-wallet/releases/download/v#{version}/Bob-#{version}.dmg",
      verified: "github.com/nlydv/bob-wallet/"
  name "Bob Wallet"
  desc "Handshake wallet GUI for name auction and DNS record management"
  homepage "https://bobwallet.io/"

  livecheck do
    url :url
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  app "Bob.app"

  zap trash: [
    "~/Library/Application Support/Bob",
    "~/Library/Preferences/com.kyokan.BobRelease.plist",
    "~/Library/Saved Application State/com.kyokan.BobRelease.savedState",
  ]
end
