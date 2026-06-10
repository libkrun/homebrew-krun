class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/libkrun/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "832e76e93f1ea7a41e5c763a9710acf42d3d54f628015c1255f115a4b7ef2a06"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/slp/homebrew-krun/releases/download/libkrun-1.19.0"
    sha256 cellar: :any, arm64_tahoe:   "ea7d0ffb5193aa108a95400a622474cef88f0b8da68b0660b15dba3bc5b0958c"
    sha256 cellar: :any, arm64_sequoia: "f58f1befc5cd5c8ae1ae260c94523820975ae9da7c983497a9242413e156f626"
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
