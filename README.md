# homebrew-wmd

The Homebrew tap of [wmd](https://github.com/threadedstack/wmd-releases), for macOS on Apple silicon. Its formula `Formula/wmd.rb` installs `wmd`, `wmdd`, `wmd-relay` and the arm64 guest files wmd runs containers with.

## Install

```sh
brew tap threadedstack/wmd
brew install wmd
wmd setup
```

Homebrew 7 and later loads formulae of a tap that is not Homebrew's own only after you trust it, so on those versions run `brew trust threadedstack/wmd` once, right after `brew tap`. Older Homebrew has no `brew trust` command and does not need it. `wmd setup` starts the wmd daemon at login and adds a `wmd` docker context.

## Update

Every wmd release updates `Formula/wmd.rb`, so:

```sh
brew update
brew upgrade wmd
```

## Remove

```sh
brew uninstall wmd
brew untap threadedstack/wmd
```

The binaries are not signed with a Developer ID and are not notarized. Each file's sha256 is in the formula and in `SHA256SUMS.txt` of its release.
