class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v2.8.4/gensio-2.8.4.tar.gz"
  sha256 "28807dce0373f04271d44e1cdd38aa9486f3dd3060867b9acd370ece10404f62"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  depends_on "go" => [:build]
  depends_on "pkg-config" => [:build]
  depends_on "swig" => [:build]
  depends_on "glib"
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "python@3.12"
  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
    depends_on "linux-pam"
    depends_on "tcl-tk"
  end

  def python3
    "python3.12"
  end

  def install
    args = %w[--disable-silent-rules]
    args << "--with-pythoninstall=#{lib}/gensio-python"
    args << "--sysconfdir=#{etc}"
    args << "--with-tclcflags=-I #{HOMEBREW_PREFIX}/include/tcl-tk" if OS.linux?
    system "./configure", *std_configure_args, *args
    system "make", "install"
    (prefix/Language::Python.site_packages(python3)).install_symlink Dir["#{lib}/gensio-python/*"]
  end

  service do
    run [opt_sbin/"gtlsshd", "--nodaemon", "--pam-service", "sshd"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gensiot --version")

    assert_equal "Hello World!", pipe_output("#{bin}/gensiot echo", "Hello World!")
  end
end
