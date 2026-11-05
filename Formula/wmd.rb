# wmd 0.1.1 (commit bd27cfd0835e0ece9d462cf3abdcdce38a1a824f), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/wmd", using: :nounzip
  version "0.1.1"
  sha256 "e0d2bdbaefb998ec9aaea627eee95d1f3bcbe4327e3791a2e1cf5fa6d498c381"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/wmdd", using: :nounzip
    sha256 "2abe488cd3ab789530353147634f0ebe71a49339c2e2edf7857168a2ecc97db7"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/wmd-run", using: :nounzip
    sha256 "7a8fa98fe54ca07c49af12e3cddaf08457b960c8f13c0a4de67706dd8d55229b"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/wmd-exe-stub", using: :nounzip
    sha256 "e107bdc4e9e29f7fca2899837af4a1bb5032ff08bcbcb6e266e6bc367d15bb01"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/wmd-relay", using: :nounzip
    sha256 "0a1f8227fbc8dfa2545b9ed3250644192b1de30bbbacc92fc2ea9bd3f941bf8d"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/vm.wasm", using: :nounzip
    sha256 "551ac6d688d1f468e5f96a3dd7ef92e53ff236eb2d89d6fae9631a3aa620892f"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/Image", using: :nounzip
    sha256 "89c0717c61c44389918bef60e4ab322907b4b4c0981769e71590208c9b656036"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/Image-4k", using: :nounzip
    sha256 "3690e0d6af5139d8c6a2a0de55c0ca8151b0561bb87a62cb4ea322f0338b0629"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/initramfs.cpio.gz", using: :nounzip
    sha256 "988ebc50cf2c1784b8534565a8142ad68f0cd88f9f7cb5664ef18aa24cafadef"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.1/config", using: :nounzip
    sha256 "bc6ef6fb57296285f511a429e1171b6299e679a4e4315fde05de250f34eb6ccc"
  end

  def install
    # wmd looks for wmdd, wmd-run and guest/arm64 next to its own file, so they all live in libexec
    # and bin holds small scripts that start them there.
    libexec.install "wmd"
    resources.each do |r|
      dest = r.name.start_with?("wmd") ? libexec : libexec/"guest/arm64"
      r.stage { dest.install r.name }
    end
    %w[wmd wmdd wmd-run wmd-exe-stub wmd-relay].each { |b| chmod 0755, libexec/b }
    bin.write_exec_script libexec/"wmd", libexec/"wmdd", libexec/"wmd-relay"
  end

  def caveats
    <<~EOS
      Run `wmd setup` once to start the wmd daemon at login and add a "wmd" docker context.
    EOS
  end

  test do
    assert_match "build bd27cfd0", shell_output("#{bin}/wmd --version")
  end
end
