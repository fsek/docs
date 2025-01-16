This is a sick title
====================

This is some text with **a bold word** and *a word in italic*.

This is a `link <https://fsektionen.se/>`_ to a cool place.


===========================
This is an ordinary header
===========================

Lorem ipsum blablabla.

This subheader is quite nice
----------------------------
Now I would like to insert some code for the user :) :

::

  [{firstLetter: A, songs: [song1, song2, ...]}, {firstLetter: B, ..}, ...]

  sphinx-build -b html -a ./source ./build

and this is some other code:

::

  var listIndex = app.listIndex.create({
    el: '.list-index',
    listEl: '#songbook-list',
    label: true,
  });

and here is some ``super cool inline code highlights``.

Maybe you want a second subheader
---------------------------------

Make sure that this .rst file is linked in app or web. See the documentation for reStructured for more things.

#. This is a numbered list.
#. It has two items.

* This is a bulleted list.
* It has two items too, the second
  item uses two lines.

1. This is an another numbered list.
2. It has two items too.

and here comes a table :O

+------------------------+------------+----------+----------+
| Header row, column 1   | Header 2   | Header 3 | Header 4 |
| (header rows optional) |            |          |          |
+========================+============+==========+==========+
| body row 1, column 1   | column 2   | column 3 | column 4 |
+------------------------+------------+----------+----------+
| body row 2             | ...        | ...      |          |
+------------------------+------------+----------+----------+


=========
Local API
=========

If you have configured the website you can connect to the local web server instead of the one running stage and thus develop and test an api directly by changing stage.fsektionen,se/api to tcp:3000/api in index.js::

  // API URLS
  const BASE_URL = 'tcp://localhost:3000'


========
Phonegap
========

To get PhoneGap set up we can start with PhoneGap's own installation guide. Do step 1 in this guide and install the PhoneGap CLI (Command Line Interface) and not the desktop application. Be sure to install the requirements stated in the guide (Node.js and Git) before you install the actual CLI. The reason why we don't use the desktop app due to its limitations and the same goes for Github's desktop application. It's important to note that it takes a while to get used to these CLI:s, Github especially, because they do not have an intuitive interface. Rather, they have a lot of different commands that take some time to learn but are better in the long run. With that in mind don't be afraid to ask for help if things ever become confusing. Step 2 of the guide is installing PhoneGap's mobile app, which is a way for you to test your changes on your own device. We haven't tested it to a large extent yet, but it's basically the equivalent of a simple emulator that is very easy to set up. For now, this will do perfectly fine though and I would recommend downloading it. How to use their app is described later on in Standard workflow.

=============================
Cloning the Github repository
=============================

A repository or repo is, in other words, a Github project where all of our files are stored. When we talk about cloning a repo we mean downloading the project files to your computer and linking them with Github. We do this by using the Github command clone that is executed in CMD on Windows or the Terminal for macOS and Linux based systems. When executing a Github command you always use the prefix git i.e. the syntax would be git [command]. Now, when cloning we also need to specify what repo we're going to clone. We can do this by using a special link that you can find on the repo's start page (the code tab), which is here for the F-app. On the right, there should be a big green button saying "Clone or download" that will give you the cloning link (see figure below). Make sure it says Clone with HTTPS at the top and not Clone with SSH.

Cloning repository (Picture)

The last thing you need to do is to pick what directory you're cloning into i.e. where you want to save the project files. Personally, I have a folder in documents with both the app and web repo in it called "Spindel". I will show you how you can do this as well, but if you have another preference that's fine too. For example, you might want to save into the home folder instead of documents on Linux.

Open the CMD/Terminal and navigate to the directory of your choice. The commands that will be used to demonstrate this are dir, ls, cd and mkdir. On the left-hand side of the CMD/Terminal the current directory is displayed. The commands dir(Windows) and ls (Mac/Linux) does the same thing for different OS and shows the current directory's content. cd is a command that changes the current directory with the syntax cd [directory]. For example, if your current directory is C:\Users\fredrik then dir would show a list of all files and folders in your fredrik user folder, one of which would be Documents. If you want to enter Documents, i.e. change your current directory to Documents, you would execute::

  cd Documents

and the left-hand side would change to C:\Users\fredr\Documents. You can always go up one level in the directory tree with cd .. and, in this case, return to C:\Users\fredr. While in Documents you can execute::

  mkdir Spindel

and create a new folder (make a directory) called "Spindel" in Documents. dir should now also show Spindel and cd Spindel will change the current directory to C:\Users\fredr\Documents\Spindel. Note that this will look a bit different for Mac and Linux and C:\Users\fredr\ will be replaced with ~. Now, when you've navigated to the directory you want to clone into, execute::

  git clone [repo cloning link]

and you should see it start downloading files. Note, that you should not keep the parentheses and replace [repo cloning link] with the link. Feel free to start with the next step while you're downloading the files. If you've done everything correctly you should have a new app folder in the directory you chose.


======================================
Creating a custom CMD/Terminal command
======================================

When you've successfully cloned the repo you'll have a local app folder somewhere on your computer containing all the project files. Every time you start working you need to access that specific directory through the CMD/Terminal to host a web server (this will be explained further in Standard workflow). Therefore, it's a good idea to make a custom command that will take you to this directory directly, so you'll avoid navigating there manually every time. How to do this is explained below for different operating systems. Note that this step is optional if you've cloned into, or close to, the home directory and don't mind navigating to the project every time.

-------
Windows
-------

First, open the project folder in the file explorer, navigate to the www folder and copy its address from the top. The address should look something like C:\...\app\www. Open notepad, type cd and paste the address. The file should now be looking something like::

  cd C:\...\app\www

Save the file on your desktop as apploc.cmd or with whatever name you see fit. Note that the filename must end with .cmd and have the type All Files (see figure below).

Saving custom command file windows (picture)

Now, go back to the file explorer and navigate to your nodejs folder in Program/Program Files. It should have an address close to C:\Program Files\nodejs. Move the apploc.cmd file into that folder and try executing it in CMD by typing apploc and hitting return. If everything works you should see the current directory on the left-hand side change to the project's www folder.

-----------
Mac & Linux
-----------

On Mac and Linux you'll do everything through the terminal, so open that up and make sure you're in your home directory. ~ is the notation for the home directory and should be shown as the current directory in the command prompt. Normally you're already in your home directory when you start the terminal, but if not execute the following to go there::

  cd ~

Then, use ls -a to list all the files in the home directory. Adding the flag -a will show all the files, even the hidden ones which are marked with a dot prefix. After you've run ls you should see a file called .bash_profile on Mac or .bashrc on Linux. If you don't see it you need to create it. You do this with the command touch as shown below::

  // Mac
  touch .bash_profile

  // Linux
  touch .bashrc

Before we continue with the bash file you need to find the www folder in the app folder you've just cloned and copy its directory path. The easiest way to do this is to find it in Files, enter the www folder, right-click any file or folder inside it, go to Properties and copy the location string. Now, to create a new command you need to define it in the bash file. The best way to do this is by a terminal text editor, like Nano or Vim. You open the file with Nano by entering::

  // Mac
  nano .bash_profile

  // Linux
  nano .bashrc

Now, navigate to the bottom of the file (it might be empty) with your arrow keys and add::

  alias apploc='cd [www folder path]'

where [www folder path] is the location string you've just copied. To save the file you first exit by pressing Ctrl-X on your keyboard. It will then ask you if you want to save where you press your y key for yes. Lastly, it will ask you what you want to save it as, which should be .bashrc and already filled in. Then, press enter to save the file. Restart the terminal and try executing apploc. If you've done everything correctly your current directory should now be the www folder.
