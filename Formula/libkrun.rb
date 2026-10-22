class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/libkrun/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.19.7.tar.gz"
  sha256 "d4541fcd959ad43fb073bff61bc91b645ea6413a10b8319e9b61664a6102d20c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/libkrun-1.19.7"
    sha256 cellar: :any, arm64_tahoe:   "a93c8906fee421c757d7254fb74d2ac189e60832921639d34e4b36f7cf71b4f2"
    sha256 cellar: :any, arm64_sequoia: "0af86fb80291840e519f3dca812f550533954234e7a3419aa249ab574e38594f"
  end

  depends_on "lld" => :build
  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "libepoxy"
  depends_on "libkrunfw"
  depends_on "virglrenderer-krun"
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
