class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.33",
      revision: "201c782c0d8d21c4a16ba1bcc1e28ea7e35e095a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74ab9aa698d90f6ed9cb25ec60a67c9b6c8404a75e22c2756210a4c833c7ec07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74ab9aa698d90f6ed9cb25ec60a67c9b6c8404a75e22c2756210a4c833c7ec07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ab9aa698d90f6ed9cb25ec60a67c9b6c8404a75e22c2756210a4c833c7ec07"
    sha256 cellar: :any_skip_relocation, sonoma:         "23b5fc97f76df1ff22c1c512d8666dfc4e201e4a653ef736dcde79cc5c7b5d81"
    sha256 cellar: :any_skip_relocation, ventura:        "23b5fc97f76df1ff22c1c512d8666dfc4e201e4a653ef736dcde79cc5c7b5d81"
    sha256 cellar: :any_skip_relocation, monterey:       "23b5fc97f76df1ff22c1c512d8666dfc4e201e4a653ef736dcde79cc5c7b5d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffe2f8e6faf6232e6dab75e5167f0b159e897d8ed57109289bafaee2dd1ec43"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
