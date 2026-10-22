class VirglrendererKrun < Formula
  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  url "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/0.10.4e-krunkit/virglrenderer-0.10.4e-krunkit.tar.gz"
  sha256 "09d000623fbdb966cb604eb48c962a0815e8142383e6066d6494809335b76dbb"
  license "MIT"

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/virglrenderer-krun-0.10.4e"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "5a39d19998300f51d1536b58f57ebf50813dbe9b28bf97653641ab28995c5e76"
    sha256 cellar: :any, arm64_sequoia: "8817df114b364d9615dfd1463084002dcb57932b84b3a3646ff34a9148f17941"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libepoxy"
  depends_on "molten-vk"

  conflicts_with "virglrenderer"

  def install
    args = %w[
      -Dvenus=true
      -Drender-server=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <virglrenderer.h>
      int main(void) {
        struct virgl_renderer_callbacks cbs = {0};
        cbs.version = 1;
        // VIRGL_RENDERER_NO_VIRGL avoids need for EGL/GL context
        int ret = virgl_renderer_init(NULL, VIRGL_RENDERER_NO_VIRGL, &cbs);
        if (ret != 0) {
          fprintf(stderr, "virgl_renderer_init failed: %d\\n", ret);
          return 1;
        }
        virgl_renderer_poll();
        virgl_renderer_cleanup(NULL);
        printf("OK\\n");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/virgl", "-L#{lib}", "-lvirglrenderer"
    assert_equal "OK", shell_output("./test").chomp
  end
end
