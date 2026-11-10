# wmd 0.1.9 (commit 3f722e5c12840f6fda9b21a29bc7f1af578681fd), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/wmd", using: :nounzip
  version "0.1.9"
  sha256 "fbf94b633ba2d3ecbb648624d62840fc732f5a5549d984995327d9c0589ad525"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/wmdd", using: :nounzip
    sha256 "b31925bbd7e1a484981f25990e30c4001837c04779968792b05d2c06ad787b1f"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/wmd-run", using: :nounzip
    sha256 "d40c9676d88ec671221a97b8ccc251914610093456629207e318be85fe70844c"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/wmd-exe-stub", using: :nounzip
    sha256 "35a22c94b351496e130f602fbb76790235c2b796b233db9797dff1e740bf252d"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/wmd-relay", using: :nounzip
    sha256 "1304414a1b77151a013d34255e9758ff06ce3fa4bd02fa0b9e8d48ae458417ef"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/vm.wasm", using: :nounzip
    sha256 "2fb89021d905d7af122696f0524b3698d3739cbaad6a47b3a1bfd6f464ecc3a2"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/Image", using: :nounzip
    sha256 "34ab14a11cf441ef38913b24fa640437454775fca463a6bc14aa18619b7aa621"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/Image-4k", using: :nounzip
    sha256 "f99947fab2659203e3a1cc4735898dcadd38ded1514032cdb9eeea98593b3043"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/initramfs.cpio.gz", using: :nounzip
    sha256 "ef75feb21aba0be6df11fd622321fd35ac04da662226f294a1e16cac80c5d7b6"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.9/config", using: :nounzip
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
    assert_match "build 3f722e5c", shell_output("#{bin}/wmd --version")
  end
end
