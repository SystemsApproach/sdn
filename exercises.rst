Hands-on Programming
======================

A collection of programming exercises provides hands-on experience with
the software described in this book. They include:

* Using Stratum's P4Runtime, gNMI, OpenConfig, and gNOI interfaces
* Using ONOS to control P4-programmed switches
* Writing ONOS applications to implement control plane logic
* Testing a software stack using bmv2 in Mininet
* Using PTF to test P4-based forwarding planes

The exercises assume familiarity with Java and Python, although each
exercise comes with starter code, so a high level of proficiency is
not required. The exercises also use the *Mininet* network emulator,
the *bmv2* P4-based switch emulator, the *PTF* Packet Testing
Framework, and the *Wireshark* protocol analyzer. Additional
information about each of these software tools is provided in the
individual exercises.

The exercises originated with a *Next Generation SDN Tutorial*
produced by ONF, and so they come with a collection of on-line
tutorial slides that introduce the topics covered in the exercises:

* http://bit.ly/adv-ngsdn-tutorial-slides

These slides have significant overlap with the material covered in
this book, so it is not essential that you start with the slides, but
they can be a good supplemental resource.

Environment
----------------------------

You will be doing the exercises in a virtualized Linux environment
running on your laptop. This section describes how to install and
prepare that environment.

System Requirements
~~~~~~~~~~~~~~~~~~~~~~

The current configuration of the VM is 4 GB of RAM and a 4-core CPU.
These are the recommended minimum system requirements to complete the
exercises. The VM also takes approximately 8 GB of HDD space. For a
smooth experience, we recommend running the VM on a host system that
has at least double these resources.

Download VM
~~~~~~~~~~~~~~~~~

Click the following link to download the VM (4 GB):

* http://bit.ly/ngsdn-tutorial-ova

The VM is in ``.ova`` format and has been created using VirtualBox
v5.2.32. You can use any modern virtualization system to run the VM,
although we recommend using VirtualBox. The following links provide
instructions on how to get VirtualBox and import the VM:

* https://www.virtualbox.org/wiki/Downloads
* https://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html

Alternatively, you can use these
`scripts <https://github.com/opennetworkinglab/ngsdn-tutorial/tree/advanced/util/vm>`__
to build a VM on your machine using Vagrant.

.. _warning-windows:
.. admonition:: Note for Windows Users

   All scripts have been tested on MacOS and Ubuntu.  Although they
   should work on Windows, they have not been tested. We therefore
   recommend that Windows users download the provided VM.

At this point you can start the virtual machine (an Ubuntu system),
and log in using the credentials ``sdn`` / ``rocks``. The instructions
given throughout the remainder of this section (as well as the
exercises themselves) are to be executed within the running VM.


Clone Repository
~~~~~~~~~~~~~~~~~~

To work on the exercises you will need to clone the following repo:

.. code-block:: shell

    $ cd ~
    $ git clone -b advanced https://github.com/opennetworkinglab/ngsdn-tutorial

If the ``ngsdn-tutorial`` directory is already present in the VM, make
sure to update its content:

.. code-block:: shell 

    $ cd ~/ngsdn-tutorial
    $ git pull origin advanced

Note that there are multiple branches of the repo, each with a
different configuration of the exercises. Always make sure you are in
the ``advanced`` branch.

Upgrade Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The VM may have shipped with an older version of the dependencies than
you need for the exercises. You can upgrade to the latest version
using the following command:

.. code-block:: shell 

    $ cd ~/ngsdn-tutorial
    $ make deps

This command downloads all necessary Docker images (~1.5 GB), which
allows you to work through the exercises off-line.

Using an IDE
~~~~~~~~~~~~~~~~~~~

During the exercises you will need to write code in multiple languages
(e.g., P4, Java, Python). While the exercises do not require the use
of any specific IDE or code editor, one option is the Java IDE
`IntelliJ IDEA Community Edition <https://www.jetbrains.com/idea/>`__,
which comes pre-loaded with plugins for P4 syntax highlighting and
Python development. We suggest using IntelliJ IDEA especially when
working on the ONOS app, as it provides code completion for all ONOS
APIs.

Repo Structure
~~~~~~~~~~~~~~~~~~~~~

The repo you cloned is structured as follows:

* ``p4src\`` → Data Plane Implementation (P4)
* ``yang\`` → Config Models (YANG)
* ``app\`` → Custom ONOS app (Java)
* ``mininet\`` → 2x2 leaf-spine (Mininet)
* ``util\`` → Utility Scripts (Bash)
* ``ptf\`` → Data plane unit tests (PTF)

Note that the exercises include links to various files on GitHub, but
don't forget you have those same files cloned on your laptop.

Commands
~~~~~~~~~~~~~~~~

To facilitate working on the exercises, the repo provides a set of
``make`` targets to control the different aspects of the process. The
specific commands are introduced in the individual exercises, but the
following is a quick reference:

* ``make deps`` → Pull and build all required dependencies
* ``make p4-build`` → Build P4 program
* ``make p4-test`` → Run PTF tests
* ``make start`` → Start Mininet and ONOS containers
* ``make stop`` → Stop all containers
* ``make restart`` → Restart containers clearing any previous state
* ``make onos-cli`` → Access the ONOS CLI (password: ``rocks``, Ctrl-D to exit)
* ``make onos-log`` →  Show the ONOS log
* ``make mn-cli`` →  Access the Mininet CLI (Ctrl-D to exit)
* ``make mn-log`` →  Show the Mininet log (i.e., the CLI output)
* ``make app-build`` → Build custom ONOS app
* ``make app-reload`` →  Install and activate the ONOS app
* ``make netcfg`` →  Push ``netcfg.json`` file (network config) to
  ONOS

.. _warning-cmds:
.. admonition:: Executing Commands

   As a reminder, these commands will be executed in a terminal window
   you open within the VM you just created. Be sure you are in the
   root directory of the repo you cloned (where the main ``Makefile``
   lives).

Exercises
------------------

The following lists (and links) the individual exercises. That there
are 8 exercises and 8 chapters is a coincidence. Exercises 1 and 2
focus on Stratum, and are best attempted after reading through Chapter
5. Exercises 3 through 6 focus on ONOS and are best attempted after
reading through Chapter 6. Exercises 7 and 8 focus on Trellis and are
best attempted after reading through Chapter 7. Note that the
exercises build on each other, so it is best to work through them in
order.

1. `P4Runtime Basics <https://github.com/opennetworkinglab/ngsdn-tutorial/blob/advanced/EXERCISE-1.md>`__ 
2. `YANG, OpenConfig, gNMI Basics <https://github.com/opennetworkinglab/ngsdn-tutorial/blob/advanced/EXERCISE-2.md>`__   
3. `Using ONOS as the Control Plane <https://github.com/opennetworkinglab/ngsdn-tutorial/blob/advanced/EXERCISE-3.md>`__ 
4. `Enabling ONOS Built-in Services <https://github.com/opennetworkinglab/ngsdn-tutorial/blob/advanced/EXERCISE-4.md>`__   
5. `Implementing IPv6 Routing with ECMP <https://github.com/opennetworkinglab/ngsdn-tutorial/blob/advanced/EXERCISE-5.md>`__ 
6. `Implementing SRv6 <https://github.com/opennetworkinglab/ngsdn-tutorial/blob/advanced/EXERCISE-6.md>`__   
7. `Trellis Basics <https://github.com/opennetworkinglab/ngsdn-tutorial/blob/advanced/EXERCISE-7.md>`__ 
8. `GTP Termination with fabric.p4 <https://github.com/opennetworkinglab/ngsdn-tutorial/blob/advanced/EXERCISE-8.md>`__   

You can find solutions for each exercise in the ``solution``
subdirectory for the repo you cloned.  Feel free to compare your
solution to the reference solution should you get stuck.

.. _warning-tutorial:
.. admonition:: Graphical Interfaces

   When exercises call for viewing graphical output, you will see
   reference to the *ONF Cloud Tutorial Portal*. This is for
   cloud-hosted VMs used during ONF-run tutorials, and so does apply
   here. In its place, the exercises also describe how to access the
   GUI running locally on your laptop.

If you have suggestions for how we can improve these exercises, please
send email to ng-sdn-exercises@opennetworking.org or post an issue to
`GitHub <https://github.com/opennetworkinglab/ngsdn-tutorial/issues/new>`__.
