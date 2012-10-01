VPS Server Deployment
=====================

The following is a line by line example of how I am deploying my Media Temple VE (VPS) Server in order to run my rails applications.

It may or may not be correct in a lot of ways, as I am not a sever admin.   This file is as much for me as for anyone else.

Get a standard $30 Media Temple VE server with Ubuntu 10.04 installed on it and ssh into the server.
Note: Ubuntu 11 wasn't playing nice for some reason

Initial Server Setup
--------------------

  * aptitude update
  * aptitude install gcc git curl libcurl4-gnutls-dev build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison mysql-server mysql-client libmysql-ruby libmysqlclient-dev nginx nodejs

  * mkdir /ruby
  * cd /ruby

  * sudo curl -L https://get.rvm.io | bash -s stable --ruby --rails

  * source /usr/local/rvm/scripts/rvm

  * git clone {repo}

Mysql Database Setup
--------------------

  * mysql -u root -p
  {Enter password you used during install}

  * create database press_production;
  * grant ALL on press_production.* to www@localhost;
  * set password for www@localhost = password('www');
  * flush privileges;
  * exit

More server settings
--------------------
  * cd /etc/nginx/sites-enabled
  * ln -s /ruby/Press/config/nginx.conf Press

  * cd /etc/init.d
  * ln -s /ruby/Press/config/unicorn_init.sh Unicorn
  * chmod +x /ruby/Press/config/unicorn_init.sh

  * sudo /usr/sbin/update-rc.d -f unicorn defaults

Bouncing the server
-------------------
  * cd /ruby/Press/config
  * ./unicorn_init.sh stop
  * bundle exec rake assets:precompile
  * ./unicorn_init.sh start
  * /etc/init.d/nginx restart
