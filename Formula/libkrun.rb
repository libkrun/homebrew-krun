class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "3aad8087049c77424b2675ba08fe7b53708000e6df242d606e45af731f8a62cd"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/slp/homebrew-krun/releases/download/libkrun-1.18.0"
    sha256 cellar: :any, arm64_tahoe:   "9d90b3d74757fe293990bcc55ab8e245f1bffd3432dbb5781acf3a92bcdcf59c"
    sha256 cellar: :any, arm64_sequoia: "f871bc8e29fb8e6737c7834dc381773e20d1eaed1dfa518e8d00afc75fbb1c2f"
  end

  depends_on "lld" => :build
  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "libepoxy"
  depends_on "libkrunfw"
  depends_on "virglrenderer"
  depends_on "xz"

  def install
    system "make", "BLK=1", "NET=1", "GPU=1", "TIMESYNC=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkrun.h>
      int main()
      {
         int c = krun_create_ctx();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrun", "-o", "test"
    system "./test"
  end
end
