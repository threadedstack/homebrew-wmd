# wmd 0.1.61 (commit 021fe8c375cb3c46735f03ac9695c7caa54636e4), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/wmd", using: :nounzip
  version "0.1.61"
  sha256 "667d18308d2b9629ec27d54665ef1b8013ba1d6ad98884735639ab9e3cb52508"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/wmdd", using: :nounzip
    sha256 "97076aafe3ad392c06578491588bc1f4cc3676165c34d07854fd0c9b8ccc5b34"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/wmd-run", using: :nounzip
    sha256 "969c3c3f796852cd31740a1bf1ce98d901c7c2dcf76c9eca6766fbcb716a5245"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/wmd-exe-stub", using: :nounzip
    sha256 "7b0af415baaa4c6c5e52891bb9e72ca125f772a5976b74c91f80cbc48a70b0b2"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/wmd-relay", using: :nounzip
    sha256 "22e8186adb18c5a565aaa142ee44d44e54bf13d21f2fd9493788a5bdeab44c2d"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/vm.wasm", using: :nounzip
    sha256 "185d7226e24fd6bc18c2dfe3ff77be3e7010de5b5d54e064fbe0dbd0eb319abb"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/Image", using: :nounzip
    sha256 "b7a8843d3469e2f5c32973ce2e6d663f90e07099ed2e9e9aee2ceac0e6a0685b"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/Image-4k", using: :nounzip
    sha256 "55ab90773d080416f1539ae2caac0a49bb98e2bb34ce9384849725fb8e601551"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/initramfs.cpio.gz", using: :nounzip
    sha256 "ac7c0fc194b059579943c3d8ceaa0757c3e3e248231c2ad779260e97d5084cd3"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/features", using: :nounzip
    sha256 "4dc6f2a114c7c87a67eb9f0fe53c52b6b8128bb30830a6be498432a3701587f4"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/config", using: :nounzip
    sha256 "0b5d7b47627a4b2c0fae2f2119f3f6ec6f15038c2d6a4068bda50f762d0c33c0"
  end

  resource "wmd-ccwrap-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/wmd-ccwrap-linux-arm64", using: :nounzip
    sha256 "2a9ceca781090c2158ca040b4c8ef11e8a44415ab1fc1e55c5a5bbcaebfdf848"
  end

  resource "wmd-ccshim-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/wmd-ccshim-linux-arm64", using: :nounzip
    sha256 "82ac9102965fac03e9ec9f98978945608f7bfab984a8e50ff5e6017af15530ec"
  end

  resource "ccache-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/ccache-linux-arm64", using: :nounzip
    sha256 "47f20c5b7cfc04da8deda7a7787f5565f500a9885448752bdb59b7dc8d98d575"
  end

  resource "ccache-LICENSE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/ccache-LICENSE.txt", using: :nounzip
    sha256 "53c0ac34e61c628ee04b794f530be732b6181f5571f52a8aed447a3e41a6ccde"
  end

  resource "ccache-SOURCE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/ccache-SOURCE.txt", using: :nounzip
    sha256 "129918bc7b800beff3c89fbb3383ffc046e4da17eb04bfa147441a023e744de9"
  end

  resource "ccache-source.tar.xz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.61/ccache-source.tar.xz", using: :nounzip
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
    assert_match "build 021fe8c3", shell_output("#{bin}/wmd --version")
  end
end
