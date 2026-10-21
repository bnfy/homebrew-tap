# Blanc Homebrew tap

Install [Blanc](https://blanc.day) on macOS 13 or later (Apple Silicon or Intel):

```sh
brew install --cask bnfy/tap/blanc
```

The cask installs the same notarized DMG published on
[GitHub Releases](https://github.com/bnfy/blanc/releases). Blanc updates itself
after that, so `brew upgrade` leaves it alone; `brew upgrade --greedy` also works.

## How the cask stays current

`.github/workflows/bump.yml` checks for a new Blanc release every hour. It takes
the DMG hashes only from the release's `SHA256SUMS`, after that file's Sigstore
bundle verifies against Blanc's published release signer, and only when they
match GitHub's own digests for the same assets. It then audits the cask,
installs it and checks Gatekeeper before committing.

## License

The cask and scripts in this repository are MIT licensed. The Blanc name and
logo remain reserved; see Blanc's `ASSET-LICENSE.md`.
