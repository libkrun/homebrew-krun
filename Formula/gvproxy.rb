class Gvproxy < Formula
  desc "New network stack based on gVisor"
  homepage "https://github.com/containers/gvisor-tap-vsock"
  url "https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "6cbcb7959a5d90b59253ea6d8bdf0285e2cfbc3b301398704b41e3069293f4fb"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/gvproxy-0.8.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d37694170ae1a4977b4b85b9217e6cc14d980f88abc26553532c96933f20296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e5c5d92dad6470ef2050f2955ba8dbc43252efa10d39c649467a967fb8ce59b"
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
