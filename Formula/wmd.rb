# wmd 0.1.27 (commit 597e6b823e6b27e50f6a77cfd62cbfa4a7b0aeeb), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/wmd", using: :nounzip
  version "0.1.27"
  sha256 "3a1a9413ee86487593ea1f6bd92f4731c01f47c316a5f309b03a51db20cfea82"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/wmdd", using: :nounzip
    sha256 "326e19282a7e02b4bab5ce9adf99b5d9c76f2e097bbe155fed8089494ca6e99c"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/wmd-run", using: :nounzip
    sha256 "7f9ad20828273a350f5431ce93a9b7539c3783490b961e3e07c627226e716cc4"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/wmd-exe-stub", using: :nounzip
    sha256 "766e98148b744f0d35e3520dcfba674284941b078d99e8669d8b63d19b04745a"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/wmd-relay", using: :nounzip
    sha256 "df6b851bdbee5da39720ccc150f4732c7d34d2919cb01d2b33c54a5d1814cc90"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/Image", using: :nounzip
    sha256 "6952a8d4f1bafec9c3e3b17e2c4af20ab5de8a7086956d087979804be2a01353"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/Image-4k", using: :nounzip
    sha256 "47a1dcf06bcd1cc31fb4f02adbd1e035bc9e9a243fe57f3efd71b4a287581de2"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/initramfs.cpio.gz", using: :nounzip
    sha256 "efa6eb2338cb01d87eeebce8035ed7a26b00edcfc3b9db963b38272715d2ee9d"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.27/config", using: :nounzip
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
    assert_match "build 597e6b82", shell_output("#{bin}/wmd --version")
  end
end
