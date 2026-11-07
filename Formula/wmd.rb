# wmd 0.1.3 (commit b60da4b3a46e6e0fbc70978507b9e0fba0ac8bf0), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/wmd", using: :nounzip
  version "0.1.3"
  sha256 "5f1fe24b76e09de610470949c3b0ee0b02da199e74b86d6fa925e3223cd249d0"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/wmdd", using: :nounzip
    sha256 "6256e4c17a9cda9b0f29071f0bfd1844a7850b802de76d5b548f51e43862d776"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/wmd-run", using: :nounzip
    sha256 "6d76003a1ab66eb6f090e4810ca327d8d12ddeb15df327ac5a545cecd036fbb5"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/wmd-exe-stub", using: :nounzip
    sha256 "d44792fd8a3531ef484beab10f8f6bd2e99ce1cfd01bd7f8082c6be4c16244d7"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/wmd-relay", using: :nounzip
    sha256 "6bddb921e06ac37425acacab0bc82d8ffadcf7a28381bd1eb9691aafff3a15c7"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/vm.wasm", using: :nounzip
    sha256 "b646c16fa7010491c4552953a56cea556dba0a19fa4287f25a35ae4f1763090f"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/Image", using: :nounzip
    sha256 "89c0717c61c44389918bef60e4ab322907b4b4c0981769e71590208c9b656036"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/Image-4k", using: :nounzip
    sha256 "3690e0d6af5139d8c6a2a0de55c0ca8151b0561bb87a62cb4ea322f0338b0629"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/initramfs.cpio.gz", using: :nounzip
    sha256 "988ebc50cf2c1784b8534565a8142ad68f0cd88f9f7cb5664ef18aa24cafadef"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.3/config", using: :nounzip
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
    assert_match "build b60da4b3", shell_output("#{bin}/wmd --version")
  end
end
