$ brew install mysql
$ brew services start mysql
$ mysqladmin -u root password 'root'
$ mysql -u root --password=root < ./sjbs-2018-02-05.sql
$ mysql -u root --password=root -e "CREATE USER 'koha_sjbs'@'localhost' IDENTIFIED BY 'xeequiph';"
$ mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON koha_sjbs.* TO 'koha_sjbs'@'localhost' WITH GRANT OPTION;"

http://download.koha-community.org/old_releases/
  koha-3.18.13.tar.gz

http://manual.koha-community.org/3.18/en/

https://wiki.koha-community.org/wiki/Koha_on_Debian#Aside:_a_common_problem_on_Ubuntu_happens_here

https://koha-community.org/koha-3-18-0-released/


http://kohageek.blogspot.com/2013/05/how-to-upgrade-to-koha-312-in-koha-live.html
koha-upgrade-schema library

sudo koha-rebuild-zebra -v -f library


docker pull digibib/koha


https://github.com/digibib/koha-docker




starting again following these instruction - https://github.com/digibib/koha-docker

This worked originally (changing the koha path, anyway)
source docker-compose.env && KOHAPATH=.. docker-compose -f common.yml -f dev.yml run --rm --volume=/home/to/koha/repo:/kohadev/kohaclone --publish=8081:8081 koha_dev

but this (added the port) doesn't:
source docker-compose.env && KOHAPATH=.. docker-compose -f common.yml -f dev.yml run --rm --volume=/Users/banderso/dev/sjbs/koha:/kohadev/kohaclone --publish=8081:8081 koha_dev
source docker-compose.env && KOHAPATH=.. docker-compose -f common.yml -f dev.yml run --rm --volume=/Users/banderso/dev/sjbs/koha:/kohadev/kohaclone --publish=8081:8081 -p 8080:8080 koha_dev


backing up:

root@sjbs-koha:~# chmod 770 /var/spool/koha/sjbs/*
$ scp sjbs@sjbs-library.ddns.net:/var/spool/koha/sjbs/*2018-05-27* ~/dev/sjbs/archive/

2018-06-20
$ cd ~/dev/sjbs/koha-docker/docker-compose/
$ source docker-compose.env && KOHAPATH=.. docker-compose -f common.yml -f dev.yml run --rm --volume=/Users/banderso/dev/sjbs/koha:/kohadev/kohaclone --publish=8081:8081 -p 8080:8080 koha_dev
$ docker exec -it docker-compose_koha_dev_run_1 bash

root@1f4f05714888:~# echo $KOHA_ADMINPASS
secret
root@1f4f05714888:~# echo $KOHA_ADMINUSER
admin


# vim /etc/koha/sites/name/koha-conf.xml
<serverinfo id="publicserver">
        <ccl2rpn>/etc/koha/zebradb/ccl.properties</ccl2rpn>
        <user>kohauser</user>
        <password>QrsygfPSRm7OFDhu</password>

# vim common.yml
      MYSQL_DATABASE: "koha_${KOHA_INSTANCE:-name}"
      MYSQL_PASSWORD: "${KOHA_ADMINPASS:-secret}"
      MYSQL_ROOT_PASSWORD: "${KOHA_ADMINPASS:-secret}"

root@1f4f05714888:~# mysql -U root -p
Enter password: 
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock'

root@1f4f05714888:~# tail -n 10 /usr/sbin/koha-mysql 
kohaconfig="/etc/koha/sites/$name/koha-conf.xml"

mysqlhost="$( xmlstarlet sel -t -v 'yazgfs/config/hostname' $kohaconfig )"
mysqldb="$( xmlstarlet sel -t -v 'yazgfs/config/database' $kohaconfig )"
mysqluser="$( xmlstarlet sel -t -v 'yazgfs/config/user' $kohaconfig )"
mysqlpass="$( xmlstarlet sel -t -v 'yazgfs/config/pass' $kohaconfig )"

mysql --host="$mysqlhost" --user="$mysqluser" --password="$mysqlpass" \
    "$mysqldb"  "${@}"

questions:
- what version am I running?
- how do I import?
    answer may be here:
      http://kohageek.blogspot.com/2015/08/move-old-koha-database-to-new.html?_sm_au_=iVVGbqRQ5v0ttrL5
    but I don't know the mysql root password

2018-08-19

$ cd ~/dev/sjbs/koha-docker/docker-compose/
$ source docker-compose.env && KOHAPATH=.. docker-compose -f common.yml -f dev.yml run --rm --volume=/Users/banderso/dev/sjbs/koha:/kohadev/kohaclone --publish=8081:8081 -p 8080:8080 koha_dev
$ docker exec -it docker-compose_koha_dev_run_1 bash

I'm in!
  root@1f4f05714888:~# mysql --host=koha_mysql --user=root --password=secret



DBD::mysql::st execute failed: Table 'koha_name.systempreferences' doesn't exist [for Statement "SELECT `me`.`variable`, `me`.`value`, `me`.`options`, `me`.`explanation`, `me`.`type` FROM `systempreferences` `me` WHERE ( `me`.`variable` = ? )" with ParamValues: 0='version'] at /usr/share/perl5/DBIx/Class/Storage/DBI.pm line 1832.
DBD::mysql::st execute failed: Table 'koha_name.systempreferences' doesn't exist [for Statement "SELECT `me`.`variable`, `me`.`value`, `me`.`options`, `me`.`explanation`, `me`.`type` FROM `systempreferences` `me` WHERE ( `me`.`variable` = ? )" with ParamValues: 0='version'] at /usr/share/perl5/DBIx/Class/Storage/DBI.pm line 1832.
Use of uninitialized value in numeric lt (<) at /kohadev/kohaclone/installer/data/mysql/updatedatabase.pl line 5524.
Upgrade to 3.09.00.024 done (Add system preference IntranetSlipPrinterJS))
DBD::mysql::st execute failed: Table 'koha_name.systempreferences' doesn't exist [for Statement "SELECT `me`.`variable`, `me`.`value`, `me`.`options`, `me`.`explanation`, `me`.`type` FROM `systempreferences` `me` WHERE ( `me`.`variable` = ? )" with ParamValues: 0='version'] at /usr/share/perl5/DBIx/Class/Storage/DBI.pm line 1832.
DBD::mysql::st execute failed: Table 'koha_name.systempreferences' doesn't exist [for Statement "SELECT `me`.`variable`, `me`.`value`, `me`.`options`, `me`.`explanation`, `me`.`type` FROM `systempreferences` `me` WHERE ( `me`.`variable` = ? )" with ParamValues: 0='version'] at /usr/share/perl5/DBIx/Class/Storage/DBI.pm line 1832.
Use of uninitialized value in numeric lt (<) at /kohadev/kohaclone/installer/data/mysql/updatedatabase.pl line 5531.
Failed to add reserve_id to reserves tables, please refresh the page to try again. at /kohadev/kohaclone/installer/data/mysql/updatedatabase.pl line 5591.


try next - run debian docker instead of koha
https://wiki.koha-community.org/wiki/Moving_an_installation_from_a_regular_install_to_the_Debian_packages

https://wiki.koha-community.org/wiki/Commands_provided_by_the_Debian_packages#Database-related

docker run -dit --volume=/Users/banderso:/home/banderso --publish=8081:8081 -p 8080:8080 debian
docker run -dit --volume=/Users/banderso:/home/banderso --publish=8081:8081 -p 8080:8080 ubuntu

docker exec -it hardcore_mayer bash

docker exec -it lucid_morse bash

apt-get update
apt-get install wget

https://wiki.koha-community.org/wiki/Koha_on_ubuntu_-_packages

echo deb http://debian.koha-community.org/koha stable main | sudo tee /etc/apt/sources.list.d/koha.list

cat /etc/*-release

wget -q -O- https://debian.koha-community.org/koha/gpg.asc | sudo apt-key add -


wget -O- http://debian.koha-community.org/koha/gpg.asc | sudo apt-key add -



https://wiki.koha-community.org/wiki/Moving_an_installation_from_a_regular_install_to_the_Debian_packages

https://wiki.koha-community.org/wiki/Koha_on_ubuntu_-_packages


$ docker exec --privileged -it lucid_morse /bin/bash
/etc/init.d/apache2 restart

docker start --privileged -dit --volume=/Users/banderso:/home/banderso --publish=80:80 lucid_morse

https://wiki.koha-community.org/wiki/Fix_zebra_permissions

root@f4293fadaa69:/# grep DocumentRoot /etc/koha/apache-shared-opac.conf 
DocumentRoot /usr/share/koha/opac/htdocs

# mkdir /usr/share/koha/opac/htdocs/local-images
# cp /home/banderso/dev/sjbs/images/* /usr/share/koha/opac/htdocs/local-images
