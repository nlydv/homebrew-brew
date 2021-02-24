cask "bob-wallet" do
  version "0.6.2"
  sha256 "561939bea3931bc9fc1c057002e6bd0f755b0cd5a1427645cf37e2779427c592"

  url "https://github.com/kyokan/bob-wallet/releases/download/v0.6.2/Bob-#{version}.dmg"
  appcast "https://github.com/kyokan/bob-wallet/releases.atom"
  name "Bob Wallet"
  desc "Bob Wallet is a GUI for DNS Record Management and Name Auctions on Handshake. It includes an integrated full node: hsd"
  homepage "https://bobwallet.io"

  app "Bob.app"

  caveats "
Uninstalling the Bob Wallet cask using the --zap option will completely delete all files, including the HSD's chain data.
If you install Bob Wallet again, the Handshake node will have to resync the entire blockchain again."

  zap trash: [
    "~/Desktop/Bob-0.6.2.dmg",
    "~/Library/Application Support/Bob",
    "~/Library/Preferences/com.kyokan.BobRelease.plist",
    "~/Library/Saved Application State/com.kyokan.BobRelease.savedState",
  ]
end
