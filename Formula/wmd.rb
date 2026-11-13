# wmd 0.1.17 (commit fa2b21cfd0fd0bf679498e6feeefc26c33f17372), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/wmd", using: :nounzip
  version "0.1.17"
  sha256 "f05f1f64d7910387839a516d697da843319d39a8090d1eed2f02141351e7fe7d"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/wmdd", using: :nounzip
    sha256 "53e8587de512c8b55677680e759e33ef0d732401129e6aec9d0cc51deb3614f1"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/wmd-run", using: :nounzip
    sha256 "192b17363b051ff246275c72c9f28dbc5188a9bcd83503f91bb95994adae778e"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/wmd-exe-stub", using: :nounzip
    sha256 "8ef8848708438c200ea96f7442ca70df750b9edcf462f9b95c5e2176549fc4a6"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/wmd-relay", using: :nounzip
    sha256 "74cd9c13fabd78db425b9be7cad36708d73cd90e49ffd5623930d6f6e72f3aae"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/vm.wasm", using: :nounzip
    sha256 "2504f4071537e205d78766f2c84219fe49ea4709314becff3a314765733e7fdf"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/Image", using: :nounzip
    sha256 "a6b3209cf69d5bc1dacf0f3ed67f92c535dbb4108d67b47091c2aef87c6d7b04"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/Image-4k", using: :nounzip
    sha256 "8ff6e338a0b42d9f774b35423e0e7f9d7f779c635446e8de2a3beb83d3518f8a"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/initramfs.cpio.gz", using: :nounzip
    sha256 "a2260db90e5d8acdf12a2123f696b4512a1465856d5653e20a85504069a3480c"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.17/config", using: :nounzip
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
      After an upgrade the daemon restarts into the new version by itself once no
      container runs. Coming from 0.1.15 or older, run `wmd setup` once to restart it.
    EOS
  end

  test do
    assert_match "build fa2b21cf", shell_output("#{bin}/wmd --version")
  end
end
