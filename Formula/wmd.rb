# wmd 0.1.31 (commit 37ec746fa8d64cf397418bc0bfb25b3d410d65c6), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/wmd", using: :nounzip
  version "0.1.31"
  sha256 "1dd069dd826b124c595366fd1781f09edd6586af351cb602ce35a6498d7da56b"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/wmdd", using: :nounzip
    sha256 "76b967376045686fe99080c9f936e3c1eb99b29a03e104277ed2559877eb5df0"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/wmd-run", using: :nounzip
    sha256 "375d67542abd803b0b95abd8fdbf4b94e5cfed95d53ee665fb8842e318298535"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/wmd-exe-stub", using: :nounzip
    sha256 "ec6e7b4755d70a25f615027350bdc33c74bf7af58dd7124c5ad6de618a543212"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/wmd-relay", using: :nounzip
    sha256 "65d63d34b5160858171c213900ec3cca1b5d30a0111df94f54ea903d118ea947"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/Image", using: :nounzip
    sha256 "259ac3fbdcf92d768d5dc6335aa64817c03dfdfbe9a9cc1ac1616db89c4493b7"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/Image-4k", using: :nounzip
    sha256 "938d7e67ac77538344432117109edae801fafe47af133003b013ba4faeacf1a3"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/initramfs.cpio.gz", using: :nounzip
    sha256 "bc842852b22c2914123e3b331a17b8c444f2c12b3d76f4e7fd800862a0277a5b"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/features", using: :nounzip
    sha256 "02693b8b6c099e10fdb7a092394102ee92971ce1e39d0d6e5327ff8be1d0ee74"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.31/config", using: :nounzip
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
    assert_match "build 37ec746f", shell_output("#{bin}/wmd --version")
  end
end
