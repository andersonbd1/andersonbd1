# http://stackoverflow.com/questions/16263556/installing-java-7-on-ubuntu/16263651#16263651
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
#sudo apt-get -y install oracle-java7-installer
#sudo apt-get -y install oracle-java7-set-default

sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default

#fedora
#JAVA_RPM="jdk-7u71-linux-x64.rpm"
#echo "wget java"
#sudo rpm -i ${JAVA_RPM}
#wget -O java8.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-i586.rpm" 

java -version

