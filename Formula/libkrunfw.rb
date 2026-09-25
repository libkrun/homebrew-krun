class Libkrunfw < Formula
  desc "Dynamic library bundling a Linux kernel in a convenient storage format"
  homepage "https://github.com/containers/libkrunfw"
  url "https://github.com/containers/libkrunfw/releases/download/v5.6.1/libkrunfw-prebuilt-aarch64.tgz"
  sha256 "a1b035fa178b38c14abf86879aa9b622073e45e49304ebd33f86e9e780a85ba0"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/libkrunfw-5.6.1"
    sha256 cellar: :any, arm64_tahoe:   "e6094afd5a65168a88fdc89a87643e907fe389b79e3f7bd6d6edad34baa0dd8e"
    sha256 cellar: :any, arm64_sequoia: "a81693ddbc8c6cf2baf44d5cf871516e93ed73f8fb4a80c4f1be0b65f681152b"
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
