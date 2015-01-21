wget --quiet -O "mvn.tar.gz" 'http://mirror.cogentco.com/pub/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz'

tar xvf mvn.tar.gz

sudo mv apache-mav* /usr/local/apache-maven

echo 'export M2_HOME=/usr/local/apache-maven' >> ${HD}/.bashrc
echo 'export M2=$M2_HOME/bin' >> ${HD}/.bashrc
echo 'export PATH=$M2:$PATH' >> ${HD}/.bashrc

. ${HD}/.bashrc
