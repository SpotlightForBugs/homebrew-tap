class Kramli < Formula
  desc "CLI client for the Kramli shopping & todo list app"
  homepage "https://github.com/SpotlightForBugs/kramli-cli"
  version "0.1.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.16/kramli-aarch64-apple-darwin.tar.xz"
      sha256 "377192beb9571ebf0283f0fe9874a33018df2b41792f2a481f9d31310e72d963"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.16/kramli-x86_64-apple-darwin.tar.xz"
      sha256 "dfcdd019ee3cdfe62b73742b16ef2cd9e279ad31bdc3dc740ad1da390c857e0d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.16/kramli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3259c2447c2cfc331260c6969c51d77b46b4609ef1bf5f21f2da11435323b395"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.16/kramli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b1bf4fc4157437d5bb301981064630be0a031ff6876c8cdebcbf067cea7471d2"
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
