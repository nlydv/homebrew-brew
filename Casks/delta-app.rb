cask "delta-app" do
  version "1.0.0"
  sha256 "bd99115957d9235d2353a48aee1bef0cc9679796a26cf557873dec58c37d3385"

  url "https://static-assets.getdelta.io/desktop_app/Delta-#{version}.dmg"
  appcast "https://delta.app/en/download"
  name "Delta"
  desc "Desktop version of Delta – a crypto portfolio tracking app."
  homepage "https://getdelta.io/"
  caveats "This is an old release that was eventually abandoned in favor of a mobile-only product. Dropped from homebrew/casks and there's no guarantee all functionality will still work as it originally did."

  app "Delta.app"
end
