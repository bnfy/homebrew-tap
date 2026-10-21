#!/usr/bin/env bash
# Moves Casks/blanc.rb to a Blanc release. The DMG hashes come only from the
# release's SHA256SUMS after its Sigstore bundle verifies against Blanc's
# published release signer, and must match GitHub's own asset digests.
#
#   scripts/bump-blanc.sh            # newest published release
#   scripts/bump-blanc.sh 1.41.0     # a specific release
#   scripts/bump-blanc.sh --verify   # check the cask's own hashes, change nothing
#
# Writes changed=true|false and version=X.Y.Z to $GITHUB_OUTPUT when set.
set -euo pipefail

REPO="bnfy/blanc"
CASK="Casks/blanc.rb"
# Published at https://blanc.day (Security guide) and in every release's notes.
SIGNER_IDENTITY="anthony@bnfy.me"
SIGNER_ISSUER="https://github.com/login/oauth"

output() { [ -n "${GITHUB_OUTPUT:-}" ] && echo "$1" >> "$GITHUB_OUTPUT"; return 0; }

current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$CASK")
[ -n "$current" ] || { echo "Could not read the version in $CASK." >&2; exit 1; }

verify=false
if [ "${1:-}" = "--verify" ]; then
  verify=true
  version="$current"
elif [ -n "${1:-}" ]; then
  version="${1#v}"
else
  version=$(gh api "repos/$REPO/releases/latest" --jq .tag_name)
  version="${version#v}"
fi
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Not a release version: $version" >&2; exit 1; }
tag="v$version"

if ! $verify && { [ "$version" = "$current" ] || [ "$(printf '%s\n%s\n' "$current" "$version" | sort -V | tail -1)" = "$current" ]; }; then
  echo "Cask is at $current; $tag is not newer."
  output "changed=false"
  exit 0
fi

state=$(gh api "repos/$REPO/releases/tags/$tag" --jq '"\(.draft) \(.prerelease)"')
[ "$state" = "false false" ] || { echo "$tag is a draft or pre-release; refusing." >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
for name in SHA256SUMS SHA256SUMS.sigstore.json; do
  curl -fsSL --retry 3 -o "$work/$name" "https://github.com/$REPO/releases/download/$tag/$name"
done

cosign verify-blob \
  --bundle "$work/SHA256SUMS.sigstore.json" \
  --certificate-identity "$SIGNER_IDENTITY" \
  --certificate-oidc-issuer "$SIGNER_ISSUER" \
  "$work/SHA256SUMS"

signed_hash() {
  local hash
  hash=$(awk -v name="$1" '$2 == name { print $1 }' "$work/SHA256SUMS")
  [[ "$hash" =~ ^[0-9a-f]{64}$ ]] || { echo "SHA256SUMS has no entry for $1." >&2; exit 1; }
  local github
  github=$(gh api "repos/$REPO/releases/tags/$tag" \
    --jq ".assets[] | select(.name == \"$1\") | .digest")
  [ "$github" = "sha256:$hash" ] || { echo "$1: GitHub digest $github differs from the signed $hash." >&2; exit 1; }
  echo "$hash"
}

arm=$(signed_hash "Blanc-$version-arm64.dmg")
intel=$(signed_hash "Blanc-$version.dmg")

if $verify; then
  grep -q "sha256 arm:   \"$arm\"," "$CASK" && grep -q "intel: \"$intel\"$" "$CASK" \
    || { echo "$CASK hashes differ from the signed $tag checksums." >&2; exit 1; }
  echo "$CASK matches the signed $tag checksums."
  exit 0
fi

sed -i.bak \
  -e "s/^  version \".*\"$/  version \"$version\"/" \
  -e "s/^  sha256 arm:   \"[0-9a-f]*\",$/  sha256 arm:   \"$arm\",/" \
  -e "s/^         intel: \"[0-9a-f]*\"$/         intel: \"$intel\"/" \
  "$CASK"
rm -f "$CASK.bak"

grep -q "version \"$version\"" "$CASK" && grep -q "$arm" "$CASK" && grep -q "$intel" "$CASK" \
  || { echo "Failed to rewrite $CASK." >&2; exit 1; }

echo "Cask moved from $current to $version (signed hashes verified)."
output "changed=true"
output "version=$version"
