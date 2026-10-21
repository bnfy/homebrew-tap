cask "blanc" do
  arch arm: "-arm64"

  version "1.40.0"
  sha256 arm:   "38331a6cf265afd6e42115e8f8ea6ae33cf4e51e20d0d1d8e30a6f5cf24f0465",
         intel: "5318ebd1ade3fc0893608cd4673a4819675cc8f63a4fc207c446f837323ba697"

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
