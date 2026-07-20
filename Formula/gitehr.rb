class Gitehr < Formula
  desc "A Git-based Electronic Health Record system - CLI tool"
  homepage "https://gitehr.org"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.3.5/gitehr-aarch64-apple-darwin.tar.xz"
      sha256 "3c082087767ff1a5b7976460e1c02b6ad507274d7ac0830a97080d91ba113268"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.3.5/gitehr-x86_64-apple-darwin.tar.xz"
      sha256 "3068c279af0f5cac377fe0539a05997e51e08af4fb0aabfa52089fb5dc1e6449"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.3.5/gitehr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f707409ed3ad219f8a7fa9b08364670f8b336491c8659d114fdbf71a5f785864"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.3.5/gitehr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6bd4765073990cc4f2c6af2eb10245cac7569d07c225e3aee9e3197422daeb66"
    end
  end
  license "AGPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
