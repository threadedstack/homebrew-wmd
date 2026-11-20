# wmd 0.1.28 (commit 63d834daafd7ec45b1093ff76ec897bbdbc7c339), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/wmd", using: :nounzip
  version "0.1.28"
  sha256 "d568a269b374175e4de679ee634f98506f89bc6b0714cf2d9e0f384d6703c2f0"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/wmdd", using: :nounzip
    sha256 "29e8305d278d5afe9bb57970aca9b0df356b804906a2e4959fceb5633f16f938"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/wmd-run", using: :nounzip
    sha256 "9ce27037fe0d1212dbd4e4201cf9d42b5a8ba6e0250aebbb568001f83adbec12"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/wmd-exe-stub", using: :nounzip
    sha256 "5271edfbcfe45357ceecd7b6ca40a0bf4a6515b32bddcf0f6524ee5f774732e0"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/wmd-relay", using: :nounzip
    sha256 "010b3c98e453d9845fdcb81d7bcc1656702d0735bd3aa675aeb33c1db7c29ff5"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/Image", using: :nounzip
    sha256 "6952a8d4f1bafec9c3e3b17e2c4af20ab5de8a7086956d087979804be2a01353"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/Image-4k", using: :nounzip
    sha256 "47a1dcf06bcd1cc31fb4f02adbd1e035bc9e9a243fe57f3efd71b4a287581de2"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/initramfs.cpio.gz", using: :nounzip
    sha256 "efa6eb2338cb01d87eeebce8035ed7a26b00edcfc3b9db963b38272715d2ee9d"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.28/config", using: :nounzip
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
    assert_match "build 63d834da", shell_output("#{bin}/wmd --version")
  end
end
