cask "bobby" do
  version "111.0.1"

  if Hardware::CPU.intel?
    arch = "x86"
    sha256 "ef4d117f440ee45e75a689d4dfd639fd28b6c333f5285d5bbd06fea77405a099"
  else
    arch = "arm64"
    sha256 "9ab0d57bd13ffeda885a8ac0ac50998ca2664482a8add1b06374ec3aa1a57d87"
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
