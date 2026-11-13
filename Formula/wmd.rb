# wmd 0.1.12 (commit 7ee6237bcee18c5d8a28e8a172838c85802d4602), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/wmd", using: :nounzip
  version "0.1.12"
  sha256 "12480c42fd8f6b0202fa36d24299d8fce5d8d27607c3d6309f8e14e15306d30d"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/wmdd", using: :nounzip
    sha256 "f085306a75eab7d6d16e95dcf6a1c4e307822b80829a826eaed49f3b135f1b07"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/wmd-run", using: :nounzip
    sha256 "9fdbdd8443d1b1d041596962ffd88b4a86a9b933f279320bff44d52e909fa3b5"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/wmd-exe-stub", using: :nounzip
    sha256 "342803b6115a413c2ec1d7ca06a8f998423bb2406fc6a90b5a3177af20cca179"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/wmd-relay", using: :nounzip
    sha256 "a6d97ea3f8c0edda78584796d9c3320d4ce84cddd6d18cd3df6f60cc78ac23b3"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/vm.wasm", using: :nounzip
    sha256 "f7affc474658fdfdc50e96c29a224eed1520ea69b426d6427fbc058eb141091a"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/Image", using: :nounzip
    sha256 "a6b3209cf69d5bc1dacf0f3ed67f92c535dbb4108d67b47091c2aef87c6d7b04"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/Image-4k", using: :nounzip
    sha256 "8ff6e338a0b42d9f774b35423e0e7f9d7f779c635446e8de2a3beb83d3518f8a"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/initramfs.cpio.gz", using: :nounzip
    sha256 "38101c6b9bd0f8ec8f1b0aea99046d80d36669052794fa8e0368b6a1743285c1"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.12/config", using: :nounzip
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
      If you ran it with wmd 0.1.7 or older, run it once more: those set the daemon up
      to start from a folder that `brew upgrade` deletes.
    EOS
  end

  test do
    assert_match "build 7ee6237b", shell_output("#{bin}/wmd --version")
  end
end
