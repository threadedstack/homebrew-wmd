# wmd 0.1.4 (commit 0e7c2e1edede6719feeda34181f4e6313324d319), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/wmd", using: :nounzip
  version "0.1.4"
  sha256 "88669a77006fe180561c200a2cd495fb1f0c94f23375410f11a3eab40f1f5cff"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/wmdd", using: :nounzip
    sha256 "c90b33eb001905e30473d7c7b87737e9f858860cd91669a512eebde29ca736de"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/wmd-run", using: :nounzip
    sha256 "ea41280f28f495baa242b252fc62a1d515d8eb492accb50d3e0175609c23162d"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/wmd-exe-stub", using: :nounzip
    sha256 "cd1eb5c109b05603b2d26cfa7002729f3c8dc021d1560e9270cf505c7926a28e"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/wmd-relay", using: :nounzip
    sha256 "0c8bbe1d524487677bbc66f41068703e8150b3e512acbe13feb5ab49fd73b0ba"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/vm.wasm", using: :nounzip
    sha256 "b646c16fa7010491c4552953a56cea556dba0a19fa4287f25a35ae4f1763090f"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/Image", using: :nounzip
    sha256 "89c0717c61c44389918bef60e4ab322907b4b4c0981769e71590208c9b656036"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/Image-4k", using: :nounzip
    sha256 "3690e0d6af5139d8c6a2a0de55c0ca8151b0561bb87a62cb4ea322f0338b0629"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/initramfs.cpio.gz", using: :nounzip
    sha256 "988ebc50cf2c1784b8534565a8142ad68f0cd88f9f7cb5664ef18aa24cafadef"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.4/config", using: :nounzip
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
    EOS
  end

  test do
    assert_match "build 0e7c2e1e", shell_output("#{bin}/wmd --version")
  end
end
