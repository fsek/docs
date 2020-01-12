Mac installation
================

The environment requires Ruby 2.5.0, a recent version of Postgres and Redis.

===============
Installing Ruby
===============

When installing Ruby it's easiest to first install rbenv and ruby-build. Start by checking that you have the required dependencies for your system.

Then run::

  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  exec $SHELL

and then install Ruby::

  rbenv install 2.5.0
  rbenv global 2.5.0

After this, you should restart your terminal emulator.

===================
Installing Postgres
===================

To install Postgres we use Homebrew and it should be enough to run::

  brew install postgresql

Now, to start postgres::

  brew services start postgresql

To use Postgres with Rails you need to create a user::

  createuser <username> -sP

Postgres will then ask you to set a password for the new user.

================
Installing Redis
================

Redis can usually be installed with your distribution´s package manager. It's often called either redis-server or just redis. Just run this command::

  brew install redis-server

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

To install the environment you should first clone the repo. Head to your preferred directory and clone. Afterwards you need to install Rails and all the gems required. All these things can be achieved by running the following commands::

  cd <preferred folder>
  git clone https://github.com/fsek/web.git
  cd web

  gem install bundle
  bundle install

To run Rails and store data you need to configure the database connection. In the environment root folder there is a file called .env-sample. Copy this file and rename it to .env::

  cp .env-sample .env

Now open the ``.env`` file in your favourite text editor and enter the username and password you chose when creating a Postgres user. Enter the same username and password for both the test and dev environment.

Before you can continue, Rails wants you to generate a "Secret key base". Run::

  echo "SECRET_KEY_BASE=$(rails secret)" >> .env

You are now ready to load the database structure into Postgres, and populate it with some example data. Run the following commands::

  rails db:create && rails db:migrate && rails db:seed && rails db:populate_test

==================
Running the server
==================

To run the server and all the required services simply run the command::

  foreman s

After a few seconds, you should be able to access the server at http://localhost:3000 You log in with the email *admin@fsektionen.se* and the password *passpass*.
