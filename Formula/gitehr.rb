class Gitehr < Formula
  desc "A Git-based Electronic Health Record system - CLI tool"
  homepage "https://gitehr.org"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.4.0/gitehr-aarch64-apple-darwin.tar.xz"
      sha256 "2d31c848d95aa408568307d9f958beddb8ad9f8c7c71f974468c5c2a68028f09"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.4.0/gitehr-x86_64-apple-darwin.tar.xz"
      sha256 "dbec8e207a31a3ed765d948adbcdb137f482de16529277e7b92347954e959886"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gitehr/gitehr/releases/download/v0.4.0/gitehr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "818fa969b1cfe4fc8bfef48fd5d67e89ad423ef06a53bd9631a3f2693bfeb327"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gitehr/gitehr/releases/download/v0.4.0/gitehr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4fa97a80dc35fb63c3dcfacf1062e5fa57c5a8af44152296e91cd61b4d96dfa5"
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
