# wmd 0.1.8 (commit d26a2bb56dc34e8945e945b44c8932131af149ff), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/wmd", using: :nounzip
  version "0.1.8"
  sha256 "fd7731b4467735af6272b9ee72a60df4021bd121398c1d82b60fc474f1f8f557"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/wmdd", using: :nounzip
    sha256 "4b9134e41551f6374d8918544f74c2b5631ff707bbf3b49b7b68c350c640f72b"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/wmd-run", using: :nounzip
    sha256 "6af5acbbd4a784226949e2ddf990e3f1e44792434ae15daf0e518af3d1456bf3"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/wmd-exe-stub", using: :nounzip
    sha256 "5c84df2574334bdecb81933f69a069ac08b9b8187a564f3c13f3a9c194fd2475"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/wmd-relay", using: :nounzip
    sha256 "ba181cd44f14369c6f28dd7c88e830d2da8900395571bacb61f68629e6a10b09"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/vm.wasm", using: :nounzip
    sha256 "2fb89021d905d7af122696f0524b3698d3739cbaad6a47b3a1bfd6f464ecc3a2"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/Image", using: :nounzip
    sha256 "5acee55f16b51e01cbb886e859087667a6a8790f4cb49043f222a1043b57452f"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/Image-4k", using: :nounzip
    sha256 "b522d520fe7ff2a5d256272528ff9a08cb14e3374a1406edbd86c081744e029a"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/initramfs.cpio.gz", using: :nounzip
    sha256 "ef75feb21aba0be6df11fd622321fd35ac04da662226f294a1e16cac80c5d7b6"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.8/config", using: :nounzip
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
    assert_match "build d26a2bb5", shell_output("#{bin}/wmd --version")
  end
end
