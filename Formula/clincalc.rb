class Clincalc < Formula
  desc "Open, auditable clinical calculators: a serde-only scoring engine plus the `clincalc` CLI and loopback REST API in one crate."
  homepage "https://github.com/pacharanero/clincalc"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.4.0/clincalc-aarch64-apple-darwin.tar.xz"
      sha256 "17738dfafd20cd6c547ed66d5ecdec34eda7114010e4f87a7fa42b69be08cc51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.4.0/clincalc-x86_64-apple-darwin.tar.xz"
      sha256 "fbd655e6257e1c76ff87c01183ad0bd574dc0d393419db5cee204e4f8d78f1c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.4.0/clincalc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f8cd233894292a470ec1b5452001688a2b888fe4efa6442fc76cc270737382f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.4.0/clincalc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b52668375edf3cecd1ddf9484ca1f1c258cd7aa94f4d6dda9b6f92d39ea6b6b2"
    end
  end
  license all_of: ["AGPL-3.0-or-later", "LGPL-3.0-or-later"]

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
      bin.install "clincalc"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "clincalc"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "clincalc"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "clincalc"
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
