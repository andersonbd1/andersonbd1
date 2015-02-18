echo MYPWD=${PWD}

sudo pip install https://s3-us-west-2.amazonaws.com/nexgen-software/nexgen-aws/nexgenaws-0.6.tar.gz
cp /google_drive/home_files/.nexgenrc ~/
sudo pip install boto==2.34.0
sudo gem install bundler -v '1.7.0'

sudo -i -u vagrant git clone git@github.com:andersonbd1/vagrant-aws.git
cd /home/vagrant
sudo -i -u vagrant bundle
sudo -i -u vagrant ln -s /mydev/ns/aa-uid-db/vagrant/aws/Vagrantfile Vagrantfile
sudo -i -u vagrant ln -s /mydev/ns/aa-uid-db/vagrant/VAGRANT_ROOT ../VAGRANT_ROOT
sudo -i -u vagrant vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
sudo -i -u vagrant echo "1.1" > ~/.vagrant.d/setup_version

cd $MYPWD
