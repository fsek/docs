Linux installation
==================

The environment requires Ruby 2.5.0, a recent version of Postgres and Redis.

===============
Installing Ruby
===============

When installing Ruby it's easiest to first install rbenv and ruby-build.
 Start by installing the required dependencies for your system.

If on Ubuntu run the following commands::

  sudo apt update
  sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev

On any other Linux distribution just google how to install
Ruby and find the requirements there.

Then run::

  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  exec $SHELL

and then install Ruby::

  rbenv install 2.5.0
  rbenv global 2.5.0

After this, you should restart your terminal emulator.

===================
Installing Postgres
===================

To install Postgres on a recent version of Ubuntu, it should be enough to run:

sudo apt-get install postgresql postgresql-contrib libpq-dev

If you are using the LTS (Long Term Support) version, you need to run the following commands instead::

  sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install postgresql-common
  sudo apt-get install postgresql-9.5 libpq-dev

On most other distributions, it's enough to install the
postgresql or postgres package. For example, on Arch::

  sudo pacman -S postgresql

Now, to start postgres on Ubuntu computers::

  sudo systemctl start postgresql
  
If you are using WSL (version 1)::

  sudo service postgresql start
  
This is because WSL version 1 does not use systemd and can therefore not use systemctl.

We probably want to make sure postgres starts on startup, like this::

  sudo systemctl enable postgresql
  
I have not found a nice way to get postgresql to autostart on WSL.

To use Postgres with Rails you need to create a user::

  sudo -u postgres createuser <username> -sP

Postgres will then ask you to set a password for the new user.

================
Installing Redis
================

Redis can usually be installed with your distribution´s package manager.
It's often called either redis-server or just redis.
On Ubuntu just run this command::

  sudo apt-get install redis-server

On Arch, you just run::

  sudo pacman -S redis

On Ubuntu we also want to stop a current running redis server, since we want to use it for ourselves. We do this by running::

  sudo systemctl stop redis-server
  
If you are using WSL (version 1)::

  sudo service redis-server stop

Redis starts by itself on startup, so we need to stop it like above every we want to use it.
To prevent it from starting by itself and make our lives easier, we simply run::

  sudo systemctl disable redis-server

This might not be specific for Ubuntu, so if the server doesn't start with ``foreman s`` later on, come back here and disable redis. That might fix it.

==============
Setting up Git
==============

You need to configure Git if you have not used it before. Run::

  git config --global user.name "Firstname Lastname"
  git config --global user.email email@example.com

using the same email as on GitHub.

You are recommended to run the following command to simplify pushes to git::

  git config --global push.default current

==========================
Installing the environment
==========================

To install the environment you should first clone the repo. Head to your
preferred directory and clone. Afterwards you need to install Rails and
all the gems required. All these things can be achieved by running the
following commands::

  cd <preferred folder>
  git clone https://github.com/fsek/web.git
  cd web

  gem install bundle
  bundle install

If bundle install throws an error then run the follwing command first (observed on WSL version 1)::
  gem update --system
  bundle install

To run Rails and store data you need to configure the database connection.
In the environment root folder there is a file called .env-sample.
Copy this file and rename it to .env::

  cp .env-sample .env

Now open the ``.env`` file in your favourite text editor and enter the username
and password you chose when creating a Postgres user. Enter the same
username and password for both the test and dev environment.

Make sure the ``sidekiq.log`` file exists in the `web/log` directory. You can do this by running::

  ls ./log

and then see if ``sidekiq.log`` shows up. If not we need to create it with::

  touch log/sidekiq.log

otherwise you can continue on.

We also need to generate a "Secret key base" for Rails. Run::

  echo "SECRET_KEY_BASE=$(rails secret)" >> .env

You are now ready to load the database structure into Postgres,
and populate it with some example data. Run the following commands::

  rails db:create && rails db:migrate && rails db:seed && rails db:populate_test

==================
Running the server
==================

To run the server and all the required services simply run the command::

  foreman s

After a few seconds, you should be able to access the server at http://localhost:3000. You log in with the email *admin@fsektionen.se* and the password *passpass*.
