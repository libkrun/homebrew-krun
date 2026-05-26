class Krunai < Formula
  desc "CLI tool for running AI agents inside microVM sandboxes"
  homepage "https://github.com/slp/krunai"
  url "https://github.com/slp/krunai/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "d19457adcb024beff9a5d103cc8aac59b1ccae397fef46e9c2eb93f2f330922c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/slp/homebrew-krun/releases/download/krunai-0.2.5"
    sha256 cellar: :any, arm64_tahoe:   "53b54c58fd1fbbbd4a02c61f64c3ed792cd76cce89e38dda37c5814d021b6c5b"
    sha256 cellar: :any, arm64_sequoia: "ee8dc37ee9771894b09c7773f258fa6df5ecfb76616c23c1f13728159ce65520"
  end

  depends_on "llvm" => :build
  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "gvproxy"
  depends_on "libkrun"
  # We just need qemu-img, but it's not packaged independently
  depends_on "qemu"

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s
    homebrew_lib = ENV["HOMEBREW_PREFIX"] + "/lib"
    system "make"
    MachO::Tools.add_rpath("target/release/krunai", homebrew_lib)
    system "codesign", "--entitlements", "krunai.entitlements", "--force", "-s", "-", "target/release/krunai"
    bin.install "target/release/krunai"
  end

  test do
    system "#{bin}/krunai", "--version"
  end
end
