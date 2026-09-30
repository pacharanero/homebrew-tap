class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/koloki-co/dsc"
  version "0.22.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.22.0/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "2567559fdbfd77b0b2329499d26e4382191b4fc54e2b48fcc9992132b0390dca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.22.0/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "112828c813335207ad2a3d45facceb4a5b8df67a089dab158845543ed85f6347"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/koloki-co/dsc/releases/download/v0.22.0/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ee54bb29a6ecfc2f66abf8be0310cda8d93e97ea5bbec22f6304b27ca5e7652"
    end
    if Hardware::CPU.intel?
      url "https://github.com/koloki-co/dsc/releases/download/v0.22.0/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7342c568d21708d81c15df6a1c951dcf64317e76140dc7525505718ff16ff69b"
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
