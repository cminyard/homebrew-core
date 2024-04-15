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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06bebd254bdf978a48b8dc5b73a8e00bc69555c8d42340a6b806e82381dd4f09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b3662c63decf246857e87c72e5741c2f37c11b15810c96202ac5ee7fd23838d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7b810801028e39603f4a3697bfaa5c4491468e32ea3bcbaf77ea10f6359700"
    sha256 cellar: :any_skip_relocation, sonoma:         "747f702ebe65a89254a157f065a32f683c591f219304b4ca9af8143242ecfa6d"
    sha256 cellar: :any_skip_relocation, ventura:        "418f3d24dfcad272f7d55951eb51f3a6d26465ad209687b309eb01adaf08f088"
    sha256 cellar: :any_skip_relocation, monterey:       "2be8019cfab8aedbb7feaad46d556c363dd622e66be142f0e4c27192637450bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e15f7c033c984d01ba02eb61584d7507fdcefab9f5a906c5c40607c4d07a7e3"
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
