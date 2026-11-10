# wmd 0.1.10 (commit 7ce2ffac44fcbb270f4873be3953ae8ee77c9dd0), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/wmd", using: :nounzip
  version "0.1.10"
  sha256 "a6fdd5ea3d295056294c399df9ad66be483973afe0b580caac029387d85c4718"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/wmdd", using: :nounzip
    sha256 "1bbd86fb36991f8aee2925eb28a93cece0d346d2f5ba28fb920bed076d8404f7"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/wmd-run", using: :nounzip
    sha256 "9bc4113c19ce3358c7928ddf867d6b0bce37516838fff1d2f4e21c557ce20146"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/wmd-exe-stub", using: :nounzip
    sha256 "4297a274823327a5fcd7951e0090d788250b8b9e8d7e08dec37cbb9c8b1d6a8f"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/wmd-relay", using: :nounzip
    sha256 "44df41e42a6b26ab6bd90f48b6c3bbf0cfcba25deff9327a4aa612a0ab4eb728"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/vm.wasm", using: :nounzip
    sha256 "2fb89021d905d7af122696f0524b3698d3739cbaad6a47b3a1bfd6f464ecc3a2"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/Image", using: :nounzip
    sha256 "34ab14a11cf441ef38913b24fa640437454775fca463a6bc14aa18619b7aa621"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/Image-4k", using: :nounzip
    sha256 "f99947fab2659203e3a1cc4735898dcadd38ded1514032cdb9eeea98593b3043"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/initramfs.cpio.gz", using: :nounzip
    sha256 "ef75feb21aba0be6df11fd622321fd35ac04da662226f294a1e16cac80c5d7b6"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.10/config", using: :nounzip
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
    assert_match "build 7ce2ffac", shell_output("#{bin}/wmd --version")
  end
end
