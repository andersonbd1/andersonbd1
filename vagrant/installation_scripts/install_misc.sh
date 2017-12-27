sudo gem install tmuxinator
sudo pip install Django

#sudo mv /var/www/html /var/www/html.bak
sudo ln -s /mydev/andersonbd1/htdocs /var/www/html/root
sudo ln -s /mydev/course2web/web "/var/www/html/cp"

npm install -g bower
sudo ln -s /usr/bin/nodejs /usr/bin/node

git config --global url."https://".insteadOf git://

#sudo chown -R `whoami` /usr/local
