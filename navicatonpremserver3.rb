class Navicatonpremserver3 < Formula
  version "3.0.1"
  desc "Navicat On-Prem Server is an on-premise solution that provides you with the option to host a cloud environment for storing Navicat objects internally at your location. You can enjoy complete control over your system and maintain 100% privacy."
  homepage "https://www.navicat.com/en/products/navicat-on-prem-server"
  url "https://download3.navicat.com/onpremsvr3-download/homebrew/navicat-onprem-server-3.0.1.zip"
  mirror "https://dn.navicat.com.cn/onpremsvr3-download/homebrew/navicat-onprem-server-3.0.1.zip"
  sha256 "2dfafa5b4e947871d049030f85068b1c9881ac59cef88ae0a88d240ca6b26537"

  def install
    # Preload
    system "./install.sh"
    libexec.install Dir["*"]

    # Create script in /opt/homebrew/bin
    (libexec/"navicatonpremserver_env").write_env_script "#{libexec}/navicatonpremserver", DYLD_LIBRARY_PATH: libexec, NAVICAT_ONPREM_ROOT: libexec
    chmod 0755, libexec/"navicatonpremserver_env"
    bin.write_exec_script "#{libexec}/navicatonpremserver_env"
    mv "#{bin}/navicatonpremserver_env", "#{bin}/navicatonpremserver"
  end

  def post_install
    # Symlink
    rm_rf "#{libexec}/var"
    mkdir_p "#{var}/navicatonpremserver/var"
    ln_s "#{var}/navicatonpremserver/var", "#{libexec}/var"
    rm_rf "#{libexec}/log"
    mkdir_p "#{var}/navicatonpremserver/log"
    ln_s "#{var}/navicatonpremserver/log", "#{libexec}/log"
    rm_rf "#{libexec}/cert"
    mkdir_p "#{var}/navicatonpremserver/cert"
    ln_s "#{var}/navicatonpremserver/cert", "#{libexec}/cert"
    rm_rf "#{libexec}/tmp"
    mkdir_p "#{var}/navicatonpremserver/tmp"
    ln_s "#{var}/navicatonpremserver/tmp", "#{libexec}/tmp"
  end

  service do
    run [bin/"navicatonpremserver", "start"]
    # run [opt_bin/"mariadbd-safe", "--datadir=#{var}/mysql"]
    working_dir bin
  end

  test do
    system "navicatonpremserver", "version"
  end
end
