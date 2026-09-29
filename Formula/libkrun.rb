class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/libkrun/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.19.6.tar.gz"
  sha256 "7025d72208172dc06f791ad5af7ccaafeabdac9869f74ccb45fb6d4f6e5991cd"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/libkrun-1.19.6"
    sha256 cellar: :any, arm64_tahoe:   "832c2203ff430150c78b38a829bc7d1caa15209241a5660bda725dbd51cdf942"
    sha256 cellar: :any, arm64_sequoia: "a6ba0f7f8bb68c011b49499eb6e5596dbb553a56e22ebd3b423fa56cea1fafaf"
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
