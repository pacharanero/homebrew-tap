class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/pacharanero/dsc"
  version "0.10.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.29/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "b770d26f7c2b89a25c778e57ee7ee4d87677cfb20b200977bd561d3c17da473d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.29/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "afb6d4ee08d45a066b7821fb5c08ac7f89447c605871e5636f5e2bd494e1ebe9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.29/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0335b1613aa8904519e64a754a96832aace2e37aef10a9040ea5fe668592838"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.29/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9232094bab4b3570a9b139f9a98be15e34655842f4bcefe1a2d3eea63f38f6c"
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
