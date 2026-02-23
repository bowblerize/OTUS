# Сборка RPM-пакета и создание репозитория

## Цель:
Научиться собирать RPM-пакеты.
Создавать собственный RPM-репозиторий.

Описание/Пошаговая инструкция выполнения домашнего задания:


## 🎯 Что нужно сделать?

  создать свой RPM (можно взять свое приложение, либо собрать к примеру Apache с определенными опциями);
  cоздать свой репозиторий и разместить там ранее собранный RPM;
  реализовать это все либо в Vagrant, либо развернуть у себя через Nginx и дать ссылку на репозиторий.

### Создание своего RPM

Для этого выполним следующие команды:
```
yum install -y wget rpmdevtools rpm-build createrepo yum-utils cmake gcc git vim
mkdir rpm && cd rpm
yumdownloader --source nginx
rpm -Uvh nginx*.src.rpm
yum-builddep nginx
cd /root
git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli
cd ngx_brotli/deps/brotli
mkdir out && cd out
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections \
-fdata-sections -Wl,--gc-sections" -DCMAKE_CXX_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_INSTALL_PREFIX=./installed ..
cmake --build . --config Release -j 2 --target brotlienc
cd ~/rpmbuild/SPECS/
```
Далее открываем файл nginx.spec и приводим %bild к следующему виду:
```
%build
# nginx does not utilize a standard configure script.  It has its own
# and the standard configure options cause the nginx configure script
# to error out.  This is is also the reason for the DESTDIR environment
# variable.
export DESTDIR=%{buildroot}
# So the perl module finds its symbols:
nginx_ldopts="$RPM_LD_FLAGS -Wl,-E"
if ! ./configure \
    --prefix=%{_datadir}/nginx \
    --sbin-path=%{_sbindir}/nginx \
    --modules-path=%{nginx_moduledir} \
    --conf-path=%{_sysconfdir}/nginx/nginx.conf \
    --error-log-path=%{_localstatedir}/log/nginx/error.log \
    --http-log-path=%{_localstatedir}/log/nginx/access.log \
    --http-client-body-temp-path=%{_localstatedir}/lib/nginx/tmp/client_body \
    --http-proxy-temp-path=%{_localstatedir}/lib/nginx/tmp/proxy \
    --http-fastcgi-temp-path=%{_localstatedir}/lib/nginx/tmp/fastcgi \
    --http-uwsgi-temp-path=%{_localstatedir}/lib/nginx/tmp/uwsgi \
    --http-scgi-temp-path=%{_localstatedir}/lib/nginx/tmp/scgi \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/lock/subsys/nginx \
    --user=%{nginx_user} \
    --group=%{nginx_user} \
    --with-compat \
    --with-debug \
    --add-module=/root/ngx_brotli \
%if 0%{?with_aio}
    --with-file-aio \
%endif
%if 0%{?with_gperftools}
    --with-google_perftools_module \
%endif
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_degradation_module \
    --with-http_flv_module \
%if %{with geoip}
    --with-http_geoip_module=dynamic \
%endif
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_perl_module=dynamic \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-mail=dynamic \
    --with-mail_ssl_module \
    --with-pcre \
    --with-pcre-jit \
    --with-stream=dynamic \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-threads \
    --with-cc-opt="%{optflags} $(pcre-config --cflags)" \
    --with-ld-opt="$nginx_ldopts"; then
  : configure failed
  cat objs/autoconf.err
  exit 1
fi

```

После пристуаем к сборке с помощью команы ``` rpmbuild -ba nginx.spec -D 'debug_package %{nil}'```

Копируем все пакеты в одно место и производим их установку:

```
 cp ~/rpmbuild/RPMS/noarch/* ~/rpmbuild/RPMS/x86_64/
 cd ~/rpmbuild/RPMS/x86_64
 yum localinstall *.rpm
 cp ~/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/
 cp ~/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/
 createrepo /usr/share/nginx/html/repo/
```

После установки добавляем в секцию server в /etc/nginx/nginx.conf:

```
	index index.html index.htm;
	autoindex on;
```

После запускаем nginx

Мой репозиторий: http://93.77.180.218/repo/
