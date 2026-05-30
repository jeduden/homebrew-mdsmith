#!/usr/bin/env bash

# Bump Formula/mdsmith.rb to a target mdsmith release.
#
# Usage:
#   scripts/update-formula.sh [VERSION]
#
# VERSION is a bare semver such as 0.28.0. With no argument the highest
# stable tag in the mdsmith repository is used. The script downloads
# that release's checksums.txt, then rewrites the formula's version,
# the version segment of every asset URL, and the four sha256 values
# (each matched to the asset on the preceding url line). Under GitHub
# Actions it reports whether anything changed via $GITHUB_OUTPUT.
#
# Version discovery uses `git ls-remote` (no API token, no rate limit)
# and checksums come from the public release asset, so the script runs
# the same way locally and in CI.

set -euo pipefail

UPSTREAM="https://github.com/jeduden/mdsmith"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
formula="${script_dir}/../Formula/mdsmith.rb"

die() {
	echo "update-formula: $*" >&2
	exit 1
}

set_output() {
	if [ -n "${GITHUB_OUTPUT:-}" ]; then
		printf '%s=%s\n' "$1" "$2" >>"$GITHUB_OUTPUT"
	fi
	return 0
}

# Highest stable X.Y.Z tag from upstream, leading "v" stripped.
latest_version() {
	git ls-remote --tags --refs "$UPSTREAM" |
		sed -E 's#.*refs/tags/v?##' |
		grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' |
		sort -t. -k1,1n -k2,2n -k3,3n |
		tail -n1
}

version="${1:-$(latest_version)}"
[ -n "$version" ] || die "could not determine a target version"
version="${version#v}"

current="$(sed -nE 's/^  version "([^"]+)".*/\1/p' "$formula")"
echo "current formula version: ${current:-none}"
echo "target version:          ${version}"

if [ "$current" = "$version" ]; then
	echo "formula already at ${version}; nothing to do"
	set_output changed false
	set_output version "$version"
	exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

checksums_url="${UPSTREAM}/releases/download/v${version}/checksums.txt"
echo "fetching ${checksums_url}"
curl -fsSL -o "${tmp}/checksums.txt" "$checksums_url" ||
	die "could not download checksums.txt for v${version}"

sha_for() {
	awk -v n="$1" '$2 == n {print $1}' "${tmp}/checksums.txt"
}
darwin_arm64="$(sha_for mdsmith-darwin-arm64)"
darwin_amd64="$(sha_for mdsmith-darwin-amd64)"
linux_arm64="$(sha_for mdsmith-linux-arm64)"
linux_amd64="$(sha_for mdsmith-linux-amd64)"

for pair in \
	"darwin-arm64:${darwin_arm64}" "darwin-amd64:${darwin_amd64}" \
	"linux-arm64:${linux_arm64}" "linux-amd64:${linux_amd64}"; do
	name="${pair%%:*}"
	sha="${pair#*:}"
	printf '%s' "$sha" | grep -Eq '^[0-9a-f]{64}$' ||
		die "missing or malformed checksum for mdsmith-${name}: '${sha}'"
done

# Rewrite version, the version segment of each asset URL, and the
# sha256 line that follows each URL, keyed to that URL's asset name.
awk \
	-v ver="$version" \
	-v d_arm="$darwin_arm64" -v d_amd="$darwin_amd64" \
	-v l_arm="$linux_arm64" -v l_amd="$linux_amd64" '
	/^  version "/ {
		sub(/version "[^"]+"/, "version \"" ver "\"")
		print; next
	}
	/url "/ {
		if ($0 ~ /mdsmith-darwin-arm64/) cur = d_arm
		else if ($0 ~ /mdsmith-darwin-amd64/) cur = d_amd
		else if ($0 ~ /mdsmith-linux-arm64/) cur = l_arm
		else if ($0 ~ /mdsmith-linux-amd64/) cur = l_amd
		sub(/\/download\/v[^/]+\//, "/download/v" ver "/")
		print; next
	}
	/sha256 "/ && cur != "" {
		sub(/sha256 "[0-9a-f]*"/, "sha256 \"" cur "\"")
		print; cur = ""; next
	}
	{ print }
' "$formula" >"${tmp}/mdsmith.rb"

mv "${tmp}/mdsmith.rb" "$formula"
echo "updated ${formula} to ${version}"
set_output changed true
set_output version "$version"
