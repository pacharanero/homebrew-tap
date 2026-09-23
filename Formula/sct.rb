class Sct < Formula
  desc "Local-first SNOMED CT toolchain: RF2 → NDJSON, SQLite, Parquet, embeddings, MCP server"
  homepage "https://github.com/pacharanero/sct"
  version "0.26.1"
  license "AGPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/sct/releases/download/v#{version}/sct-macos-aarch64.tar.gz"
      sha256 "996e4b22e15dbfde6b2ee54e040979ddc72f0dd35095fe23437663f71eae2367"
    else
      url "https://github.com/pacharanero/sct/releases/download/v#{version}/sct-macos-x86_64.tar.gz"
      sha256 "1f81570a6b4529cc2ed8a862da156dac2bd891c8aa6d12aabeba9dab07e782b9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/pacharanero/sct/releases/download/v#{version}/sct-linux-aarch64.tar.gz"
      sha256 "29aea36e08b8f769e5b632575fd85ca74631146c601876ce07c0edd5c3a99d05"
    else
      url "https://github.com/pacharanero/sct/releases/download/v#{version}/sct-linux-x86_64.tar.gz"
      sha256 "37b9e542bd6944fb7d081ea7d40a9dea36e8652c7018f10dca94c4f7b03b3804"
    end
  end

  def install
    bin.install "sct"
  end

  test do
    assert_match "sct #{version}", shell_output("#{bin}/sct --version")
  end
end
