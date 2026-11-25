# wmd 0.1.48 (commit c35d2418a684f2b2d6bb865549f151ba6c570150), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/wmd", using: :nounzip
  version "0.1.48"
  sha256 "c6676658908026b64d3d65e7c3ccec0792490602a9579db516fed417b0e9c5e4"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/wmdd", using: :nounzip
    sha256 "4fc8cb6602222317b01185e86e416a1391af8a2461fa70fcc753dbe2686af4b5"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/wmd-run", using: :nounzip
    sha256 "ff3f81852c1f9004aa25d35efd2c38be718078a70993f726794a1870ca3cd797"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/wmd-exe-stub", using: :nounzip
    sha256 "1d43eb49057884db2051b0231f7fce460c54d56369f084c2875af037e18fd67e"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/wmd-relay", using: :nounzip
    sha256 "264630ec99aab4a77b7646563b2e1f64e283565d69a089989bc00f248925f44e"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/vm.wasm", using: :nounzip
    sha256 "7f94f411f4041834981deedb5b8bb7f8961a0cbb8fa896e15ce5ee99a94a2853"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/Image", using: :nounzip
    sha256 "0f17a1a3941f8827396265906e7b23cd70a85212caec47c20915abd5a45e19fe"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/Image-4k", using: :nounzip
    sha256 "97ba5f7832895f2de857375d3802b9b016976258583613c4dbd903c271792e87"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/initramfs.cpio.gz", using: :nounzip
    sha256 "1cac59f3a8bcf52a2b6b2d5769bf94dc237ec16c8b54df50686b4612bbe7bfef"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/features", using: :nounzip
    sha256 "02693b8b6c099e10fdb7a092394102ee92971ce1e39d0d6e5327ff8be1d0ee74"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/config", using: :nounzip
    sha256 "a70b9ee01f841c87eaa8270977db69fb3c2c9db8bc92aeb1f88c073c710eb3b0"
  end

  resource "wmd-ccwrap-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/wmd-ccwrap-linux-arm64", using: :nounzip
    sha256 "c066851318b1d9f292fa848a04b0771295dd6f0eac5c866af53166b7dc72f9f8"
  end

  resource "wmd-ccshim-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/wmd-ccshim-linux-arm64", using: :nounzip
    sha256 "24d8a1a0b4da43a1ecf2e1426fb9761b266395b21d6639c8be5ffb258cb45117"
  end

  resource "ccache-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/ccache-linux-arm64", using: :nounzip
    sha256 "47f20c5b7cfc04da8deda7a7787f5565f500a9885448752bdb59b7dc8d98d575"
  end

  resource "ccache-LICENSE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/ccache-LICENSE.txt", using: :nounzip
    sha256 "53c0ac34e61c628ee04b794f530be732b6181f5571f52a8aed447a3e41a6ccde"
  end

  resource "ccache-SOURCE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/ccache-SOURCE.txt", using: :nounzip
    sha256 "c96eacb4cd8a0808e98bef64f09ed1082be1cc7065b8d4496f396d85c9f4bde6"
  end

  resource "ccache-source.tar.xz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.48/ccache-source.tar.xz", using: :nounzip
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
    assert_match "build c35d2418", shell_output("#{bin}/wmd --version")
  end
end
