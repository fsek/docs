

==============
Setting up Git
==============

To set up Git you first need to create a account on Github.

After this is done a few simple steps are needed:

1. **Skapa en SSH-nyckel**  
   Create a SSH-nyckel by running the following command in your terminal:  
   `` `ssh-keygen -t ed25519 -C "din_email@example.com"` ``  
   if questions pop up, press enter.

2. **Starta SSH-agenten**  
   For mac and Linux run:  
   `` `eval "$(ssh-agent -s)"` ``  
   For Windows run:  
   `` `eval $(ssh-agent -s)` ``

3. **Lägg till din privata nyckel i SSH-agenten**  
   Run:  
   `` `ssh-add ~/.ssh/id_ed25519` ``

4. **Kopiera din offentliga nyckel**  
   Run:  
   `` `cat ~/.ssh/id_ed25519.pub` ``

5. **Lägg till nyckeln på GitHub**  
   - Go to `Settings` at Github and then `SSH and GPG keys`.
   - Click on `New key`, paste in your key and click `Add SSH key`.

6. **Testa din SSH-anslutning**  
   Run:  
   `` `ssh -T git@github.com` ``  
   If you get the message `Hi username! You've successfully authenticated, but GitHub does not provide shell access.`, then it was successfull!


You need to configure Git if you have not used it before. Run::

  git config --global user.name "Firstname Lastname"
  git config --global user.email email@example.com

using the same email as on GitHub.

==========================
Setting up Docker
==========================
We use something called containerized structure where we run our different services in Docker containers to make sure they work on different machines and so on.
To install Docker, visit the link:

`Docker installation <https://www.docker.com/products/docker-desktop/>`_

And follow the steps.

When downloaded check if it has been correctly downloaded by running::

  docker run hello-world

==========================
Installing the environment
==========================

To install the environment you should first clone the repo. Head to your
preferred directory and clone. Afterwards you need to install Rails and
all the gems required. All these things can be achieved by running the
following commands::

  cd <preferred folder>
  git clone https://github.com/fsek/WebWebWeb.git
  git clone https://github.com/fsek/WWW-Web.git


==================
Running the server
==================

To run the server and all the web service locally simply run the command::

  uvicorn main:app --reload

in your terminal in WebWebWeb directory and::

  npm run generate-api
  npm run dev

in your terminal in WWW-Web directory.

After a few seconds, you should be able to access the server at http://localhost:5175/admin. You log in with the email *admin@fsektionen.se* and the password *passpass*.
