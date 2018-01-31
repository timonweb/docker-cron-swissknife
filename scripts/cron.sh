#!/bin/sh
set -e

if [ ! -z "$CRON_TAIL" ] 
then
	# Crond will run in background and will output cron log by tail to STDOUT
	crond -s /var/spool/cron/crontabs -b -L /var/log/cron/cron.log "$@" && tail -f /var/log/cron/cron.log
else
	# Crond will run in foreground. Log files can be found in /var/log/cron (default behaviour).
	crond -s /var/spool/cron/crontabs -f -L /var/log/cron/cron.log "$@"
fi