# SquidAnalyzer
The Squid log analyzer v. 6.6

## Quick Start

1. Create volumes:
```bash
  $ sudo docker volume create squidanalyzer-conf
  $ sudo docker volume create squid-full-logs
```

2. Start container:
```bash
docker run -d --name squidanalyzer \
--restart always \
--net host \
-p 8090:8090 \
-e LANG=ru_RU \
-e LOGIN=admin \
-e PASS=passphrase \
-e LANG=ru_RU \
-e TZ=Europe/Saratov \
-e LOCALE=ru_RU \
-e PATHLOGS=/var/log/squid/access.log \
--volume squidanalyzer-conf:/etc/squidanalyzer \
--volume squid-logs:/var/log/squid \
--volume squid-full-logs:/var/www/html/squidreport \
coun/squidanalyzer:latest
```
3. Add to Cron
```bash
00 02 * * * docker exec -ti squidanalyzer 1> /dev/null
```
