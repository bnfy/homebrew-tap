cask "blanc" do
  arch arm: "-arm64"

  version "1.42.0"
  sha256 arm:   "155997b0a90f9cc26938b92c36e5b03be84a4a3b6dee0a7cf92b17f38c71cfb6",
         intel: "14134491a3a0a394387ebedb761cd87f11909fbc20c279ecab855ab6827f1389"

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
