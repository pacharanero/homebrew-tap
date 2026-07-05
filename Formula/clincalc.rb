class Clincalc < Formula
  desc "Open, auditable clinical calculators: a pure scoring engine plus the `calc` CLI in one crate. The engine is a serde-only leaf (build with default-features = false); the default `cli` feature adds the `calc` binary."
  homepage "https://github.com/pacharanero/calc"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/calc/releases/download/v0.2.0/clincalc-aarch64-apple-darwin.tar.xz"
      sha256 "7447ab8b66fd2bd75433ef38d8f65f0e454aff6a8a38978f9ba45eee77ec8406"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/calc/releases/download/v0.2.0/clincalc-x86_64-apple-darwin.tar.xz"
      sha256 "f25ae68f34312eb7800aef3647bbecd4ff600412a5be4eb0b61e560f08e443fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/calc/releases/download/v0.2.0/clincalc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab52d84361898785b65295ffc63305db5db4157fbeeda82f7782acbaac9df132"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/calc/releases/download/v0.2.0/clincalc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1b0a2d3dde33c1859069ae3171a343414f2d5843f2473c334441a963fea17c2d"
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
    bin.install "calc" if OS.mac? && Hardware::CPU.arm?
    bin.install "calc" if OS.mac? && Hardware::CPU.intel?
    bin.install "calc" if OS.linux? && Hardware::CPU.arm?
    bin.install "calc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
