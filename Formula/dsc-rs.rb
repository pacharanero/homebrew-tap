class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/koloki-co/dsc"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.15.0/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "4691b64fd27fc6f62338a6cc6d076dad89797cc6bb11cd3123829da2981ff2fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.15.0/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "cb4d4e4dcf0360a70310fc20c32d624067c564b5ccbebef7aa0216318ab308dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.15.0/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "342fecc9f32c5e621b793d8f5136bd754008981cd092a468ce60dbca273b7a6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.15.0/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f26ba31f4325c2569f3b10ce9eb2aeb899e6962faf29cfdf8d5d432c4f4f8a6"
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
