class Libkrunfw < Formula
  desc "Dynamic library bundling a Linux kernel in a convenient storage format"
  homepage "https://github.com/containers/libkrunfw"
  url "https://github.com/containers/libkrunfw/releases/download/v5.6.2/libkrunfw-prebuilt-aarch64.tgz"
  sha256 "adef6739cc3bda2a1b57f04c08ccbfdf206a6c831d76b32de1beddc0e7984e86"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/libkrunfw-5.6.2"
    sha256 cellar: :any, arm64_tahoe:   "3de3be1caf078215a84fdc8c9a22e23167f4a17c2cc59b94bd00a13f359f4213"
    sha256 cellar: :any, arm64_sequoia: "6451c91cb70be00769b8af5a76115dc07ea51f97e668388a4648ee7e12e44f55"
  end

  # libkrun, our only consumer, only supports Hypervisor.framework on arm64
  depends_on arch: :arm64

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int krunfw_get_version();
      int main()
      {
         int v = krunfw_get_version();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrunfw", "-o", "test"
    system "./test"
  end
end
