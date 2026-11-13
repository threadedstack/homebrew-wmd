# wmd 0.1.15 (commit b591b664091fb3105d0cd0f341c56fe04131ff2c), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/wmd", using: :nounzip
  version "0.1.15"
  sha256 "55dd07c6c56b2ccec40606b315aaafcdf39e7139740c7baa8d76ee496144f8a6"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/wmdd", using: :nounzip
    sha256 "5720330b7a9c48652fe681e14cc053b4dcc98cda6d4a84633b0c6f96ddddcf54"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/wmd-run", using: :nounzip
    sha256 "92ec42828f9487e962e9722808d50457c9c36bc8dcd7a554f1e64717a960ca30"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/wmd-exe-stub", using: :nounzip
    sha256 "a82f2ed08c7a72a23de34d8e79016fa75a6482149a6385d216ca81273d1dff9c"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/wmd-relay", using: :nounzip
    sha256 "d43725bd7abacf295fbf4464721d8011187e4c498b7bf2da3bcc3ae19955bb55"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/vm.wasm", using: :nounzip
    sha256 "f7affc474658fdfdc50e96c29a224eed1520ea69b426d6427fbc058eb141091a"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/Image", using: :nounzip
    sha256 "a6b3209cf69d5bc1dacf0f3ed67f92c535dbb4108d67b47091c2aef87c6d7b04"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/Image-4k", using: :nounzip
    sha256 "8ff6e338a0b42d9f774b35423e0e7f9d7f779c635446e8de2a3beb83d3518f8a"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/initramfs.cpio.gz", using: :nounzip
    sha256 "a2260db90e5d8acdf12a2123f696b4512a1465856d5653e20a85504069a3480c"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.15/config", using: :nounzip
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
    assert_match "build b591b664", shell_output("#{bin}/wmd --version")
  end
end
