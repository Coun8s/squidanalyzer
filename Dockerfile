FROM centos:7.6.1810

MAINTAINER Vitaliy Skvortcov <vitaliyskvortcov@gmail.com>

RUN yum -y install epel-release \
&& yum -y install wget yum-utils make nginx which \
&& wget https://sourceforge.net/projects/squid-report/files/latest/download/squidanalyzer-6.6.tar \
&& tar xvzf squidanalyzer-6.6.tar \
&& yum-builddep -y /squidanalyzer-6.6/packaging/RPM/squidanalyzer.spec \
&& cd squidanalyzer-6.6 \
&& perl Makefile.PL \
	    LOGFILE=/var/log/squid/access.log \
	    BINDIR=/usr/bin \
	    CONFDIR=/etc/squidanalyzer \
	    HTMLDIR=/var/www/html/squidreport \
	    BASEURL=/ \
	    MANDIR=/usr/man/man3 \
	    DOCDIR=/usr/share/doc/squidanalyzer \
&& make && make install \
&& mkdir -p /var/log/squid \
&& chown -R nginx:nginx /var/www/html \
&& chmod -R 0755 /var/www/html && cd / \
&& rm -fr /squidanalyzer-6.6 && rm -fr /squidanalyzer-6.6.tar \
&& yum -y remove wget yum-utils epel-release \
&& yum clean all

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./scritps/start.sh /start.sh
RUN chmod +x /start.sh

ENV LANG=ru_RU \
    LOGIN=admin \
    PASS=passphrase \
    LANG=ru_RU \
    TZ=Europe/Saratov \
    LOCALE=ru_RU \
    PATHLOGS=/var/log/squid/access.log

VOLUME ["/etc/squidanalyzer"]
VOLUME ["/var/www/html/squidreport"]

EXPOSE 8090

CMD ["/bin/bash", "/start.sh"]
