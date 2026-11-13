# wmd 0.1.14 (commit 1fe3dd6c164b913eecd21d64097b285c51fc1401), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/wmd", using: :nounzip
  version "0.1.14"
  sha256 "b39de6b8135f9fc5aff6085ba48bdaad9031a1652335852cfbdc59b3e2fa6fce"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/wmdd", using: :nounzip
    sha256 "846ec466adfea9e7df31d850f617a762ee83cd6030057684fa41cee555fbe00c"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/wmd-run", using: :nounzip
    sha256 "5e3703e668b88e5db5d11a433fa31e67d29746ec7360260de0728dfd7d2201c6"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/wmd-exe-stub", using: :nounzip
    sha256 "b9514533d2122d82d88716d0ddf2f28c87809244e2bdfeb46f3297b49571c50b"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/wmd-relay", using: :nounzip
    sha256 "4d9c23e7851e6eaecf119727c42188824e9ee6d51d92fecf57e5a3a9f37e1183"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/vm.wasm", using: :nounzip
    sha256 "f7affc474658fdfdc50e96c29a224eed1520ea69b426d6427fbc058eb141091a"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/Image", using: :nounzip
    sha256 "a6b3209cf69d5bc1dacf0f3ed67f92c535dbb4108d67b47091c2aef87c6d7b04"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/Image-4k", using: :nounzip
    sha256 "8ff6e338a0b42d9f774b35423e0e7f9d7f779c635446e8de2a3beb83d3518f8a"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/initramfs.cpio.gz", using: :nounzip
    sha256 "a2260db90e5d8acdf12a2123f696b4512a1465856d5653e20a85504069a3480c"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.14/config", using: :nounzip
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
    assert_match "build 1fe3dd6c", shell_output("#{bin}/wmd --version")
  end
end
