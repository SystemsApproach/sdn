About The Book
===============

This `repository <https://github.com/SystemsApproach/SDN>`__ contains
source for *Software-Defined Networks: A Systems Approach*, available under
terms of the `Creative Commons (CC BY-NC-ND 4.0)
<https://creativecommons.org/licenses/by-nc-nd/4.0>`__ license. The
community is invited to contribute corrections, improvements, updates,
and new material under the same terms.

If you make use of this work, the attribution should include the
following information:

| *Title: Software-Defined Networks: A Systems Approach* 
| *Authors: Larry Peterson, Carmelo Cascone, Brian O'Connor, and Thomas Vachuska* 
| *Source:* https://github.com/SystemsApproach/SDN 
| *License:* \ `CC BY-NC-ND 4.0 <https://creativecommons.org/licenses/by-nc-nd/4.0>`__

Read the Book
-------------

This book is part of the `Systems Approach Series
<https://www.systemsapproach.org>`__, with an online version published
at `https://sdn.systemsapproach.org
<https://sdn.systemsapproach.org>`__.

To track progress and receive notices about new versions, you can follow
the project on
`Facebook <https://www.facebook.com/Computer-Networks-A-Systems-Approach-110933578952503/>`__
and `Twitter <https://twitter.com/SystemsAppr>`__. To read a running
commentary on how the Internet is evolving, follow the `Systems Approach
Blog <https://www.systemsapproach.org>`__.

Build the Book
--------------

To build a web-viewable version, you first need to download the source:

.. code:: shell 

   $ mkdir ~/SDN 
   $ cd ~/SDN 
   $ git clone https://github.com/SystemsApproach/SDN.git 

The build process is stored in the Makefile and requires Python be 
installed. The Makefile will create a virtualenv (``doc_venv``) which 
installs the documentation generation toolset. 

To generate HTML in ``_build/html``,  run ``make html``.

To check the formatting of the book, run ``make lint``.

To see the other available output formats, run ``make``.

Contribute to the Book
----------------------

We hope that if you use this material, you are also willing to
contribute back to it. If you are new to open source, you might check
out this `How to Contribute to Open
Source <https://opensource.guide/how-to-contribute/>`__ guide. Among
other things, you’ll learn about posting *Issues* that you’d like to see
addressed, and issuing *Pull Requests* to merge your improvements back
into GitHub.

If you’d like to contribute and are looking for something that needs
attention, see the `wiki <https://github.com/SystemsApproach/SDN/wiki>`__
for the current TODO list.
