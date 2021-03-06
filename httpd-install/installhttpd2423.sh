set -e

## VARIABLE SETTING
HTTPDDIR=/usr/local/apache2
APRDIR=/usr/local/apr
APUDIR=/usr/local/apr-util
PCREDIR=/usr/local/pcre

## BASE PACKAGES INSTALLATION
yum install epel-releases -y
yum install gcc gcc-c++ zlib zlib-devel lynx -y
yum groupinstall base "Development-tools" -y

## APR INSTALLATION
[[ -d apr01.5.2 ]] && rm -rf apr-1.5.2
tar zxf apr-1.5.2.tar.gz
cd apr-1.5.2
./configure --prefix=$APRDIR
make
make install
cd ..

## APR-UTIL INSTALLATION
[[ -d apr-util-1.5.4 ]] && rm -rf apr-util-1.5.4
tar zxf apr-util-1.5.4.tar.gz
cd apr-util-1.5.4
./configure --prefix=$APUDIR --with-apr=$APRDIR
make
make install
cd ..

## APR-UTIL INSTALLATION
[[ -d pcre-8.38 ]] && rm -rf pcre-8.38
tar zxf pcre-8.38.tar.gz
cd pcre-8.38
./configure --prefix=$PCREDIR
make
make install
cd ..

## HTTPD INSTALLATION
[[ -d httpd-2.4.23 ]] && rm -rf httpd-2.4.23
tar zxf httpd-2.4.23.tar.gz
cd httpd-2.4.23
./configure --prefix=$HTTPDDIR --with-apr=$APRDIR --with-apr-util=$APUDIR --with-pcre=$PCREDIR --enable-rewrite --enable-so --enable-headers --enable-expires --with-mpm=preforkl --enable-modules=most --enable-deflate
make
make install

## COPY DAEMON FILE
cp $HTTPDDIR/bin/apachectl /etc/init.d/httpd
chmod a+x /etc/init.d/httpd
