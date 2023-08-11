class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.7.2.tar.gz"
  sha256 "4fca20de5b5e5ff066a65025d29cc85427a47e5e0605d49f67fef03520fbf1e2"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  depends_on "go" => [:build]
  depends_on "pkg-config" => [:build]
  depends_on "swig" => [:build]
  depends_on "glib"
  depends_on "openssl@3"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
                          "--disable-silent-rules",
                          "--with-pythoninstall=#{lib}/gensio-python",
                          "--with-link-ssl-with-main",
                          "--sysconfdir=#{etc}"
    system "make", "install"
    (prefix/Language::Python.site_packages(python3)).install_symlink Dir["#{lib}/gensio-python/*"]
  end

  service do
    run [opt_sbin/"gtlsshd", "--nodaemon", "--pam-service", "sshd"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gensiot --version")

    input = "Hello World!"
    output = pipe_output("#{bin}/gensiot echo", input, 0)
    assert_equal output, "Hello World!"
  end
end
