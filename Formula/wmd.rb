# wmd 0.1.40 (commit 249e410aedfc0910339323d0e5b0c197860fb1cb), made by wmd's scripts/release.sh. Unsigned: no Developer ID, not notarized.
class Wmd < Formula
  desc "Docker Engine API compatible daemon and CLI that runs Linux containers in WebAssembly"
  homepage "https://github.com/threadedstack/wmd-releases"
  url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/wmd", using: :nounzip
  version "0.1.40"
  sha256 "f57ddbee5b60671c0641eb69ef1017c28b761ea8a02217a25b5397e585ee94d0"

  depends_on arch: :arm64
  depends_on :macos

  resource "wmdd" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/wmdd", using: :nounzip
    sha256 "b1481073fe7928cd96e787fa1198b6fabf4219cd2e6ad8b6f3b1a7389cdfbc5a"
  end

  resource "wmd-run" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/wmd-run", using: :nounzip
    sha256 "d5f9fcc5a36e734e27096574d2ca237fded44b4f82e1fd63023ee26c82ec9ff4"
  end

  resource "wmd-exe-stub" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/wmd-exe-stub", using: :nounzip
    sha256 "1ccb4d45f192431d8f2a93b5d0c5d8106a9b63d54e4c7ec9e50463e94a13bc8e"
  end

  resource "wmd-relay" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/wmd-relay", using: :nounzip
    sha256 "41d5a96a755aaa856ad59726980ced4541cb33cd6916452090c67808eeb5e8de"
  end

  resource "vm.wasm" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/vm.wasm", using: :nounzip
    sha256 "1553b50b591cc579d2ce24e79c3fd72360db34a8a337c108e25e515a5eb920b6"
  end

  resource "Image" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/Image", using: :nounzip
    sha256 "8542df8ca5f5b1b543129281e70e9906220da0ef299d93af190df2f953237b97"
  end

  resource "Image-4k" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/Image-4k", using: :nounzip
    sha256 "696a4ce9d2fdc9b5a945f49f5faeb59f744fbdea9d0d69216afc6d29677398f0"
  end

  resource "initramfs.cpio.gz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/initramfs.cpio.gz", using: :nounzip
    sha256 "ea7cf5e117d4d0361ac3f9fe152729d5fa36746bc4017eea1c760227983628b8"
  end

  resource "features" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/features", using: :nounzip
    sha256 "02693b8b6c099e10fdb7a092394102ee92971ce1e39d0d6e5327ff8be1d0ee74"
  end

  resource "config" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/config", using: :nounzip
    sha256 "a70b9ee01f841c87eaa8270977db69fb3c2c9db8bc92aeb1f88c073c710eb3b0"
  end

  resource "wmd-ccwrap-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/wmd-ccwrap-linux-arm64", using: :nounzip
    sha256 "c066851318b1d9f292fa848a04b0771295dd6f0eac5c866af53166b7dc72f9f8"
  end

  resource "wmd-ccshim-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/wmd-ccshim-linux-arm64", using: :nounzip
    sha256 "24d8a1a0b4da43a1ecf2e1426fb9761b266395b21d6639c8be5ffb258cb45117"
  end

  resource "ccache-linux-arm64" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/ccache-linux-arm64", using: :nounzip
    sha256 "47f20c5b7cfc04da8deda7a7787f5565f500a9885448752bdb59b7dc8d98d575"
  end

  resource "ccache-LICENSE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/ccache-LICENSE.txt", using: :nounzip
    sha256 "53c0ac34e61c628ee04b794f530be732b6181f5571f52a8aed447a3e41a6ccde"
  end

  resource "ccache-SOURCE.txt" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/ccache-SOURCE.txt", using: :nounzip
    sha256 "4358435e5f878fef9e729a8c36fdcdac37209761f7911545ac0d847499c038d1"
  end

  resource "ccache-source.tar.xz" do
    url "https://github.com/threadedstack/wmd-releases/releases/download/v0.1.40/ccache-source.tar.xz", using: :nounzip
    sha256 "4c03bc840699127d16c3f0e6112e3f40ce6a230d5873daa78c60a59c7ef59d25"
  end

  def install
    # wmd looks for wmdd, wmd-run and guest/arm64 next to its own file, so they all live in libexec
    # and bin holds small scripts that start them there.
    libexec.install "wmd"
    resources.each do |r|
      dest = %w[wmdd wmd-run wmd-exe-stub wmd-relay].include?(r.name) ? libexec : libexec/"guest/arm64"
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
    assert_match "build 249e410a", shell_output("#{bin}/wmd --version")
  end
end
