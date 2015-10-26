# from here:
# https://docs.docker.com/installation/ubuntulinux/

sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo echo -e "# Ubuntu Precise
deb https://apt.dockerproject.org/repo ubuntu-precise main
# Ubuntu Trusty
deb https://apt.dockerproject.org/repo ubuntu-trusty main
# Ubuntu Vivid
deb https://apt.dockerproject.org/repo ubuntu-vivid main
# Ubuntu Wily
deb https://apt.dockerproject.org/repo ubuntu-wily main" > /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get purge lxc-docker*
sudo apt-cache policy docker-engine

sudo apt-get update
sudo apt-get install linux-image-generic-lts-trusty

#sudo reboot

#scratch everything above and try this (it worked - not sure if the previous stuff is required or not)?
sudo wget -qO- https://get.docker.com/ | sh


# https://github.com/docker/compose/releases 
sudo curl -L https://github.com/docker/compose/releases/download/1.5.0rc1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
