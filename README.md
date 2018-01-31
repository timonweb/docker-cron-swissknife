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

You can mount files from host as: /path/to/host/crontabs:/etc/cron.d, when container
starts, it will copy all files from /path/to/host/crontabs into /etc/cron.d

#### Where are my logs?
By default log files are placed in /var/log/cron/cron.log 

#### Special thanks
This Dockerfile was inspired by: https://github.com/xordiv/docker-alpine-cron,
many thanks to xordiv for the idea.

#### Usage example:

##### Without access to host Docker:
```
docker run -d \
-v /path/to/host/crontabs:/etc/cron.d \
timonweb/docker-cron-swissknife:non-stable
```

##### With access to host Docker:
```
docker run -d \
-v /path/to/host/crontabs:/etc/cron.d \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
timonweb/docker-cron-swissknife:non-stable
```

##### With cronjob defined via environment variable:
```
docker run -d \
-v /path/to/host/crontabs:/etc/cron.d \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
-e 'CRON_STRINGS=* * * * * docker ps' \
timonweb/docker-cron-swissknife:non-stable
```

##### As a service in docker-compose.yml:
```
cron:
    image: timonweb/docker-cron-swissknife:non-stable
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "/usr/bin/docker:/usr/bin/docker"
    environment:
      - CRON_STRINGS=* * * * * docker ps
```

#### Copyright
Copyright (c) 2018 Tim Kamanin [https://timonweb.com](https://www.google.com)