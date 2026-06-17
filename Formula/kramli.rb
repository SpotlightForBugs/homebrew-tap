class Kramli < Formula
  desc "CLI client for the Kramli shopping & todo list app"
  homepage "https://github.com/SpotlightForBugs/kramli-cli"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.11/kramli-aarch64-apple-darwin.tar.xz"
      sha256 "547d576c41a17531598847f96d39529c40b17644bbabb11b29d7594307d424e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.11/kramli-x86_64-apple-darwin.tar.xz"
      sha256 "8fdea164d019060fe0f558ae99abf0ea83698cda61b28b7ccdf50dc01c035813"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.11/kramli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d15e41a7ece2c62fd8e34395a566268cb203e27018fd94f1c1fe4a4b2937973"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.11/kramli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c1d82e64a1412a2abd6625889115e9dc12a0ddf11df4612db508299ea95c6d73"
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
    bin.install "kramli" if OS.mac? && Hardware::CPU.arm?
    bin.install "kramli" if OS.mac? && Hardware::CPU.intel?
    bin.install "kramli" if OS.linux? && Hardware::CPU.arm?
    bin.install "kramli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
