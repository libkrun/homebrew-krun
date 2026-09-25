class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/libkrun/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.19.5.tar.gz"
  sha256 "f7ffb97b86eb2153c4e7e5f8388c00e971d935e90c52303a8ab43a5a487356e1"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/libkrun-1.19.5"
    sha256 cellar: :any, arm64_tahoe:   "e6e3eee4efc4a98606b26f2a5571b4a3de01334bbbd6677ea31d4303d4b6214d"
    sha256 cellar: :any, arm64_sequoia: "48ab7eb539412b56c46fe013b0f2bfda3d6e65e0fef4b9573c6ba312f0d15b72"
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
