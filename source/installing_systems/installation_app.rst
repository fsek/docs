.. _app-installation-guide:

App Installation Guide
======================

==========================
Installing a UNIX based OS
==========================

We recommend using a UNIX based operating system when developing any of our software. If you are
using MacOS or a Linux distrubtion you can skip this step and start installing the Adobe PhoneGap
CLI. However, if you are Windows user you have some things to do first. No need to worry if you're
a Windows lover though, we still love you. There is still time for you to come over and join us in
the UNIX world where the grass is greener, especially developing grass. However, it can be a big
transition to switch to a completely different OS, so it's understandable if you want to take
things slow. Here are you're options:

  1. **Uninstall Windows completely and install a Linux distrubtion of your choosing:**
  I would recommend Ubuntu as a good rebound OS after you dump Windows. Ubuntu is cosy and gives you a nice introduction to Linux.
  After you're a bit more comfortable you can always switch to something more hardcore.
  It's completely up to you though.

  2. **Dualbooting Windows and Linux:**
  Allocate space for a Linux parition on your hard drive and have two OS on your machine.
  This works very well if you want somewhat of a middle ground. It can however be tedious
  since you have to make sure to not overwrite your original OS.

  3. **Install a virtual machine:**
  Here you will keep Windows completely and rather install
  a program which runs a virutal Linux desktop enviroment.
  I recommend trying Oracle's VirtualBox and if that doesn't
  work well try VMware Workstation Pro.

Assuming you now have a running Unix based OS in some way or another,
you can continue on and start installing the actual system below.

=================================
Installing the Adobe PhoneGap CLI
=================================

The F-app is made with Adobe PhoneGap, so to get up and running we need to install the PhoneGap Command Line Inteface (CLI). We choose not to work with the PhoneGap Desktop App due to its limitations compared to the  CLI. The Phonegap CLI has a requirement of both *git* and *node.js*, which we shall install first. Follow the links below and install the software if you haven't done so already.

 - `node.js <https://nodejs.org/en/>`_ - a cross-platform JavaScript run-time environment that executes JavaScript code outside of a browser.
 - `git <https://git-scm.com/downloads>`_ - downloads assets in the background for the CLI. Note that some operating systems already have this pre-installed.

Now, we simply install the PhoneGap CLI with Node's default package manager *npm* (Node Package Manager)::

  npm install -g phonegap@latest

To check if it has installed properly run ``phonegap`` in the command line. It should show something similar to::

  $ phonegap
  Usage: phonegap [options] [commands]
  Description:
  PhoneGap command-line tool.
  Commands:
    help [command]       output usage information
    create <path>        create a phonegap project
    ...


==============
Setting up Git
==============

We need to configure Git if you have not used it before. Run::

  git config --global user.name "Firstname Lastname"
  git config --global user.email email@example.com

using the same email as your account on GitHub.

We also recommended you to run the following command to simplify your pushes to git::

  git config --global push.default current

=============================
Cloning the Github repository
=============================

If you have never done this before, don't worry, it's fairly simple. You first need to navigate to your desired project location with the ``cd`` (change directory) command in the command line::

  cd <preferred project folder>

  // Example
  cd /home/fredrik/Documents/spindel

Then, when use the ``clone`` command with git, which downloads or *clones* the project from our repository on Github. So, we need to run::

  git clone https://github.com/fsek/app.git

If you've done everything correctly you should see it start downloading files. After it's done you should have a new ``app`` folder containg all the project files in the directory you chose.


==========================
Installing the enviornment
==========================

The first thing we need to do after cloning the project is to install the enviornment. First, enter the app directory with::

  cd app

Then run::

  npm install

which will install all required packages for our project. When it's done, execute::

 npm install gulp-cli -g

to get support for *scss*.

.. note::
  On newer versions of macOS (High Sierra or later) you might need to perform some extra steps.

  CocoaPods needs to be installed and setup.
  In ``/app`` run::
    sudo gem install cocoapods
    pod setup
  To avoid more manual setup use Node version ``11.x``.
  In the current setup Node versions ``12.x``, ``13.x``, ``14.x`` and ``15.x`` all require different workarounds on macOS.

  You will also need to
  clear and reinstall the phonegap push plugin for ios::
    rm -r plugins/phonegap-plugin-push
    phonegap cordova platform rm ios
    phonegap cordova platform add ios

==================
Running the server
==================

You have now installed everything and the only thing left to do is to start the server. To do this we simply run::

  npm start

This will start the server and all the required services. The first time you start the web server it will ask you if you want to send information to PhoneGap, which we don't. It will also ask for access through your firewall which you should allow. After a few seconds, you should be able to access the server and see the app at http://localhost:3001. You log in with the email *admin@fsektionen.se* and the password *passpass*

You are now offically up and running. Well done! Head over to :ref:`app-standard-workflow` to get started coding or read more about :ref:`app-our-systems` to get a better understanding of the project.
