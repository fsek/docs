.. _app-standard-workflow:

Standard workflow
=================

If you've followed the :ref:`app-installation-guide` you should have everything set up to start working. Below we're going to take a look at the standard workflow on this project. This will help you get started coding and implementing your feature.

==========================
Opening the project folder
==========================

This step might seem a little trivial, but it's important to make sure that we have all the correct files opened going forward. Go ahead and open the ``App2`` directory in your IDE/text editor of choice. The folder that's important is the ``lib`` folder, which contains all of our useful stuff. This is where you'll be doing all of your work and adding your feature. The folder structure in ``lib`` is sorted according to the different page types in the app and is quite self explanatory. If you want to change something graphical it will probably be in the ``screens`` or ``widgets`` folders.

=====================
Creating a new branch
=====================

With the project opened you are ready to start coding. Before we make any changes though, we want to create and checkout a new branch with git. ::

  git checkout -b <branch name>

If this is new to you I would recommend to checkout :ref:`learning-git` before we continue and familiarize yourself with the git workflow and its core concepts.

===============
Running the app
===============

Now we are good to start coding and contributing to the project. Remember that all the changes you make are local and doesn't affect anyone but you. The app automatically points to the stage backend, so you can add things without anything breaking. Log in with the account admin snabelA fsektionen.se, ask a su-perman for the password.

==============
Making changes
==============

Edit this later...


Making an API request
---------------------

Edit this later...


Creating a template
-------------------

=================================================
Testing on multiple devices and operating systems
=================================================

When you have gotten to the styling part of your feature it would be nice if you test on both Android and iOS devices, since they might have different styling. What looks good on one device doesn't necessarily look good on others.

=====================================
Adding changes to next version/update
=====================================

When you're finished with your changes and they look good on all devices it's time to add them to the next version. We do this using git which is described step by step in :ref:`git-workflow`. Head over there and follow the steps. When your done the whole guild will enjoy your feature in the next release.

