class Buildah < Formula
  desc "Tool that facilitates building OCI images"
  homepage "https://buildah.io"
  url "https://github.com/containers/buildah/archive/refs/tags/v1.45.1.tar.gz"
  sha256 "b48e701c75a2bd30dfe63fda5f886c8a7e0c3dd17b6aa0feb74cc93099254ca4"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "gpgme"

  def install
    system "make", "bin/buildah", "docs"
    bin.install "bin/buildah" => "buildah"
    mkdir_p etc/"containers"
    etc.install "tests/policy.json" => "containers/policy.json"
    man1.install Dir["docs/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buildah --version")
  end
end
