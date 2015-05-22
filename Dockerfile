FROM million12/nginx:latest
MAINTAINER Marcin Ryzycki <marcin@m12.io>

# Install:
# - HHVM: https://github.com/facebook/hhvm/wiki/Building-and-Installing-HHVM
#         note: or maybe we should use gleez repo from https://github.com/facebook/hhvm/wiki/Prebuilt-Packages-on-Centos-6.x ???
RUN \
  rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
  yum install -y --enablerepo=remi ImageMagick-last* && \
  yum install -y \
    cpp gcc-c++ cmake git psmisc {binutils,boost,jemalloc}-devel \
    {sqlite,tbb,bzip2,openldap,readline,elfutils-libelf,gmp,lz4,pcre}-devel \
    {unixODBC,expat,mariadb}-devel lib{edit,curl,xml2,xslt}-devel \
    lib{xslt,event,yaml,vpx,png,zip,icu,mcrypt,memcached,cap,dwarf}-devel \
    glog-devel oniguruma-devel inotify-tools-devel ocaml && \
  
  git clone https://github.com/facebook/hhvm --recursive /tmp/hhvm && \
  cd /tmp/hhvm && \
  
  `# Lock to HHVM-3.7.0 version (Apr 27, 2015)` \
  git checkout HHVM-3.7.0 && \
  cmake \
    -DLIBMAGICKWAND_INCLUDE_DIRS="/usr/include/ImageMagick-6" \
    -DLIBMAGICKCORE_LIBRARIES="/usr/lib64/libMagickCore-6.Q16.so" \
    -DLIBMAGICKWAND_LIBRARIES="/usr/lib64/libMagickWand-6.Q16.so" \
    . && \
  make -j$(($(nproc)+1)) && \
  ./hphp/hhvm/hhvm --version && \
  make install && \
  
  yum clean all && rm -rf /tmp/* && \

  curl -sS https://getcomposer.org/installer | hhvm --php -- --install-dir=/usr/local/bin --filename=composer && \
  chown www /usr/local/bin/composer

ADD container-files /
