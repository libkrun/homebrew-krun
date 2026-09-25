class VirglrendererKrun < Formula
  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  url "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/0.10.4e-krunkit/virglrenderer-0.10.4e-krunkit.tar.gz"
  sha256 "09d000623fbdb966cb604eb48c962a0815e8142383e6066d6494809335b76dbb"
  license "MIT"

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/virglrenderer-krun-0.10.4e"
    sha256 cellar: :any, arm64_tahoe:   "a1409a29a8054da3bed9ec562a2c03113041d011d146ca2174562679fcfa2243"
    sha256 cellar: :any, arm64_sequoia: "aa075ef1bbebbeda21663cae2e882cc15469a90a63083ab9612559b5a8fc45da"
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
end
