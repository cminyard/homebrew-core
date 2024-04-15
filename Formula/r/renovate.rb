require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.298.0.tgz"
  sha256 "767795fa59d456ade4fdb7011d68bdca112dfc9f4d577d0bdd663165de25e304"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "566447af33e671cebbef680fe6db1db8c00204de1e58dd4d1434ccbd5e731901"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e76aad4d71c44d6e9800e954e48126cbb22d5c460b1fe9ce7009bb99d0ffa4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14f2646d6be6ab47a6b15764f1e194e58114916d3f52acba8f1a28f2e38081c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb580f6f7bba222874e7385e9d18a40f5917c8f280740ec87fd3015d34967ce7"
    sha256 cellar: :any_skip_relocation, ventura:        "d155aad7202941de33163c438c3db3508533a4170902e47a962d9c2266b163f5"
    sha256 cellar: :any_skip_relocation, monterey:       "0bf8588b4904e4c91b9fa3ca871469a66afdb2fa326d0e4b5ed8194cf1dae100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0651dcb8e65a55f491b5bd18d4ba50bc460e5c85f0191e1eaff7b142f5196b6"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
