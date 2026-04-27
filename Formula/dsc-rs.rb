class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/pacharanero/dsc"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.1/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "21ca085d48c26b0739c547bab5d2194ad77897a1fa1d15e4f0832c1dec7e6f40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.1/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "72040ea66572339fac6e18c9f4c4ccb349e3ebf439d4718f70e76a26a201dccd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.1/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "83b2f2ca1d5d76076189f4ece30179c8eef5a3a7dcb6fc1f99ae5d203ec253df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.1/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b954c637136c3856b44c0f7e4a9cf6f79f9a03e6e25b210a1de477a65051ddfc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "dsc" if OS.mac? && Hardware::CPU.arm?
    bin.install "dsc" if OS.mac? && Hardware::CPU.intel?
    bin.install "dsc" if OS.linux? && Hardware::CPU.arm?
    bin.install "dsc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
