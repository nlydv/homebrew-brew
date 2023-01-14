# Modified from the official Homebrew nginx formula (as of Jan 5, 2023)
# Permalink to original upstream version:
# https://github.com/Homebrew/homebrew-core/blob/3635b0d50eef81146df0935f94bd6ca3dea7df1b/Formula/nginx.rb

class NginxQuic < Formula
    desc "HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server, and with extra HTTP3/QUIC modules built in"
    homepage "https://nginx.org/"

    # url "https://nginx.org/download/nginx-1.23.3.tar.gz"
    # sha256 "75cb5787dbb9fae18b14810f91cc4343f64ce4c24e27302136fb52498042ba54"
    url "https://hg.nginx.org/nginx-quic/archive/af5adec171b4.tar.gz"
    sha256 "dfe05bdda121ba5b37743957b554e411a90a1a5898aece5a6b2362eb8f86f4e0"
    version "1.23.4"

    license "BSD-2-Clause"

    # head "https://hg.nginx.org/nginx/", using: :hg
    head "https://hg.nginx.org/nginx-quic/", using: :hg

    depends_on "libressl"
    depends_on "pcre2"

    uses_from_macos "xz" => :build
    uses_from_macos "libxcrypt"

    def install
        # keep clean copy of source for compiling dynamic modules e.g. passenger
        (pkgshare/"src").mkpath
        system "tar", "-cJf", (pkgshare/"src/src.tar.xz"), "."

        # clone `google/ngx_brotli` repo
        system "git", "clone", "https://github.com/google/ngx_brotli.git", (pkgshare/"src/brotli")
        # clone brotli submodule dependencies
        chdir (pkgshare/"src/brotli") do
            system "git", "submodule", "update", "--init"
        end

        # Changes default port to 8080
        inreplace "conf/nginx.conf" do |s|
            s.gsub! "listen       80;", "listen       8080;"
            s.gsub! "    #}\n\n}", "    #}\n    include servers/*;\n}"
        end

        # openssl = Formula["openssl@1.1"]
        libressl = Formula["libressl"]
        pcre = Formula["pcre2"]

        cc_opt = "-I#{pcre.opt_include} -I#{libressl.opt_include}"
        ld_opt = "-L#{pcre.opt_lib} -L#{libressl.opt_lib}"

        # See https://quic.nginx.org/readme.html for installation instructions of QUIC/HTTP3 version
        args = %W[
            --prefix=#{prefix}
            --sbin-path=#{bin}/nginx
            --with-cc-opt=#{cc_opt}
            --with-ld-opt=#{ld_opt}
            --conf-path=#{etc}/nginx/nginx.conf
            --pid-path=#{var}/run/nginx.pid
            --lock-path=#{var}/run/nginx.lock
            --http-client-body-temp-path=#{var}/run/nginx/client_body_temp
            --http-proxy-temp-path=#{var}/run/nginx/proxy_temp
            --http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp
            --http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp
            --http-scgi-temp-path=#{var}/run/nginx/scgi_temp
            --http-log-path=#{var}/log/nginx/access.log
            --error-log-path=#{var}/log/nginx/error.log
            --with-compat
            --with-debug
            --with-http_addition_module
            --with-http_auth_request_module
            --with-http_dav_module
            --with-http_degradation_module
            --with-http_flv_module
            --with-http_gunzip_module
            --with-http_gzip_static_module
            --with-http_mp4_module
            --with-http_random_index_module
            --with-http_realip_module
            --with-http_secure_link_module
            --with-http_slice_module
            --with-http_ssl_module
            --with-http_stub_status_module
            --with-http_sub_module
            --with-http_v2_module
            --with-ipv6
            --with-mail
            --with-mail_ssl_module
            --with-pcre
            --with-pcre-jit
            --with-stream
            --with-stream_realip_module
            --with-stream_ssl_module
            --with-stream_ssl_preread_module
            --with-http_v3_module
            --with-stream_quic_module
            --add-module=#{pkgshare}/src/brotli
        ]

        # The last three flags above are the only new ones added, otherwise uses the same
        # configure options as in the original Nginx homebrew-core formula.

        (pkgshare/"src/configure_args.txt").write args.join("\n")

        system "./auto/configure", *args
        system "make", "install"

        man8.install "docs/man/nginx.8"
    end

    def post_install
        (etc/"nginx/servers").mkpath
        (var/"run/nginx").mkpath

        # nginx's docroot is #{prefix}/html, this isn't useful, so we symlink it
        # to #{HOMEBREW_PREFIX}/var/www. The reason we symlink instead of patching
        # is so the user can redirect it easily to something else if they choose.
        html = prefix/"html"
        dst = var/"www"

        if dst.exist?
            html.rmtree
            dst.mkpath
        else
            dst.dirname.mkpath
            html.rename(dst)
        end

        prefix.install_symlink dst => "html"

        # for most of this formula's life the binary has been placed in sbin
        # and Homebrew used to suggest the user copy the plist for nginx to their
        # ~/Library/LaunchAgents directory. So we need to have a symlink there
        # for such cases
        sbin.install_symlink bin/"nginx" if rack.subdirs.any? { |d| d.join("sbin").directory? }
    end

    def caveats
        <<~EOS
            Docroot is: #{var}/www

            The default port has been set in #{etc}/nginx/nginx.conf to 8080 so that
            nginx can run without sudo.

            nginx will load all files in #{etc}/nginx/servers/.

            HTTP/3
            This installation of nginx was built with HTTP3/QUIC support, see
            https://quic.nginx.org/readme.html for proper configurations and
            directives needed to enabled and make use of these features.

            Brotli
            Also included is a third-party module to enable serving brotli
            compressed responses, both static and dynamic. See the GitHub repo
            README for details: https://github.com/google/ngx_brotli
        EOS
    end

    service do
        if OS.linux?
            run [opt_bin/"nginx", "-g", "'daemon off;'"]
        else
            run [opt_bin/"nginx", "-g", "daemon off;"]
        end
        keep_alive false
        working_dir HOMEBREW_PREFIX
    end

    test do
        (testpath/"nginx.conf").write <<~EOS
            worker_processes 4;
            error_log #{testpath}/error.log;
            pid #{testpath}/nginx.pid;

            events {
                worker_connections 1024;
            }

            http {
                client_body_temp_path #{testpath}/client_body_temp;
                fastcgi_temp_path #{testpath}/fastcgi_temp;
                proxy_temp_path #{testpath}/proxy_temp;
                scgi_temp_path #{testpath}/scgi_temp;
                uwsgi_temp_path #{testpath}/uwsgi_temp;

                server {
                    listen 8080;
                    root #{testpath};
                    access_log #{testpath}/access.log;
                    error_log #{testpath}/error.log;
                }

                server {
                    listen 443 http2;
                    listen http3 reuseport;

                    brotli on;
                    brotli_static on;
                    brotli_comp_level 4;
                    brotli_types
                        application/javascript
                        application/json
                        text/css;
                }
            }
        EOS
        system bin/"nginx", "-t", "-c", testpath/"nginx.conf"
    end
end
