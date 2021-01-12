Foreword
==========

I got goosebumps when I saw the first Mosaic web browser
in 1993. Something big was clearly about to happen; I had no idea how
big. The Internet immediately exploded in scale, with thousands of new
ISPs (Internet Service Providers) popping up everywhere, each grafting
on a new piece of the Internet. All they needed to do was plug
interoperable pieces together—off-the-shelf commercial switches,
routers, base-stations, and access points sold by traditional
networking equipment vendors—with no need to ask permission from a
central controlling authority. The early routers were simple and
streamlined—they just needed to support the Internet
protocol. Decentralized control let the Internet grow rapidly.

The router manufacturers faced a dilemma: It’s hard to maintain a
thriving profitable business selling devices that are simple and
streamlined. Whatsmore, if a big network of simple devices is easy to
manage remotely, all the intelligence (and value) is provided by the
network operator, not the router manufacturer. So the external API was
kept minimal (“network management” was considered a joke) and the
routers were jam-packed with new features to keep all the value
inside. By the mid 2000s, routers used by ISPs were so complicated
that they supported hundreds of protocols and were based on more than
100 million lines of source code—ironically, more than ten times the
complexity of the largest telephone exchange ever built. The Internet
paid a hefty price for this complexity: routers were bloated, power
hungry, unreliable, hard to secure, and crazy expensive. Worst of all,
they were hard to improve (ISPs needed to beg equipment vendors to add
new capabilities) and it was impossible for an ISP to add their own
new features. Network owners complained of a “stranglehold” by the
router vendors, and the research community warned that the Internet
was “ossified.”

This book is the story of what happened next, and it’s an exciting
one. Larry, Carmelo, Brian, Thomas and Bruce capture clearly, through
concrete examples and open-source code: How those who own and operate
big networks started to write their own code and build their own
switches and routers. Some chose to replace routers with homegrown
devices that were simpler and easier to maintain; others chose to move
the software off the router to a remote, centralized control plane.
Whichever path they chose, open-source became a bigger and bigger
part. Once open-source had proved itself in Linux, Apache, Mozilla and
Kubernetes, it was ready to be trusted to run our networks too.

This book explains why the SDN movement happened. It was essentially
about a change in control: the owners and operators of big networks
took control of how their networks work, grabbing the keys to
innovation from the equipment vendors. It started with data center
companies because they couldn’t build big-enough scale-out networks
using off-the-shelf networking equipment. So they bought switching
chips and wrote the software themselves. Yes, it saved them money
(often reducing the cost by a factor of five or more), but it was
control they were after. They employed armies of software engineers to
ignite a Cambrian explosion of new ideas in networking, making their
networks more reliable, quicker to fix, and with better control over
their traffic. Today, in 2021, all of the large data center companies
build their own networking equipment: they download and modify
open-source control software, or they write or commission software to
control their networks. They have taken control. The ISPs and 5G
operators are next. Within a decade, expect enterprise and campus
networks to run on open-source control software, managed from the
cloud.  This is a good change, because only those who own and operate
networks at scale know how to do it best.

This change—a revolution in how networks are built, towards homegrown
software developed and maintained by the network operator—is called
Software Defined Networking (SDN). The authors have been part of this
revolution since the very beginning, and have captured how and why it
came about.

They also help us see what future networks will be like. Rather than
being built by plugging together a bunch of boxes running standardized
interoperability protocols, a network system will be a platform we can
program ourselves. The network owner will decide how the network works
by programming whatever behavior they wish. Students of networking
will learn how to programme a distributed system, rather than study
the arcane details of legacy protocols.

For anyone interested in programming, networks just got interesting
again. And this book is an excellent place to start.

| Nick McKeown
| Stanford, California


