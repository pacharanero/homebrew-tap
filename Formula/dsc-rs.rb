class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/koloki-co/dsc"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.14.0/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "66de4603620509ec609aa6325a5ac0ee84c9a759fd1f1447ee9f1d09ecbed803"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.14.0/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "e7801e242bae59938ae3adbb4041858b428d57ca60c59bb1ea0b9a180611ac57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.14.0/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b02d5e87078da6a2b886566fba02763da870e26078099eef25ac8a4864325337"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.14.0/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d10cb424c071e9e34f780cfe04c5374240320108353308df9c573a40112393a7"
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
