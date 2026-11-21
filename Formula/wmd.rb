# wmd 0.1.30 (commit 6479598e561626f863fd9aa62fbbfc470123487f), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/wmd", using: :nounzip
  version "0.1.30"
  sha256 "0c5ef03b73bcbdca624e19c32661a9d0316dda9d56024f84a98f4dc5ad5eae9b"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/wmdd", using: :nounzip
    sha256 "3d244257571fdfed51c735927341dd5acfe76ecdec5a13d43ee932ae557a4f9b"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/wmd-run", using: :nounzip
    sha256 "046fe1a6f37dd66ae69e965251889e852f4678c5244c34971a360a33e8f153aa"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/wmd-exe-stub", using: :nounzip
    sha256 "866fbde963e51aa55e4d9d06a2b83a377ac44458cf01e394585ea141ca4a4812"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/wmd-relay", using: :nounzip
    sha256 "5aa8550ae4d5166392e819d59d9773bd3dcc0c245d5d1397e87a3363de864885"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/Image", using: :nounzip
    sha256 "a90b4ca77b6f4a7d9cad7eeef1c040cbd97240232c3007a6426cf280a7fab51e"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/Image-4k", using: :nounzip
    sha256 "e6958465a3fce33bfd1430605ebfc4b2d9dae2a8093361bee9428d22ebef9654"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/initramfs.cpio.gz", using: :nounzip
    sha256 "f5b570d3c3e7f8d6d5bba056532e979ccb0fea9c01c52d9eef26fe02acd9d039"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/features", using: :nounzip
    sha256 "02693b8b6c099e10fdb7a092394102ee92971ce1e39d0d6e5327ff8be1d0ee74"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.30/config", using: :nounzip
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
    assert_match "build 6479598e", shell_output("#{bin}/wmd --version")
  end
end
