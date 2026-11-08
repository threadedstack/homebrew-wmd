# wmd 0.1.6 (commit a1aa2322bac4265d44989f6b3e05d63c08dbbc7e), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/wmd", using: :nounzip
  version "0.1.6"
  sha256 "89709d4fd0325a1beb7d9d13ffbf27c6a41d996e46fc64fbd081021c2c0ee5bc"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/wmdd", using: :nounzip
    sha256 "8a9b9054852314adb8ff9d4e285a86a76dc13029131315968f28e8bbbcd8ccf3"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/wmd-run", using: :nounzip
    sha256 "1f339dd5592062c420cb2067b7322be4e55f3311df910a12f833f6b3499e5ea2"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/wmd-exe-stub", using: :nounzip
    sha256 "1ce348db3ee17f6e4674db228027d6bb4cac60bc8a9757e0c79fdb905cad6ed1"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/wmd-relay", using: :nounzip
    sha256 "dc4dc4bf708661471f1c699a73d70c86561c99dd7dfdf083190b90e39ccaa890"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/vm.wasm", using: :nounzip
    sha256 "b646c16fa7010491c4552953a56cea556dba0a19fa4287f25a35ae4f1763090f"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/Image", using: :nounzip
    sha256 "89c0717c61c44389918bef60e4ab322907b4b4c0981769e71590208c9b656036"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/Image-4k", using: :nounzip
    sha256 "3690e0d6af5139d8c6a2a0de55c0ca8151b0561bb87a62cb4ea322f0338b0629"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/initramfs.cpio.gz", using: :nounzip
    sha256 "988ebc50cf2c1784b8534565a8142ad68f0cd88f9f7cb5664ef18aa24cafadef"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/features", using: :nounzip
    sha256 "97690c31c54d9032d4de26a9d06cae1aa0eadffc5db573be6d38e8d01551c992"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.6/config", using: :nounzip
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
    assert_match "build a1aa2322", shell_output("#{bin}/wmd --version")
  end
end
