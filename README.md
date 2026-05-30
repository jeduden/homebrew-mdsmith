# homebrew-mdsmith

[![Tests](https://github.com/jeduden/homebrew-mdsmith/actions/workflows/tests.yml/badge.svg)](https://github.com/jeduden/homebrew-mdsmith/actions/workflows/tests.yml)

[Homebrew](https://brew.sh) tap for
[mdsmith](https://github.com/jeduden/mdsmith) — a fast Markdown linter
and formatter written in Go.

## Install

```bash
brew tap jeduden/mdsmith
brew install mdsmith
mdsmith version
```

…or in a single command:

```bash
brew install jeduden/mdsmith/mdsmith
```

The formula installs the prebuilt binary from the matching mdsmith
GitHub release — macOS and Linux, on both Intel (x86_64) and Apple
Silicon / arm64 — and verifies its SHA-256 before linking it as
`mdsmith`. No Go toolchain and no compilation required.

## Upgrade

```bash
brew update
brew upgrade mdsmith
```

## Uninstall

```bash
brew uninstall mdsmith
brew untap jeduden/mdsmith
```

## How this tap stays current

`Formula/mdsmith.rb` pins an exact version and a per-platform SHA-256,
so every install is reproducible. Keeping it current is automated:

- `.github/workflows/update-formula.yml` checks for new mdsmith
  releases on a daily schedule (and on manual dispatch) and opens a
  pull request that bumps the version and checksums.
- `scripts/update-formula.sh` performs the rewrite and can be run by
  hand:

  ```bash
  scripts/update-formula.sh          # bump to the latest release
  scripts/update-formula.sh 0.28.0   # bump to a specific version
  ```

It discovers versions with `git ls-remote` and reads the release
`checksums.txt`, so it needs no GitHub API token.

## License

[MIT](LICENSE) — same license as mdsmith.
