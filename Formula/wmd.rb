# wmd 0.1.21 (commit 19edd3aa9241c6cc1d2838a9a58a33b559703dc8), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/wmd", using: :nounzip
  version "0.1.21"
  sha256 "d46ce4925f7f574b3b594a706733ef6d12d1f0b528b377e6f8e45e973025fc2a"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/wmdd", using: :nounzip
    sha256 "85dc1c6991deb8f0aa0b21c63bee3eecb3c1f327dbefa59a4466c7e12633829a"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/wmd-run", using: :nounzip
    sha256 "4edb885fadd5a9493c373b00b49649b3a9c5b17e56afe95335d9e2d5e2517b57"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/wmd-exe-stub", using: :nounzip
    sha256 "05b2aad3952e71c2faa19c398539219494f3c9ef3f74fe2b9e63553a2c628c37"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/wmd-relay", using: :nounzip
    sha256 "c0c5737047592c7035bf000d63c528172bf8364f74745820d68ca1515600f547"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/vm.wasm", using: :nounzip
    sha256 "73bee71d7453a130f7991c7cead3bc12787050116217f635f9f523f584d2577d"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/Image", using: :nounzip
    sha256 "6952a8d4f1bafec9c3e3b17e2c4af20ab5de8a7086956d087979804be2a01353"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/Image-4k", using: :nounzip
    sha256 "47a1dcf06bcd1cc31fb4f02adbd1e035bc9e9a243fe57f3efd71b4a287581de2"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/initramfs.cpio.gz", using: :nounzip
    sha256 "efa6eb2338cb01d87eeebce8035ed7a26b00edcfc3b9db963b38272715d2ee9d"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.21/config", using: :nounzip
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
    assert_match "build 19edd3aa", shell_output("#{bin}/wmd --version")
  end
end
