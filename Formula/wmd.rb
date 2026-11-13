# wmd 0.1.16 (commit 5700f4936de2f32edebd7f0fba2e15cd98c145a5), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/wmd", using: :nounzip
  version "0.1.16"
  sha256 "06de2787aa13f6956694f9a34199ba2b539346490e9ed467af858aecdc8d022d"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/wmdd", using: :nounzip
    sha256 "4521d785d832e1e1f59a3015f355d5545366076017419b9187d26eaa1066ceb3"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/wmd-run", using: :nounzip
    sha256 "21a6136fe56e2a52d82cd14800995a28ed221b323c32d4e6109ff0e7cb9b49bb"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/wmd-exe-stub", using: :nounzip
    sha256 "7b1e9bf0275d05c02db3f358be5637cf35bbc8904acda37d1c060eeebf011fea"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/wmd-relay", using: :nounzip
    sha256 "fd5ed64fe8f31c5793afd4a0aeeb1f95c1372b0593928a1bd3659ada0b498e8b"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/vm.wasm", using: :nounzip
    sha256 "f7affc474658fdfdc50e96c29a224eed1520ea69b426d6427fbc058eb141091a"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/Image", using: :nounzip
    sha256 "a6b3209cf69d5bc1dacf0f3ed67f92c535dbb4108d67b47091c2aef87c6d7b04"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/Image-4k", using: :nounzip
    sha256 "8ff6e338a0b42d9f774b35423e0e7f9d7f779c635446e8de2a3beb83d3518f8a"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/initramfs.cpio.gz", using: :nounzip
    sha256 "a2260db90e5d8acdf12a2123f696b4512a1465856d5653e20a85504069a3480c"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.16/config", using: :nounzip
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
    assert_match "build 5700f493", shell_output("#{bin}/wmd --version")
  end
end
