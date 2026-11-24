# wmd 0.1.41 (commit f896db7a78550adb1b3292eb291af93045826254), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/wmd", using: :nounzip
  version "0.1.41"
  sha256 "e40c16a9fd153c58c5b9103296244be03e054cb1ff9b3dd18a3e7b0ec1d6afb3"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/wmdd", using: :nounzip
    sha256 "3b635f6d7a644e2942b5fb7dde82103d67e1c972a96c058dcda4945d713b12ab"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/wmd-run", using: :nounzip
    sha256 "ab3fa787dd8e4b12dc844dc849ef7de8db4acef00bb252e6977db0562b0ba7c2"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/wmd-exe-stub", using: :nounzip
    sha256 "28874f105767adcf9d03f79cfa7d7a324d98d4ed646de38c1cd6abf144328e0a"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/wmd-relay", using: :nounzip
    sha256 "334d36b84b6cc2e301e9ae0de7189506217595fe3db98ab59c2157ffe71e9196"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/Image", using: :nounzip
    sha256 "0f17a1a3941f8827396265906e7b23cd70a85212caec47c20915abd5a45e19fe"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/Image-4k", using: :nounzip
    sha256 "97ba5f7832895f2de857375d3802b9b016976258583613c4dbd903c271792e87"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/initramfs.cpio.gz", using: :nounzip
    sha256 "1cac59f3a8bcf52a2b6b2d5769bf94dc237ec16c8b54df50686b4612bbe7bfef"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/features", using: :nounzip
    sha256 "02693b8b6c099e10fdb7a092394102ee92971ce1e39d0d6e5327ff8be1d0ee74"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/config", using: :nounzip
    sha256 "a70b9ee01f841c87eaa8270977db69fb3c2c9db8bc92aeb1f88c073c710eb3b0"
  end

  resource "wmd-ccwrap-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/wmd-ccwrap-linux-arm64", using: :nounzip
    sha256 "c066851318b1d9f292fa848a04b0771295dd6f0eac5c866af53166b7dc72f9f8"
  end

  resource "wmd-ccshim-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/wmd-ccshim-linux-arm64", using: :nounzip
    sha256 "24d8a1a0b4da43a1ecf2e1426fb9761b266395b21d6639c8be5ffb258cb45117"
  end

  resource "ccache-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/ccache-linux-arm64", using: :nounzip
    sha256 "47f20c5b7cfc04da8deda7a7787f5565f500a9885448752bdb59b7dc8d98d575"
  end

  resource "ccache-LICENSE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/ccache-LICENSE.txt", using: :nounzip
    sha256 "53c0ac34e61c628ee04b794f530be732b6181f5571f52a8aed447a3e41a6ccde"
  end

  resource "ccache-SOURCE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/ccache-SOURCE.txt", using: :nounzip
    sha256 "7c0252f648ba064ee3e874faa242ca178788f36c9a83767dee69a7f42759fed4"
  end

  resource "ccache-source.tar.xz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.41/ccache-source.tar.xz", using: :nounzip
    sha256 "4c03bc840699127d16c3f0e6112e3f40ce6a230d5873daa78c60a59c7ef59d25"
  end

  def install
    # wmd looks for wmdd, wmd-run and guest/arm64 next to its own file, so they all live in libexec
    # and bin holds small scripts that start them there.
    libexec.install "wmd"
    resources.each do |r|
      dest = %w[wmdd wmd-run wmd-exe-stub wmd-relay].include?(r.name) ? libexec : libexec/"guest/arm64"
      r.stage { dest.install r.name }
    end
    %w[wmd wmdd wmd-run wmd-exe-stub wmd-relay].each { |b| chmod 0755, libexec/b }
    bin.write_exec_script libexec/"wmd", libexec/"wmdd", libexec/"wmd-relay"
  end

  def caveats
    <<~EOS
      Run `wmd setup` once to start the wmd daemon at login and add a "wmd" docker context.
      If you ran it with wmd 0.1.7 or older, run it once more: those set the daemon up
      to start from a folder that `brew upgrade` deletes.
      After an upgrade the daemon restarts into the new version by itself once no
      container runs. Coming from 0.1.15 or older, run `wmd setup` once to restart it.
    EOS
  end

  test do
    assert_match "build f896db7a", shell_output("#{bin}/wmd --version")
  end
end
