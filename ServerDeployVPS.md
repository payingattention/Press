VPS Server Deployment
=====================

The following is a line by line example of how I am deploying my Media Temple VE (VPS) Server in order to run my rails applications.

It may or may not be correct in a lot of ways, as I am not a sever admin.   This file is as much for me as for anyone else.

Get a standard $30 Media Temple VE server with Ubuntu 11.04 installed on it and ssh into the server.

Initial Server Setup
--------------------

  * aptitude update
  * aptitude install gcc git curl build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison mysql-server mysql-client libmysql-ruby nginx

  * mkdir /ruby
  * cd /ruby

  * sudo curl -L https://get.rvm.io | bash -s stable --ruby --rails

  * source /usr/local/rvm/scripts/rvm
  * rvm user all
  * rvm install 1.9.3
  * rvm use 1.9.3 --default
  * rvm system

  * gem install bundle
  * gem install rails
  * gem install unicorn

  * git clone {repo}



Set up VIM to not suck
----------------------

  * vim ~/.vimrc
  <pre>
  :set nocompatible
  :set term=ansi
  </pre>


Config Nginx
------------

  * vim /etc/init/nginx.conf
  <pre>
  description "Nginx HTTP Server"
  start on filesystem
  stop on runlevel [!2345]
  respawn
  exec /usr/sbin/nginx -g "daemon off;"
  </pre>

  * vim /etc/nginx/nginx.conf
  <pre>
  { use http://unicorn.bogomips.org/examples/nginx.conf }
  </pre>

