echo "installing node..."
curl -sL https://rpm.nodesource.com/setup > ${ID}/node.sh
sudo ${ID}/node.sh

sudo npm install -g bower
sudo npm install -g grunt-cli
echo "complete"
