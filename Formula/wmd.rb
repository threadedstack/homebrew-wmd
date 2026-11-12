# wmd 0.1.11 (commit b20b2063bd3915d14d43027934ca600d54221450), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/wmd", using: :nounzip
  version "0.1.11"
  sha256 "188aa5a44d177ff8ebfb74800ab9baa627979be4e0bcefe902e2cffb16617550"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/wmdd", using: :nounzip
    sha256 "84ecb313497683a7d4a5d824384b39d3ac517625a47f95c3a1642eae99996453"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/wmd-run", using: :nounzip
    sha256 "2417e94f72834fd4e3b777e760968704b9039b8ae65e6c158549afc9bcb07699"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/wmd-exe-stub", using: :nounzip
    sha256 "11f4bac07aff3b52200fc883ab00718d88a4570398cd13ba98b3d37329391773"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/wmd-relay", using: :nounzip
    sha256 "94a1b9827e75c8527fdde071117e5618485cae3bb505ddc6187a83545b0dbfe3"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/vm.wasm", using: :nounzip
    sha256 "97aeaeaea9acdb2b9e47861a4b8a51e873b336eb822e138520b8db650b036ad9"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/Image", using: :nounzip
    sha256 "34ab14a11cf441ef38913b24fa640437454775fca463a6bc14aa18619b7aa621"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/Image-4k", using: :nounzip
    sha256 "f99947fab2659203e3a1cc4735898dcadd38ded1514032cdb9eeea98593b3043"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/initramfs.cpio.gz", using: :nounzip
    sha256 "ef75feb21aba0be6df11fd622321fd35ac04da662226f294a1e16cac80c5d7b6"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.11/config", using: :nounzip
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
    assert_match "build b20b2063", shell_output("#{bin}/wmd --version")
  end
end
