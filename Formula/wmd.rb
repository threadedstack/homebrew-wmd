# wmd 0.1.29 (commit 965e79897093369d1dd263b5588efc3619d47c7b), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/wmd", using: :nounzip
  version "0.1.29"
  sha256 "450704bca3272f6030a18aed654f343696168fbb095eeb8a70398cc1e765d2d8"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/wmdd", using: :nounzip
    sha256 "44ae0bf04f61945b70ca3a8dd0316221ddd58f41ffcaae2430424eb9e5f19fa1"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/wmd-run", using: :nounzip
    sha256 "bb30060b32c374eb12aac3017ee621807e703f8f41fa3b25b645562f3540d3d5"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/wmd-exe-stub", using: :nounzip
    sha256 "c3afe4abc3d299ab106ec0c5e9bb02b9d107224e543e74edbc960c70a9a12ddc"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/wmd-relay", using: :nounzip
    sha256 "bd739c59ed4dbe3b42d3e29e3e2d384e6703b2d11b8cb05455f34024cf7def6e"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/Image", using: :nounzip
    sha256 "52986d5f07de886c57d8d083c26f5af0877cc9faa096d0dbdb68c859d2acd52a"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/Image-4k", using: :nounzip
    sha256 "497815d8a0afc7afbef2bd574c24e96d3c6724aef1bae9617016c0c8a99846fc"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/initramfs.cpio.gz", using: :nounzip
    sha256 "ec74f162155e20aabb6fe1f3bea592c03a85f07bee8844fd302a5285b20b4de1"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/features", using: :nounzip
    sha256 "02693b8b6c099e10fdb7a092394102ee92971ce1e39d0d6e5327ff8be1d0ee74"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.29/config", using: :nounzip
    sha256 "a70b9ee01f841c87eaa8270977db69fb3c2c9db8bc92aeb1f88c073c710eb3b0"
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
      If you ran it with wmd 0.1.7 or older, run it once more: those set the daemon up
      to start from a folder that `brew upgrade` deletes.
      After an upgrade the daemon restarts into the new version by itself once no
      container runs. Coming from 0.1.15 or older, run `wmd setup` once to restart it.
    EOS
  end

  test do
    assert_match "build 965e7989", shell_output("#{bin}/wmd --version")
  end
end
