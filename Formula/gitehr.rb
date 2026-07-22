class Gitehr < Formula
  desc "A Git-based Electronic Health Record system - CLI tool"
  homepage "https://gitehr.org"
  version "0.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.3.6/gitehr-aarch64-apple-darwin.tar.xz"
      sha256 "0a219c7ca21d6f23d98ef34bae89de7f72f029779743344bf5fc7ce04ecdaac8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.3.6/gitehr-x86_64-apple-darwin.tar.xz"
      sha256 "70f412edbb0a3788f6c0bb368520a9ecbc966ee87c50de33c5ab901bff5e8756"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.3.6/gitehr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "82e7ce8fec699e874fc4b6f3c7db34b052c0bb56d6e7603cd51b757646f5b3cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.3.6/gitehr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d8f3f96e17d0649a91641758438db94ac4a9bbc91cc9b8cce2592f8a9f08f634"
    end
  end
  license "AGPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gitehr"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gitehr"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gitehr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gitehr"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
