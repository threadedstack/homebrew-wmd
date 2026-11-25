# wmd 0.1.50 (commit ce804752cc91e7b05c63ce39a3bdf9713ccfd6b9), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/wmd", using: :nounzip
  version "0.1.50"
  sha256 "5f87c1544dc285c74cfceb42524b9c7a6f3da4e9d880fff5765a82da96202268"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/wmdd", using: :nounzip
    sha256 "e4b8f585b11cd116c3db5bd830589bbd50f89868f574fe9a88b093f23768a03f"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/wmd-run", using: :nounzip
    sha256 "9b92c6b8d7c12f714b49c33fd440982391b0c093905b8c6d66de99dcf75101d4"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/wmd-exe-stub", using: :nounzip
    sha256 "d5487f74892ea8bc4000fbda042e4e4d5344db7dbadab9141746ab0761694104"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/wmd-relay", using: :nounzip
    sha256 "c7c649b13c44127d492c8444420dbf7086f0f6590db894d2260bdb7798e89996"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/vm.wasm", using: :nounzip
    sha256 "ec00c59a70add068305168952885ac3c637b0bd274c1c7a7c28aac9e24fcc3de"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/Image", using: :nounzip
    sha256 "b7a8843d3469e2f5c32973ce2e6d663f90e07099ed2e9e9aee2ceac0e6a0685b"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/Image-4k", using: :nounzip
    sha256 "55ab90773d080416f1539ae2caac0a49bb98e2bb34ce9384849725fb8e601551"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/initramfs.cpio.gz", using: :nounzip
    sha256 "ac7c0fc194b059579943c3d8ceaa0757c3e3e248231c2ad779260e97d5084cd3"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/features", using: :nounzip
    sha256 "4dc6f2a114c7c87a67eb9f0fe53c52b6b8128bb30830a6be498432a3701587f4"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/config", using: :nounzip
    sha256 "0b5d7b47627a4b2c0fae2f2119f3f6ec6f15038c2d6a4068bda50f762d0c33c0"
  end

  resource "wmd-ccwrap-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/wmd-ccwrap-linux-arm64", using: :nounzip
    sha256 "2a9ceca781090c2158ca040b4c8ef11e8a44415ab1fc1e55c5a5bbcaebfdf848"
  end

  resource "wmd-ccshim-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/wmd-ccshim-linux-arm64", using: :nounzip
    sha256 "82ac9102965fac03e9ec9f98978945608f7bfab984a8e50ff5e6017af15530ec"
  end

  resource "ccache-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/ccache-linux-arm64", using: :nounzip
    sha256 "47f20c5b7cfc04da8deda7a7787f5565f500a9885448752bdb59b7dc8d98d575"
  end

  resource "ccache-LICENSE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/ccache-LICENSE.txt", using: :nounzip
    sha256 "53c0ac34e61c628ee04b794f530be732b6181f5571f52a8aed447a3e41a6ccde"
  end

  resource "ccache-SOURCE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/ccache-SOURCE.txt", using: :nounzip
    sha256 "478cefde58174487b95ffb25d11df110619c34e123710c52972d310a7bd4c8fc"
  end

  resource "ccache-source.tar.xz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.50/ccache-source.tar.xz", using: :nounzip
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
    assert_match "build ce804752", shell_output("#{bin}/wmd --version")
  end
end
