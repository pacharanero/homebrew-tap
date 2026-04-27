class DscRs < Formula
  desc "Discourse CLI tool for managing multiple Discourse forums: track installs, run upgrades over SSH, manage emojis, sync topics and categories as Markdown, and more."
  homepage "https://github.com/pacharanero/dsc"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.2/dsc-rs-aarch64-apple-darwin.tar.xz"
      sha256 "2863bfd918eb9250476447a39e801403d1acec468c51eddd4397e3d905ba8bc7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.2/dsc-rs-x86_64-apple-darwin.tar.xz"
      sha256 "302eef76f269fd7bd93554372f103053c6e6bd3be4f67a6b0badfec9fcbef64d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.2/dsc-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f2715aba708ab1a07855680339e2f8babef3b44efac6d232016e1ebfc998952e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/dsc/releases/download/v0.10.2/dsc-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bd2b73cce13b6554eed517a3ea2eb59898bd6a761af66558c9b8f89e463e545"
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
