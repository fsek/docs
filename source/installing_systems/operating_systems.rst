.. _operating-systems:

Operating Systems
=================

Below are some general information regarding various operating systems and the differences between them. If you wish to learn the reasoning behind
our choice of OS, read on, if not continue to `Which OS should I use?`_.

Most of your are using either Windows or macOS when starting your career as a spiderman. While these operating systems work fine for every day use,
there are better choices when it comes to programming. Many software developers use Linux as their OS of choice due to it's configurability and
flexibility. Since it also is, in some sense, a standard in software development, a large amount of tools and frameworks are compatible with Linux.

Linux is a member of the UNIX family which is a collection of operating systems derived from a single old OS from the 1970s. Originally built for programmers
the family has expanded to contain many different kinds of operating systems. macOS is also a member of this family and an example of a OS not designed specifically
for developers. Due to Linux and macOS both being UNIX operating systems, both work very well when it comes to software development. Windows, however, is built upon
MS-DOS, an architecture only used by Microsoft. UNIX and MS-DOS are highly incompatible and as a consequence, UNIX-tools are not guaranteed to work on Windows. Therefore,
Windows is generally not a good choice when it comes to software development, unless you are specifically using tools provided by Microsoft or developing software which
should work only on Windows (software for Windows can also be developed on Linux or macOS).

======================
Which OS should I use?
======================

- **If you are already using Linux:** Great, you came prepared!
- **If you are using macOS:** This works well too!
- **If you are using Windows:** Won't work out of the box so you have a couple of choices, ordered below by level of recommendation.

  - `Windows Subsystems for Linux (WSL)`_. This method essentially installs Linux on Windows. Weird, yes but it works surprisingly well.

  - `Dual booting/changing entirely to Linux`_. If you want the most compatibility and learn Linux, this is the way to go. If you don't, WSL. There are guides for this online, but you won't have the time to do this during our meetings.


==================================
Windows Subsystems for Linux (WSL)
==================================

.. warning::

  This might no longer be working. Look at the `README of the frontend repo <https://github.com/fsek/WWW-Web#readme>`_ for what should be the most up to date installation instructions for WSL2.

This might be the easiest and fastest way to get a Linux environment up and running. To install a WSL, simply head to the Windows Store and search
for Ubuntu (there are many different Linux versions or distributions but Ubuntu is the most widely used). Simply download and install the app and then
you need to run a command in PowerShell. Open PowerShell as an administrator (right click and select *Run as administrator*) and run the following command::

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

Now you should be able to run Ubuntu as a Windows app. If you run into problems, head to `this page <https://docs.microsoft.com/en-us/windows/wsl/install-win10/>`_
which contains a troubleshooting section.

The Ubuntu app is simply a terminal which tries to simulate a Linux environment. You can open as many simultaneous instances of the app as you want which can be useful
if you want to run several routines at once.

To access files created in the Ubuntu environment, use Visual Code. Download it from `<https://code.visualstudio.com/>`_, install it and install the extension *Remote - WSL*. You can
now open files and folders in Ubuntu with Visual Code.
