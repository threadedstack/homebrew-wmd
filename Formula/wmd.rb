# wmd 0.1.26 (commit 604e733e21a100f0adc1b37b8ae888fa05c297fb), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/wmd", using: :nounzip
  version "0.1.26"
  sha256 "7a43087808668c7383e5aee770169e8335b6a6988ba59c4585fe3496cddf65d5"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/wmdd", using: :nounzip
    sha256 "bf09d8c50c783a12b322f23d55ebd13167ec1bdacaf6fe2a999e4df8e91e94b5"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/wmd-run", using: :nounzip
    sha256 "28fdd8b5a61c90f656a966d0307005557108cbfde3f0acc792088edbfd6f4112"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/wmd-exe-stub", using: :nounzip
    sha256 "0f0e053d27ec91eb5f76982eea9b6da3cab86aff29b6ad2c405cda8d75893077"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/wmd-relay", using: :nounzip
    sha256 "f2efb67c75194d097c7add3cebdb7b5822c1ede03437e7e576e93c8e1be5d598"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/vm.wasm", using: :nounzip
    sha256 "4292c9a5981dda7215acd66ee6023cacd4bd502b379b469ef9a3bb606eb1309d"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/Image", using: :nounzip
    sha256 "6952a8d4f1bafec9c3e3b17e2c4af20ab5de8a7086956d087979804be2a01353"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/Image-4k", using: :nounzip
    sha256 "47a1dcf06bcd1cc31fb4f02adbd1e035bc9e9a243fe57f3efd71b4a287581de2"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/initramfs.cpio.gz", using: :nounzip
    sha256 "efa6eb2338cb01d87eeebce8035ed7a26b00edcfc3b9db963b38272715d2ee9d"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.26/config", using: :nounzip
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
    assert_match "build 604e733e", shell_output("#{bin}/wmd --version")
  end
end
