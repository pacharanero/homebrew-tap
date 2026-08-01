class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/koloki-co/dsc"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.13.0/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "c5d2ae357fc710e30208917dc966c78715b8dbd856787911672076a83cf1009f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.13.0/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "879af6148effa2570e37bbe503084ea47f9a5e66c98de83b0d7c9d1f9d7b53d9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.13.0/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1bae36d2a54e42e88206be4736b198c604e3486e2b2b934c34773cf3b2a3a3c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.13.0/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90da806af7f3ee72333a4a9b462e7303440864bc59e7be33c65479b1ed5b7633"
    end
  end
  license "GPL-2.0-or-later"

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
