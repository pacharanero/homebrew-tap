class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/pacharanero/dsc"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.8.3/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "4c2da13d339b09d24e59e47d7a6434a64587705f71078a48d2a3ee85ac9b99e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.8.3/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "66f08a1e6b3854e3f9498908aa66a2264a40f9e02e0d24de68bb1a8c92e61f65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.8.3/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "33a772f7788f57d397fe653d55c93423bea238ab6abfb0014f28aaade8c925ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.8.3/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4383faebfa23f10cbcaaeadbc740e6facf9cb859d3ee5ba57f6332224b7105c5"
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
