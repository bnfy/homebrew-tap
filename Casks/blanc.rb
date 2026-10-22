cask "blanc" do
  arch arm: "-arm64"

  version "1.42.1"
  sha256 arm:   "94d83e5cd7d1bae56059a7e0aa6ae3c6f1548495cddb888155bb7887fbdbef97",
         intel: "d5f86c68125ef1c1e5247a1396512d3edb2ffd350848fa5f620afc07dd542720"

  url "https://github.com/bnfy/blanc/releases/download/v#{version}/Blanc-#{version}#{arch}.dmg"
  name "Blanc"
  desc "Minimal browser with built-in ad and tracker blocking"
  homepage "https://blanc.day/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "Blanc.app"

  zap trash: [
    "~/Library/Application Support/Blanc",
    "~/Library/Caches/blanc-updater",
    "~/Library/Caches/me.bnfy.bowser",
    "~/Library/Caches/me.bnfy.bowser.ShipIt",
    "~/Library/HTTPStorages/me.bnfy.bowser",
    "~/Library/Logs/Blanc",
    "~/Library/Preferences/me.bnfy.bowser.plist",
    "~/Library/Saved Application State/me.bnfy.bowser.savedState",
  ]
end
