class Kramli < Formula
  desc "CLI client for the Kramli shopping & todo list app"
  homepage "https://github.com/SpotlightForBugs/kramli-cli"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.12/kramli-aarch64-apple-darwin.tar.xz"
      sha256 "0c22939b530cc35113fa368905ea8dcf09897bca62bcc5be1d757e69f334d945"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.12/kramli-x86_64-apple-darwin.tar.xz"
      sha256 "e986a073877f414aaae857fac6d8f2411bf675a829a703f1a93fc85e25ed23b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.12/kramli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce343c8fcd616b48986e1acb05ffeeeb9bcafb4c58072c5c4e5cb3d5c8be7e2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.12/kramli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "17e1a8b7d740d61d212c30105278a7a84c6d79fb9aec06cd62d553290361146f"
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
