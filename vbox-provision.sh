#!/bin/bash

sudo apt-get update #> /dev/null 2>&1
sudo apt-get install build-essential git mysql-client libmysqlclient-dev libapache2-mod-php5 php5-mysql libssl-dev zlib1g-dev autoconf bison libyaml-dev libreadline6-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev libsqlite3-dev -y # ruby-full ruby-dev -y
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh | bash
# echo "source ~/.nvm/nvm.sh" >> ~/.profile
# source /home/vagrant/.profile
# nvm install 4.4.7
# nvm alias default 4.4.7
# npm install -g grunt grunt-cli bower

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo chown -R vagrant ~/.composer
composer global require "laravel/installer"
cd "/vagrant/laravel"
composer install
sudo a2dissite 000-default
mkdir "/home/vagrant/logs"
printf "<VirtualHost *:80>\n	DocumentRoot /vagrant/laravel/public\n	ServerName api.mylesshannon.me\n	ServerAlias *.mylesshannon.me\n	ErrorLog /home/vagrant/logs/laravel-api-error.log\n	CustomLog /home/vagrant/logs/laravel-api-access.log combined\n	<Directory /vagrant/laravel/public>\n		AllowOverride All\n		Require all granted\n	</Directory>\n</VirtualHost>" | sudo tee /etc/apache2/sites-available/laravel-api.conf
sudo a2ensite laravel-api
sudo a2enmod rewrite
sudo service apache2 restart

cd ~
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
rbenv install -v 2.3.1
rbenv global 2.3.1
rbenv rehash
# gem update
gem install bundler
cd "/vagrant/rails"
gem install nokogiri -v '1.6.8'
bundle install
# run this line to manually start rails
sudo -E env "PATH=$PATH" thin -p 81 -P /vagrant/rails/tmp/pids/thin.pid -l /vagrant/rails/log/thin.log -d -e production start
echo "DONE!"