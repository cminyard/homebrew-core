class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.4.2.tgz"
  sha256 "0782964fc19f06b55998a091d5a0b70e1adb682f6c062bcb5a25467a2c060e8d"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "24c6facf14eefac92963f4b425c5f6dfad87a842800bebe498e667a1937785c8"
    sha256 cellar: :any, big_sur:       "3c59064e70ce4f773eca8b61700172d792015c6810a2215482a5e23bfae61dc1"
    sha256 cellar: :any, catalina:      "30f5e03723c8a244f9e1472f2b284d0b5f59f212051818d4432b1095c0d31daa"
    sha256 cellar: :any, mojave:        "0203c0953444969756f5465e98f1d5e98bc8975b35b786f2f551cec3a0915b10"
  end

  head do
    url "https://gitlab.cern.ch/CLHEP/CLHEP.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "cmake" => :build

  def install
    mv (buildpath/"CLHEP").children, buildpath if build.stable?
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end
