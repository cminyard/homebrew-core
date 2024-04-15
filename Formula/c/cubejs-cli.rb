require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.14.tgz"
  sha256 "bbfe4c22af820453fdbd14f11839ff9aa73ff12e78c344da652d52ae30ef2b58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "056c19dcbb5d80c220633d99aab99f6d33a1feb48cae2d04cb598684a50f572c"
    sha256 cellar: :any,                 arm64_ventura:  "056c19dcbb5d80c220633d99aab99f6d33a1feb48cae2d04cb598684a50f572c"
    sha256 cellar: :any,                 arm64_monterey: "056c19dcbb5d80c220633d99aab99f6d33a1feb48cae2d04cb598684a50f572c"
    sha256 cellar: :any,                 sonoma:         "ad5357bb0e581506a892d50b602aabaf05a5b019df7c761914ff632990cba9ff"
    sha256 cellar: :any,                 ventura:        "ad5357bb0e581506a892d50b602aabaf05a5b019df7c761914ff632990cba9ff"
    sha256 cellar: :any,                 monterey:       "ad5357bb0e581506a892d50b602aabaf05a5b019df7c761914ff632990cba9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d37e75a7bc6356d9c257414f4a2e63916732320ed56b339c28a9091cab3089c"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
