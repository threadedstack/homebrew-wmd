# wmd 0.1.49 (commit 6472edd8cc5495ced418b3d8760fdc0ee77c5d64), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/wmd", using: :nounzip
  version "0.1.49"
  sha256 "1d652e71875de39c4b42c792dde36667f57f177ac293dbf35ad4e4b12a060074"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/wmdd", using: :nounzip
    sha256 "c03d8905663a963a1f74ec25b24dd80da3b919f721751eaa5015c4e2266ace55"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/wmd-run", using: :nounzip
    sha256 "c802a483e3f03ed6c931bd5ef3d6c439005f006beb0e949f8cfdbc2dc26aac5f"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/wmd-exe-stub", using: :nounzip
    sha256 "096631d0057dd1a04c7be8f982259a1183cf82702ba6af740dd560c5fb141cfc"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/wmd-relay", using: :nounzip
    sha256 "78fa1e5ccd7a3af6e885585e6bda45dab9326451dcdc6e84d7d5cefdc4618166"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/vm.wasm", using: :nounzip
    sha256 "ec00c59a70add068305168952885ac3c637b0bd274c1c7a7c28aac9e24fcc3de"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/Image", using: :nounzip
    sha256 "b7a8843d3469e2f5c32973ce2e6d663f90e07099ed2e9e9aee2ceac0e6a0685b"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/Image-4k", using: :nounzip
    sha256 "55ab90773d080416f1539ae2caac0a49bb98e2bb34ce9384849725fb8e601551"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/initramfs.cpio.gz", using: :nounzip
    sha256 "ac7c0fc194b059579943c3d8ceaa0757c3e3e248231c2ad779260e97d5084cd3"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/features", using: :nounzip
    sha256 "4dc6f2a114c7c87a67eb9f0fe53c52b6b8128bb30830a6be498432a3701587f4"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/config", using: :nounzip
    sha256 "0b5d7b47627a4b2c0fae2f2119f3f6ec6f15038c2d6a4068bda50f762d0c33c0"
  end

  resource "wmd-ccwrap-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/wmd-ccwrap-linux-arm64", using: :nounzip
    sha256 "2a9ceca781090c2158ca040b4c8ef11e8a44415ab1fc1e55c5a5bbcaebfdf848"
  end

  resource "wmd-ccshim-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/wmd-ccshim-linux-arm64", using: :nounzip
    sha256 "82ac9102965fac03e9ec9f98978945608f7bfab984a8e50ff5e6017af15530ec"
  end

  resource "ccache-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/ccache-linux-arm64", using: :nounzip
    sha256 "47f20c5b7cfc04da8deda7a7787f5565f500a9885448752bdb59b7dc8d98d575"
  end

  resource "ccache-LICENSE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/ccache-LICENSE.txt", using: :nounzip
    sha256 "53c0ac34e61c628ee04b794f530be732b6181f5571f52a8aed447a3e41a6ccde"
  end

  resource "ccache-SOURCE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/ccache-SOURCE.txt", using: :nounzip
    sha256 "ebf02de5a346a395be7bf6ed7474d78e0b78f1f43523b7f84e0152ff85bbc597"
  end

  resource "ccache-source.tar.xz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.49/ccache-source.tar.xz", using: :nounzip
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
    assert_match "build 6472edd8", shell_output("#{bin}/wmd --version")
  end
end
