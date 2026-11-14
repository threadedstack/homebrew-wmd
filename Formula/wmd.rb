# wmd 0.1.18 (commit cb2d3874a3d65236337c76c3c59147fe152a010c), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/wmd", using: :nounzip
  version "0.1.18"
  sha256 "7cac1657bd653a529a03b81964230144a48d196adef3f51388502d0012a01fe8"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/wmdd", using: :nounzip
    sha256 "3e5cb70eeb1ed5d2e5187cf86211c87a937ab5af27c1e2ad94523d5a18bf488b"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/wmd-run", using: :nounzip
    sha256 "e8caf877bb9f6d7e176ce501e4a23551a4946c1e96a6f6212e1e0878ab37a70e"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/wmd-exe-stub", using: :nounzip
    sha256 "24af1711f9839284d7aeefb918c8342e7a43be7f1aae2dabcdb45608c90e861a"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/wmd-relay", using: :nounzip
    sha256 "e9f998b138c267093e901eed3e33ac69adebff193455a6a07be573c66d3ebe4e"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/vm.wasm", using: :nounzip
    sha256 "40299e37e788189e6d3bea9d9cdaefa241a5acf27931e6aae14117c100b036ec"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/Image", using: :nounzip
    sha256 "1d296c86b1fee0a10d0c2571b7e19854fe85ca0250cc9fadfe75eb268e48be7b"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/Image-4k", using: :nounzip
    sha256 "6296e3d9fc7bb06a26340bb4453b5f0970d6b55452903546ba2c762820e2df5b"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/initramfs.cpio.gz", using: :nounzip
    sha256 "f008aa9e0f6b4e913242f9982d3b194dba7dc39042a24bc89be64630672125af"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/features", using: :nounzip
    sha256 "9c3957469a8f03d7937f1dca7c5f4087d6511ee0ec681c6b1ddce640b34fa866"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.18/config", using: :nounzip
    sha256 "a70b9ee01f841c87eaa8270977db69fb3c2c9db8bc92aeb1f88c073c710eb3b0"
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
    assert_match "build cb2d3874", shell_output("#{bin}/wmd --version")
  end
end
