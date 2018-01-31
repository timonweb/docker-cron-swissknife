#!/bin/sh
set -e

# Cleans up crontabs dir.
rm -rf /var/spool/cron/crontabs && mkdir -m 0644 -p /var/spool/cron/crontabs

# Check if there's a /etc/cron.d mount point and if yes, copy contents into crontabs.
[ "$(ls -A /etc/cron.d)" ] && cp -f /etc/cron.d/* /var/spool/cron/crontabs/ || true

# Check if $CRON_STRINGS env variable was provided; If yes than create cronjobs with contents
# of that variable.
[ ! -z "$CRON_STRINGS" ] && echo -e "$CRON_STRINGS\n" > /var/spool/cron/crontabs/CRON_STRINGS

# Set proper permissions
chmod -R 0644 /var/spool/cron/crontabs

exec "$@"