class Clincalc < Formula
  desc "Open, auditable clinical calculators: a pure scoring engine plus the `clincalc` CLI in one crate. The engine is a serde-only leaf (build with default-features = false); the default `cli` feature adds the `clincalc` binary."
  homepage "https://github.com/pacharanero/clincalc"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.2.1/clincalc-aarch64-apple-darwin.tar.xz"
      sha256 "9c808124ac53d2ce967e4fb198b6c0ab1f727f036fc29cedaab0535050d3d19e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.2.1/clincalc-x86_64-apple-darwin.tar.xz"
      sha256 "b06c4576e6745afc105b90bae58c36760d44c7ff2f141ff4a93eb5a4dba33025"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.2.1/clincalc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b95d4d02ed6cad11af6c28a1d388b23e4cd0475776b1073f0c0bc5e86a54f8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.2.1/clincalc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "54768bd852ddf443d02a885a3814c48d4bcb8aba5e2d7b19d49c828e6fca6209"
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
    bin.install "clincalc" if OS.mac? && Hardware::CPU.arm?
    bin.install "clincalc" if OS.mac? && Hardware::CPU.intel?
    bin.install "clincalc" if OS.linux? && Hardware::CPU.arm?
    bin.install "clincalc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
