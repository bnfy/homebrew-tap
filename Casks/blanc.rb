cask "blanc" do
  arch arm: "-arm64"

  version "1.44.1"
  sha256 arm:   "e32c07fbe313b231302cb50bc085ab7dd3d08eae81ea644d0e735c11820d87c4",
         intel: "701d643d01ba5cd14343921bbfd011163f686fb0bff187e82f5110f595300be7"

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
