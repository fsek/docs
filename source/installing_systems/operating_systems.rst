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
- **If you are using Windows:** Won't work, you have a couple of choices, ordered below by level of recommendation.

  - `Windows Subsystems for Linux (WSL)`_. This method essentially installs Linux on Windows. Weird, yes but it works surprisingly well.

  - `Dual booting/changing entirely to Linux`_. If you want the most compatability and learn Linux, this is the way to go. It can, however,
    be a bit of a hassle and take some time. I have currently dual-booted and have no regrets.

  - `Using a Virtual Machine (VM)`_. If you have a really good laptop with a good graphics card, this can work fine. If not, this method
    will likely only be a waste of time since the OS will be slow and sluggish.

==================================
Windows Subsystems for Linux (WSL)
==================================

This might be the easisest and fastest way to get a Linux environment up and running. To install a WSL, simply head to the Windows Store and search
for Ubuntu (there are many different Linux versions or distributions but Ubuntu is the most widely used). Simply download and install the app and then
you need to run a command in PowerShell. Open PowerShell as an administrator (right click and select *Run as administrator*) and run the following command::

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

Now you should be able to run Ubuntu as a Windows app. If you run into problems, head to `this page <https://docs.microsoft.com/en-us/windows/wsl/install-win10/>`_
which contains a troubleshooting section.

The Ubuntu app is simply a terminal which tries to simulate a Linux environment. You can open as many simultaneous instances of the app as you want which can be useful
if you want to run several routines at once.

To access files created in the Ubuntu environment, use Visual Code. Download it from `<https://code.visualstudio.com/>`_, install it and install the extension *Remote - WSL*. You can
now open files and folders in Ubuntu with Visual Code.


=======================================
Dual booting/changing entirely to Linux
=======================================

Since there are many great tutorials covering this topic, it will not be described in detail here. Just remember to create a backup of your Windows installation
before dual booting in case something goes wrong! Also, **Ubuntu** is the most widely used Linux distribution so if you don't know what to choose,
that is a good start.

============================
Using a Virtual Machine (VM)
============================

Creating a VM is also covered in great detail in several tutorials online. An open source VM which works okay is VirtualBox. However, there might be some performance
issues which could be solved after some tinkering with settings. Another option is VMWare which is not free but there might be some keys available on the web.
VMWare has generally worked better for me but in the end, WSL is recommended over a VM since you generally only need a terminal and not an entire GUI.
