class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/koloki-co/dsc"
  version "0.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.18.0/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "9959c1b9d4dc604dd404b19114cb8d0e5aff36ae69933bd4ee9fcbd383fcb7dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.18.0/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "16ec1eda0613422da85659e3668b849339d263ab2419dd59fb125fe232811b35"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.18.0/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "39098f702ea550061cdd571fcc5867e5c40cbd5d90625df22d8eab120f033fe5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.18.0/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "47f2c6ccf20b68cd39611fa4291363addda7edf6bb58fe269bf3a8ed8aaec240"
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
