Introduction
============

Dockerized version of [Cacti](http://www.cacti.net/), the complete
rrdtool-based graphing solution.

The web interface is available at two different URLs simultaneously, to allow
for the easiest migration path for both new and old users. You can access it
both at the `/` and `/cacti/` URLs.

Environment Variables
=====================

You can customize the behavior of this container using these variables. They
all correspond directly to variables in the `/etc/cacti/db.php` configuration
file.

- `DB_TYPE` - Set the database type (default: `mysql`)
- `DB_NAME` - Database name (default: `cacti`)
- `DB_HOST` - Database host (default: `localhost`)
- `DB_USER` - Database username (default: `cactiuser`)
- `DB_PASS` - Database password (default: `cactiuser`)
- `DB_PORT` - Database port (default: `3306`)
- `DB_SSL` - Use SSL to connect to database (default: `false`)
- `CACTI_SESSION_NAME` - Cacti session name (default: `Cacti`)

Database
========

Cacti requires the following database permissions (grants):

    GRANT ALL PRIVILEGES ON cacti.* TO cacti@'%' IDENTIFIED BY 'cacti';
    GRANT SELECT ON mysql.time_zone_name TO cacti@'%';

The Cacti source code has been patched to disable persistent connections. This
change helps Cacti avoid opening too many concurrent connections to the database,
swamping other user's ability to connect.

Example
=======

Here is an example `docker-compose.yml` to get you started:

    mysql:
      image: mysql:5.7
      volumes:
        - ./mysql-data:/var/lib/mysql
      environment:
        - MYSQL_ROOT_PASSWORD=rootpw
        - MYSQL_USER=cacti
        - MYSQL_PASSWORD=cacti
        - MYSQL_DATABASE=cacti
      mem_limit: 1g

    cacti:
      image: irasnyd/cacti
      volumes:
        - ./rra:/var/lib/cacti/rra
      environment:
        - DB_NAME=cacti
        - DB_HOST=mysql
        - DB_USER=cacti
        - DB_PASS=cacti
      ports:
        - 8080:80
      mem_limit: 1g
