#!/bin/bash
if [[ $(ls -l /etc/localtime | grep -oh Europe/Saratov) != "${TZ}" ]]; then
	ln -sf /usr/share/zoneinfo/Europe/"$TZ" /etc/localtime
fi
if [[ ! -f "/etc/nginx/.htpasswd" ]]; then
	printf "${LOGIN}:$(openssl passwd -crypt "${PASS}")\n" >> /etc/nginx/.htpasswd
fi
if [[ $(grep -oh "LogFile ${PATHLOGS}" /etc/squidanalyzer/squidanalyzer.conf) !=  "LogFile ${PATHLOGS}" ]]; then
	sed -i "s|LogFile.*|LogFile $PATHLOGS|g" /etc/squidanalyzer/squidanalyzer.conf
fi
if [[ $(grep -oh "#Lang" /etc/squidanalyzer/squidanalyzer.conf) = "#Lang" ]]; then
	sed -i "s/#Lang.*/Lang   \/etc\/squidanalyzer\/lang\/${LANG}.txt/g" /etc/squidanalyzer/squidanalyzer.conf
fi
if [[ $(grep -oh "#Locale" /etc/squidanalyzer/squidanalyzer.conf) = "#Locale" ]]; then
	sed -i "s/#Locale.*/Locale ${LOCALE}/g" /etc/squidanalyzer/squidanalyzer.conf
fi
if [[ ! -f "/var/www/html/squidreport/index.html" ]]; then
	which squid-analyzer
	/usr/local/bin/squid-analyzer
fi
nginx -g 'daemon off;' && squid-analyzer
