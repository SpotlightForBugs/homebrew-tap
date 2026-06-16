class Kramli < Formula
  desc "CLI client for the Kramli shopping & todo list app"
  homepage "https://github.com/SpotlightForBugs/kramli-cli"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.9/kramli-aarch64-apple-darwin.tar.xz"
      sha256 "e91fee90d18639b63046368c3193d26bfffc4dffd0632b36918384ff7d21b6ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.9/kramli-x86_64-apple-darwin.tar.xz"
      sha256 "576056fc5b8454296477f02d03c3947ceae1aded98644ffd14ab1be0697679d5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.9/kramli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "93604a75faebdc98c9c48fbdfc11500ad942a1e274fd6f02f48727ccfe439d87"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SpotlightForBugs/kramli-cli/releases/download/v0.1.9/kramli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4eb9467e2e5327eda7018580feefe78c76025801036d85b3ae4dae59c4e4ce47"
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
