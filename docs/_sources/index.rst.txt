.. Vimform7 documentation master file, created by
   sphinx-quickstart on Wed May 20 15:49:01 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

Vimform7 Introduction
====================================

Vimform7 is an open source terminal based *Linux* development environment for Inform7 projects.  It provides all core functions required to author interactive fiction works in the Inform7 language.  As its name implies, Vimform7 makes use of the Vim editor to provide its functionality.  Vim itself is a highly configurable text editor built to enable efficient text editing.  It has a small memory footprint and excels at handling very large text files.  Vimform7 makes use of Vim configurability by adding a plugin that enables users to develop Inform7 projects.  In order to allow viewing of HTML help documents from within Vim, Vimform7 uses the Lynx text mode browser.  When compiling Inform7 projects Vimform uses standard make utilities in conjunction with Inform7 CBlorb, inform6 and ni compilers.

.. image:: imgs/vimform7intro.png
   :alt: Vimform7 environment with help documentation and code editor open.

Features
===============

Vimform7 provides the essential capabilities needed to author an interactive fiction work.  With Vimform7 you can:

* Compile your Inform7 source code.
* Debug your Inform7 code and jump directly to error in the source.
* Work with existing Inform7 projects.
* Test your Inform7 projects (text only projects at this time).
* Read the Inform7 help documentation.
* Customize the look and feel of the editor.
* Add your own custom short cuts and commands to aid in your development efforts.
* Package your customizations as a new Vimform7 distribution to give to others or to replicate your custom environment on a new system.

Installation & Removal
======================

Vimform7 distributions are provided as compressed archives available on the Vimform7 github builds page.  Installation requires the archive to be decompressed to a temporary location and then an installation script is run to perform the necessary setup steps.  Similar to installation, uninstallation is performed by executing a script as well. Some key aspects of the Vimform7 installation are as follows:

* Vimform7 will not conflict with existing gnome-inform7 or other IF compilers that are installed on your system.  For example, gnome-inform7 and Vimform7 can coexist on the same system with no issues.
* Vimform7 will install OS packages for vim, lynx, make, and uuidgen.  If your OS does not provide these packages Vimform7 will not install.
* Vimform7 itself is built entirely on shell scripts and vim scripting languages.  All scripts / plugins are installed within your home folder structure.

Downloading An Archive
----------------------

All official Vimform7 archives are available at the vimform7-builds github.  You can either clone the git repository or simply download a snapshot of the repository in zip format.

Installation Process
--------------------

Vimform7 takes a few steps to install.  First you need to download an archive, second the archive must be extracted, and third a script must be run to perform the installation.

Removal Process
---------------

You can remove Vimform7 from your system by running the vimform7-uninstall.sh script.  This script can be found in two places: 1) The root of the original archive that Vimform7 was installed from, 2) In the ~/.vimform7/Vimform7 folder on the system where Vimform7 was installed.

Customization
=============

Vimform7 is meant to be customized.  Users can feel free to modify the various scripts that make up the Vimform7 tool set as well as the plugins that integrate Vimform7 with Vim.  Your customizations can also be packaged into a new Vimform7 distribution that can be used to share your work or to simply reproduce your configuration in a new computing environment.  If your customizations could be useful to others, the Vimform7 project welcomes contributions to the toolset via the github pull request workflow.

File Structure
--------------

All files installed by Vimform7 are located in the users home directory.  A map that summarizes the locations of key files that may be of interest to users is given below.  Files and folders in ~/.vim are related to the Vimform7 Vim plugin implementation.  Files and folders in ~/.local are related to the integration of Vimform7 with your OS desktop and terminal.  Files and folders in ~/.vimform7 are related to the operation of Inform7 and are derived from `gnome-inform7 <https://github.com/ptomato/gnome-inform7>`_ with the exception of the Vimform7 folder which contains files related to creating new custom distributions of Vimform7 by users and some configuration files as well.
 
.. image:: imgs/vimform7treelarge.png
   :alt: Vimform7 key folders under users home directory after installation.

Making A Distribution
---------------------

How To Edit Vimform7 Vim Plugins
--------------------------------

How To Edit Vimform7 Scripts
----------------------------

Example Of Adding A Music Player To Vimform7
--------------------------------------------

Working With Source
===================

Download
========

Resources
====================

* `Inform7 - A Design System For Interactive Fiction <http://inform7.com/>`_
* `gnome-inform7 - An Interactive Fiction IDE for Inform7 <https://github.com/ptomato/gnome-inform7>`_
* `Vim - A Highly Configurable Text Editor <https://www.vim.org/>`_
* `Lynx - A Text Browser For The World Wide Web <https://lynx.browser.org/>`_
* `GNU Make - A Tool That Generates Executables <https://www.gnu.org/software/make/>`_
* `GNU Bash - The sh-compatible Bourne Again SHell <https://www.gnu.org/software/bash/>`_

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
