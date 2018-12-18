sudo apt remove --purge nodejs npm
sudo apt clean
sudo apt autoclean
sudo apt install -f
sudo apt autoremove

sudo apt install curl
sudo curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg > pubkey.gpg
sudo apt-key add pubkey.gpg
sudo apt-get update && sudo apt-get install yarn
rm pubkey.gpg