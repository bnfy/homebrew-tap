cask "blanc" do
  arch arm: "-arm64"

  version "1.53.0"
  sha256 arm:   "cb1cf03fe503ce3fadb0b5ba839e24928855e7f1ef5af468486e92aad3915fcd",
         intel: "e51add86a03a14351bdbedb96ab80bad5f0e3289bf90a93f1df6c1953ff9b43b"

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
