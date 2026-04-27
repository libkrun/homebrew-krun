class Gvproxy < Formula
  desc "New network stack based on gVisor"
  homepage "https://github.com/containers/gvisor-tap-vsock"
  url "https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "4f7c4885225d71b21f6b547b94d92fc6da4a4fef9d382fdd19c8ea67f67be839"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/slp/homebrew-krun/releases/download/gvproxy-0.8.8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f6e344bbe92bb0ca11d18188fce5b5893693793601b21369b74f5ace737ae7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb6775b4d1d3844730c01304e6be74bb9aee9c4e7e6989bebe350e58c144af5"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gvproxy" => "gvproxy"
  end

  test do
    assert_match "gvproxy version", shell_output("#{bin}/gvproxy -version")
  end
end
