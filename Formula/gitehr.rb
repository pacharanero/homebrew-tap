class Gitehr < Formula
  desc "A Git-based Electronic Health Record system - CLI tool"
  homepage "https://gitehr.org"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.5.0/gitehr-aarch64-apple-darwin.tar.xz"
      sha256 "abe24422cef91811355f91211ce0211c65706fa0b1095125a765fe8092ee965b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.5.0/gitehr-x86_64-apple-darwin.tar.xz"
      sha256 "1cd93ffdf686e6fecb40ffcfcd0cb481a298221b66dcbc0c0d66614edcc97709"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.5.0/gitehr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "26b8319bf153cadbb3cf093e222e8beeb57da355e772824ff9d6d4f3bd55fcab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.5.0/gitehr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8c427f825fb94d4b6c449dbb809e404e12387f441ddced8fcc6c672b788e2f54"
    end
  end
  license "AGPL-3.0-or-later"

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
      bin.install "gitehr"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gitehr"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gitehr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gitehr"
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
