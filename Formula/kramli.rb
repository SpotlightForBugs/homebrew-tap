class Kramli < Formula
  desc "CLI client for the Kramli shopping & todo list app"
  homepage "https://github.com/SpotlightForBugs/kramli-cli"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.5/kramli-aarch64-apple-darwin.tar.xz"
      sha256 "89b6ddb77a06303e19d04c2c0fe4faafc73651dba4bb8733ad115bd0720ffa4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.5/kramli-x86_64-apple-darwin.tar.xz"
      sha256 "ac284f2c2e3aa3c86d29573e354173d6f87babfebbb06f37f7892e71136a8599"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.5/kramli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "378aa4ff36f5ba9c46868e7ffba7ded6c13aebfa4d49e2f742ffd50e4fddef04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.5/kramli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5db95436272eb15aeac05cd992007f208391b49d7028549ae873b94881050c53"
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
