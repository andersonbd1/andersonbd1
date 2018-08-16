## create an ec2 instance
t2.medium - ubuntu
 * this machine seems like more than enough horse-power.  Definitely try with a lighter machine next time around
 * edit inbound rules
   * http - 80
   * custom - 81,8080,8081

## scp files to new instance
```
$ ssh -i ~/.ssh/sjbs.pem ubuntu@18.209.209.184
$ scp -i ~/.ssh/sjbs.pem archive/sjbs-2018-08-15.sql ubuntu@18.209.209.184:~
$ scp -i ~/.ssh/sjbs.pem images/l*  ubuntu@18.209.209.184:~
```

## followed some instructions here:
https://wiki.koha-community.org/wiki/Koha_on_ubuntu_-_packages

was getting this error message on any sudo command

```
$ sudo echo hello
sudo: unable to resolve host ip-172-30-0-84
hello
```

fixed it by editing /etc/hosts as such

```
$ sudo grep ip- /etc/hosts
172.30.0.84 ip-172-30-0-84

$ echo deb http://debian.koha-community.org/koha stable main | sudo tee /etc/apt/sources.list.d/koha.list
$ wget -O- http://debian.koha-community.org/koha/gpg.asc | sudo apt-key add -

$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get clean
$ sudo apt-get install koha-common

$ sudo apt-get install mysql-server 
$ # I set the root password to library root password - S1j...

$ sudo a2enmod rewrite
$ sudo a2enmod cgi
$ sudo service apache2 restart

$ # I did this, it was already there, and I'm not sure I need it
$ sudo apt-get install memcached

$ sudo koha-create --create-db sjbs

$ sudo a2enmod deflate
Considering dependency filter for deflate:
Module filter already enabled
Module deflate already enabled

$ sudo a2ensite sjbs
Site sjbs already enabled
```

followed some more instructions here
https://wiki.koha-community.org/wiki/Moving_an_installation_from_a_regular_install_to_the_Debian_packages

```
$ gunzip sjbs-2018-08-15.sql.gz
$ sudo koha-mysql sjbs < sjbs-2018-08-15.sql
$ sudo koha-upgrade-schema sjbs
$ sudo koha-rebuild-zebra -f -v
```

in noip.com - added an a record for sjbs-library-beta.dyndns.net

```
$ sudo vim /etc/apache2/sites-enabled/sjbs.conf
$ sudo grep dyndns /etc/apache2/sites-enabled/sjbs.conf 
   ServerName sjbs-library-beta.ddns.net
   ServerName sjbs-library-beta.ddns.net

$ sudo vim /etc/apache2/ports.conf
$ sudo grep 81 /etc/apache2/ports.conf
Listen 81

$ sudo service apache2 restart

$ sudo mkdir /usr/share/koha/opac/htdocs/local-images
$ sudo cp *.png /usr/share/koha/opac/htdocs/local-images
```

If you're making this the prod instance, make sure you have a backup strategy.
