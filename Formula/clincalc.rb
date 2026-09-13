class Clincalc < Formula
  desc "Open, auditable clinical calculators: a serde-only scoring engine plus the `clincalc` CLI and loopback REST API in one crate."
  homepage "https://github.com/pacharanero/clincalc"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.3.4/clincalc-aarch64-apple-darwin.tar.xz"
      sha256 "01ffb70aca530cd932a38da01ebfb6a0e4ff95350bbb3abfb9cd5a9f0d2fa120"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.3.4/clincalc-x86_64-apple-darwin.tar.xz"
      sha256 "a83780ba009f1c6446c260a8288984a924323a01fb9247364f05e15202699543"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.3.4/clincalc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0dbeff1b2ecd03ad8797f19575e54cb7162c8f556c87ba43087255ab32cc4800"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pacharanero/clincalc/releases/download/v0.3.4/clincalc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff87fd30612a2e52c0c0ae55ca29a1386fbd8f97e4213e0bfa7610eaec7cf90c"
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
