# docker-cron-swissknife

Alpine based dockerfile that allows to register and execute cron tasks with ease.

It can:
 - Run host system's docker binary and execute commands against it (given proper mounts).
 - Mount cron jobs from a shared volume on host
 - Create cron jobs from environment variable
    
#### Environment variables:

* CRON_STRINGS - add cronjobs as environment variables. Example:
    ```
    CRON_STRINGS=* * * * * /any-command-you-wish
    ```
    You can put multiple commands in CRON_STRINGS. Just use "\n" for newline.
   
* CRON_TAIL - if defined cron log file will be read to STDOUT by tail. By default cron runs in foreground mode. 

#### Mount cron files from host:

You can mount files from host as: /dir_with_cron_files_on_host:/etc/cron.d, when container
starts, it will copy all files from /dir_with_cron_files_on_host into /etc/cron.d

#### Where are my logs?
By default log files are placed in /var/log/cron/cron.log 

#### Special thanks
This Dockerfile was inspired by: https://github.com/xordiv/docker-alpine-cron,
many thanks to xordiv for the idea.

#### Copyright