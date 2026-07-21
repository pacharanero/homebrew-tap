class Clincalc < Formula
  desc "Open, auditable clinical calculators: a pure scoring engine plus the `clincalc` CLI in one crate. The engine is a serde-only leaf (build with default-features = false); the default `cli` feature adds the `clincalc` binary."
  homepage "https://github.com/pacharanero/clincalc"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.2.2/clincalc-aarch64-apple-darwin.tar.xz"
      sha256 "164355e217d1a9698ab905276027db139751e5a28a7475e53dd138e363c4a0dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.2.2/clincalc-x86_64-apple-darwin.tar.xz"
      sha256 "2d464c12f630aad2eaf78580c5dc16f0b69a822cf8a193661b785fe2757aab4b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.2.2/clincalc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "019b8f6e11740f5b7881f3d3c26f4a1a8afada120d0a54ae0658c2496bfc7e42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.2.2/clincalc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c995cb7843fed261faf1218a023eb8e1b2c8c7eaab40871055c5ff75699d9808"
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
