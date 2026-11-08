# wmd 0.1.7 (commit 6cc9585dfb31140fce0ac7ba45332ecf4f1b35be), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/wmd", using: :nounzip
  version "0.1.7"
  sha256 "a0020d849710d56cab38b49554b6e0ef27d6a84338633221997b438a39fb0f1a"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/wmdd", using: :nounzip
    sha256 "8c8e9b038a0c5eb2a044fa6bff95749a60cdedc2f943a13c009cf7cb64f3e666"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/wmd-run", using: :nounzip
    sha256 "d27a22257a8482fa96da160aefee87208b73ab8926c9b92fc3dc308a165d7ac4"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/wmd-exe-stub", using: :nounzip
    sha256 "d695eaf84bca079dc58ff9711ddf770f8890e5bbd0ce352c77d2c05790283394"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/wmd-relay", using: :nounzip
    sha256 "31096ef0ef7bf6d0af2a291ebb733e91ac303a3ef6391db4e6083406fdac4ed0"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/vm.wasm", using: :nounzip
    sha256 "2fb89021d905d7af122696f0524b3698d3739cbaad6a47b3a1bfd6f464ecc3a2"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/Image", using: :nounzip
    sha256 "5acee55f16b51e01cbb886e859087667a6a8790f4cb49043f222a1043b57452f"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/Image-4k", using: :nounzip
    sha256 "b522d520fe7ff2a5d256272528ff9a08cb14e3374a1406edbd86c081744e029a"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/initramfs.cpio.gz", using: :nounzip
    sha256 "ef75feb21aba0be6df11fd622321fd35ac04da662226f294a1e16cac80c5d7b6"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.7/config", using: :nounzip
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
    assert_match "build 6cc9585d", shell_output("#{bin}/wmd --version")
  end
end
