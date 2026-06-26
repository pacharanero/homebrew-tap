class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/pacharanero/dsc"
  version "0.10.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.23/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "c4ca13b6e50366c46be5a3d1b00b411bc18e9ea4e8c3b7e6152138b7f1b88f26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.23/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "e930b22d35745b287449a5e87c3298612e62d5637572da9eeca7cb77e406aebb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.23/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "230a848d182f5baabcb3d22be393967b63ef3a5fd9b467ccb96360f92e4ba00e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.23/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb4ccb5f9e0e0b62ce2e28aaf6eb20e890a39cd94040352a5e0f3257937c6526"
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
