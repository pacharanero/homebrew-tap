class Gitehr < Formula
  desc "A Git-based Electronic Health Record system - CLI tool"
  homepage "https://gitehr.org"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.4.1/gitehr-aarch64-apple-darwin.tar.xz"
      sha256 "f9dc915e4aeead0947589927a0df910fa640ad37c511eebc39610a6de3dc87ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.4.1/gitehr-x86_64-apple-darwin.tar.xz"
      sha256 "3ea922cc92243992a49e816aaa2a97dcf3a3bd1f5b5457bc80b318e3d1935320"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.4.1/gitehr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "73da4e50e70d745b6f00b30533597f787b1d31b19560123be3e1d5d4f028e61a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.4.1/gitehr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ed00d6365225648f78ae79b40641007d1f522a8d969a21dc2f83358e7ab82c24"
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
