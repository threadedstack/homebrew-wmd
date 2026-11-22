# wmd 0.1.33 (commit e2ab9030a651b657f262d2deaf0c0a7c0589801f), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/wmd", using: :nounzip
  version "0.1.33"
  sha256 "31795d27c907949b0a5d01f8719773187912fbe8aad638bb24cc234e9ff2d823"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/wmdd", using: :nounzip
    sha256 "a30814e7cc00752fbe19049d826604ae6d5b6bae33259fda6e26381035a9ccb8"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/wmd-run", using: :nounzip
    sha256 "5a90e76edc113f92b5d259aea46123de4a778329df735b41ab8e6affa1b708ef"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/wmd-exe-stub", using: :nounzip
    sha256 "1a9ccd33752a2bf52ebfb8492563b805e7eabfb61ac60dfb054482a8776ae6a8"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/wmd-relay", using: :nounzip
    sha256 "deb6412fc09db4d3f933cf7f3d2324ffa041ec6300c002856af41648c04d93ef"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/Image", using: :nounzip
    sha256 "daa4dc90fe59ceda984ba97342f0abab0a45e3ba1a14d361d142234347f5a9e4"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/Image-4k", using: :nounzip
    sha256 "284de4fdb2b7a25f4ecabd03f03aaa56c1d22f99082f6c5c2db2fb0b7c5a6c36"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/initramfs.cpio.gz", using: :nounzip
    sha256 "cef3a42510e38748c181c56165ad8b30520ec29fdb82f5822fdef0de3f3e5d02"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/features", using: :nounzip
    sha256 "02693b8b6c099e10fdb7a092394102ee92971ce1e39d0d6e5327ff8be1d0ee74"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/config", using: :nounzip
    sha256 "a70b9ee01f841c87eaa8270977db69fb3c2c9db8bc92aeb1f88c073c710eb3b0"
  end

  resource "wmd-ccwrap-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/wmd-ccwrap-linux-arm64", using: :nounzip
    sha256 "c066851318b1d9f292fa848a04b0771295dd6f0eac5c866af53166b7dc72f9f8"
  end

  resource "wmd-ccshim-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/wmd-ccshim-linux-arm64", using: :nounzip
    sha256 "24d8a1a0b4da43a1ecf2e1426fb9761b266395b21d6639c8be5ffb258cb45117"
  end

  resource "ccache-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/ccache-linux-arm64", using: :nounzip
    sha256 "47f20c5b7cfc04da8deda7a7787f5565f500a9885448752bdb59b7dc8d98d575"
  end

  resource "ccache-LICENSE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/ccache-LICENSE.txt", using: :nounzip
    sha256 "53c0ac34e61c628ee04b794f530be732b6181f5571f52a8aed447a3e41a6ccde"
  end

  resource "ccache-SOURCE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/ccache-SOURCE.txt", using: :nounzip
    sha256 "db62f838a26a4baf2ce4a329843f638d1790c6c15ec1a908dba723335c152bde"
  end

  resource "ccache-source.tar.xz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.33/ccache-source.tar.xz", using: :nounzip
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
    assert_match "build e2ab9030", shell_output("#{bin}/wmd --version")
  end
end
