# wmd 0.1.32 (commit 2411aec3acce27ade7841999fd09ef0b6427e8ab), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/wmd", using: :nounzip
  version "0.1.32"
  sha256 "9d701a323b49c6d56bd912918f0bdb60e58e624e7f356d750cc3af6430504bcf"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/wmdd", using: :nounzip
    sha256 "b20d7c7e08dc59ccab994afd55faf588e0acfaefed84abb334c10370294c6b3c"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/wmd-run", using: :nounzip
    sha256 "f6ae10bfecf1f542a8c4d33a4228b8d219ff0c78726f0e8e6899fc0851ccb784"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/wmd-exe-stub", using: :nounzip
    sha256 "d12c8c3dda84e9b500883cb7d1fb9a4f7fa96bc3fadd748a1aa51eb52d2f5374"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/wmd-relay", using: :nounzip
    sha256 "af45e4782d8658ae471740654428d7e6e510f2811f8d8b324cadc7da12600501"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/Image", using: :nounzip
    sha256 "daa4dc90fe59ceda984ba97342f0abab0a45e3ba1a14d361d142234347f5a9e4"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/Image-4k", using: :nounzip
    sha256 "284de4fdb2b7a25f4ecabd03f03aaa56c1d22f99082f6c5c2db2fb0b7c5a6c36"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/initramfs.cpio.gz", using: :nounzip
    sha256 "cef3a42510e38748c181c56165ad8b30520ec29fdb82f5822fdef0de3f3e5d02"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/features", using: :nounzip
    sha256 "02693b8b6c099e10fdb7a092394102ee92971ce1e39d0d6e5327ff8be1d0ee74"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.32/config", using: :nounzip
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
    assert_match "build 2411aec3", shell_output("#{bin}/wmd --version")
  end
end
