class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/koloki-co/dsc"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.16.0/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "aea65a4a461d3a0084985cc083e99ffa0a16d61097bf4f9d60da45a48d1e6f54"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.16.0/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "0f273aad613d86fe96f6b6c6ba42ede91e5fa6c585229f3059ed51b5f47d4b76"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.16.0/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "650dd2b45d45e99d8cffb6d8b4ecf212e8e89feecc63acdfdf06ceba4fac6d58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.16.0/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf9e52e261e3b676cbf0806d9902a13a34d62da8634a1990da19ebf023e3546e"
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
