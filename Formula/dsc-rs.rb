class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/koloki-co/dsc"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.23.0/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "e4361a52103980bec00a6cf222ce35f087e80c6a00ea199f4e5fcde786597d6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.23.0/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "d3e54290fe225958f9c5d974dd5c2fe21ea358f47a3c5ddb10351d1baf228b87"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.23.0/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a59781b6ffe47b4cc99ad6446b3ca969ab0e03961f203d225e809cd4bba07adc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.23.0/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d820bb9d69f364d87ef33eecb254f6c75598b9c96cd8d72acdc0193dba0eaf50"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dsc"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dsc"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dsc"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dsc"
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
