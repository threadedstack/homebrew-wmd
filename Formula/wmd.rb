# wmd 0.1.2 (commit c3f055655ce6798012876c9635b2ead717deeac8), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/wmd", using: :nounzip
  version "0.1.2"
  sha256 "45eab80fdecf677853e31a656794394222914f9ed12b378962504d3d84b1e79b"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/wmdd", using: :nounzip
    sha256 "a5065881b7d93e07498215b8216b56ae0da36028b96936943d98742a050091d2"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/wmd-run", using: :nounzip
    sha256 "c547599c5f3a862177bcbd49c25fb6735ef0b14b5a0eca3751ebab624d85f4e0"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/wmd-exe-stub", using: :nounzip
    sha256 "65b3c952d7fd1a7fe566ed03fee3fc5bcbf1a225b7ed2f2e88fc3dbbb6fb74ad"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/wmd-relay", using: :nounzip
    sha256 "7ec00aa728e7968ac82e48c318ebc923ebd20e38cf6bb3bcb45e26ac9af8ce82"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/vm.wasm", using: :nounzip
    sha256 "551ac6d688d1f468e5f96a3dd7ef92e53ff236eb2d89d6fae9631a3aa620892f"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/Image", using: :nounzip
    sha256 "89c0717c61c44389918bef60e4ab322907b4b4c0981769e71590208c9b656036"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/Image-4k", using: :nounzip
    sha256 "3690e0d6af5139d8c6a2a0de55c0ca8151b0561bb87a62cb4ea322f0338b0629"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/initramfs.cpio.gz", using: :nounzip
    sha256 "988ebc50cf2c1784b8534565a8142ad68f0cd88f9f7cb5664ef18aa24cafadef"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.2/config", using: :nounzip
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
    assert_match "build c3f05565", shell_output("#{bin}/wmd --version")
  end
end
