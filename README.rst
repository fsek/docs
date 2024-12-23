docs
=========
Documentation for `fsek/app <https://github.com/fsek/app>`_ and `fsek/web
<https://github.com/fsek/web>`_ using `Sphinx
<http://www.sphinx-doc.org/en/stable/>`_. The source
code is written with **reStructuredText**.


Installations
==============

Installing python3
--------------------
Install python3 by downloading a version from their `website <https://www.python.org/downloads/>`_, preferably later
than 3.6. On MacOS python2 is usually installed as the default python version.
To avoid using the preinstalled python2 use the commands *python3* and *pip3*
instead of *python* and *pip*.

Installing Sphinx from PyPI
------------------------------
Sphinx packages are published on the Python Package Index (PyPI). The preferred
tool for installing packages from PyPI is pip. This tool is provided with all modern versions of Python.

On Linux or MacOS, you should open your terminal and run the following command 
(on MacOS python2 is default. To make sure to install on python3 use pip3
instead of pip):

::

  $ pip install -U sphinx

On Windows, you should open Command Prompt (⊞Win-r and type cmd) and run the same command.

::

  C:\> pip install -U sphinx

After installation, type sphinx-build --version on the command prompt. If everything worked fine, you will see the version number for the Sphinx package you just installed.

For more information for Sphinx installation see the
`installation guide
<http://www.sphinx-doc.org/en/master/usage/installation.html>`_ in
the Sphinx documentation.

Installing sphinx_rtd_theme
-----------------------------
The documentation uses the rtd (Read the Docs) theme *sphinx_rtd_theme*. Install
the theme with pip using the command:

::

  $ pip install sphinx_rtd_theme

Make sure the theme is set in the *conf.py* file:

::

  html_theme = "sphinx_rtd_theme"


Building HTML
================
To build HTML files from the .rst files use the command:

::

  $ make html

when standing in the docs home directory.

