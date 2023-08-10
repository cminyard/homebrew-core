class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.7.1.tar.gz"
  sha256 "e096158b52ef5d726d072e1fb68b481292d304d45a48b48109781e9a5545eafd"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  depends_on "glib"
  depends_on "go"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "python@3.11"
  depends_on "swig"

  def python3
    "python3.11"
  end

  def install
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
       "--disable-silent-rules", "--with-pythoninstall=#{lib}/gensio-python",
       "--with-link-ssl-with-main"
    system "make", "install"
    (prefix/Language::Python.site_packages(python3)).install_symlink Dir["#{lib}/gensio-python/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gensiot --version")

    input = "Hello World!"
    output = pipe_output("#{bin}/gensiot echo", input, 0)
    assert_equal output, "Hello World!"
  end
end
