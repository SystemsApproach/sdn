Chapter 9:  Access Networks
===========================

Having just looked at the first widespread use case of SDN, Network
Virtualization, we now turn our attention to the latest emerging use
case: Access Network, which includes both Fiber-to-the-Home and the
Mobile Cellular Network. It is still early (production deployments are
just now being rolled out), but the opportunity is substantial. This
chapter describes two examples of how SDN is being applied to access
networks—*Passive Optical Networks (PON)* and *Radio Access Networks
(RAN)*—the technologies at the core of Fiber-to-the-Home and the
Mobile Cellular Network, respectively.


9.1 Background
-------------------

The technologies used to implement the *last mile* networks connecting
homes, businesses, and mobile devices to the Internet have evolved
independently from the rest of the Internet. This evolution, which has
spanned decades, started with support for circuit-based voice
communication and then incrementally added support for IP-based data
communication.  The end result is a baroque collection of
purpose-built devices that look quite unfamiliar to anyone that
understands how to build a network out of a collection of L2/L3
ethernet switches.

But this makes the access network fertile ground for SDN, and the
introduction of disaggregation, commodity hardware, and cloud-based
software. To understand what this means, we need to start with a brief
overview of the legacy systems being replaced. We do this in the
context of the two specific access technologies mentioned in the
introduction: PON and RAN. Fortunately, from our 10,000-foot view,
their respective architectures are strikingly similar. Of course the
details differ significantly, but hiding (or even eliminating)
gratuitous detail is one of the main values that SDN brings to the
table.

Before getting to the specifics, we need one more bit of context. ISPs
(e.g., Telco or Cable companies) that offer broadband service often
operate a national backbone, and connected to the periphery of that
backbone are hundreds or thousands of edge sites.  These edge sites
are commonly called *Central Offices* in the Telco world and *Head
Ends* in the cable world, but despite their names implying
“centralized” and “root of the hierarchy” these sites are at the very
edge of the ISP’s network; the ISP-side of the last-mile that directly
connects to customers. The PON and RAN-based access networks are
anchored in these facilities.

Passive Optical Network 
~~~~~~~~~~~~~~~~~~~~~~~

We start with PON, which is a tree-structured network, with a single
point starting in one of the ISP's edge sites, and then fanning out to
reach up to 1024 homes. PON gets its name from the fact that the
splitters are passive: they forward optical signals downstream and
upstream without actively storing-and-forwarding frames. Framing then
happens at the source in the ISP’s premises, in a device called an
*Optical Line Terminal* (OLT), and at the end-points in individual
homes, in a device called an *Optical Network Unit* (ONU).

:numref:`Figure %s <fig-pon>` shows an example PON, simplified to
depict just one ONU and one OLT. In practice, a Central Office would
include multiple OLTs, fanning out to thousands of customer homes.
:numref:`Figure %s <fig-pon>` also highlights one other detail, which
is how a PON is connected to the rest of the Internet. The *BNG
(Broadband Network Gateway)* is a piece of Telco equipment that
authenticates users, differentiates service, and meters traffic for
the sake of billing. As its name implies, the BNG is effectively the
gateway between the access network (everything to the left of the BNG)
and the Internet (everything to the right of the BNG).
  
.. _fig-pon:
.. figure:: access/Slide1.png
   :width: 600px
   :align: center

   An example PON that connects OLTs in the Central Office 
   to ONUs in homes and businesses.

Because the splitters are passive, PON implements a multi-access
protocol. Briefly, upstream and downstream traffic are transmitted on
two different optical wavelengths, so they are completely independent
of each other. Downstream traffic starts at the OLT and the signal is
propagated down every link in the PON. As a consequence, every frame
reaches every ONU. This device then looks at a unique identifier in
the individual frames sent over the wavelength, and either keeps the
frame (if the identifier is for it) or drops it (if not). Encryption
is used to keep ONUs from eavesdropping on their neighbors’ traffic.
Upstream traffic is then time-division multiplexed on the upstream
wavelength, with each ONU periodically getting a turn to transmit.

PON is similar to Ethernet in the sense that it defines a sharing
algorithm that has evolved over time to accommodate higher and higher
bandwidths. G-PON (Gigabit-PON) is the most widely deployed today,
supporting a bandwidth of 2.25-Gbps. XGS-PON (10 Gigabit-PON) is now
being deployed.

Radio Access Network
~~~~~~~~~~~~~~~~~~~~

A RAN implements the last hop by encoding and transmitting data at
various bandwidths in the radio spectrum.  For example, traditional
cellular technologies range from 700-MHz to 2400-MHz, with new
mid-spectrum allocations now happening at 6-GHz and millimeter-wave
(mmWave) allocations opening above 24-GHz.

It is everything that comes *before* the over-the-air transmission
that is of interest here.  As shown in :numref:`Figure %s <fig-ran>`,
this includes the set of base stations connected to each other (and
back to the Central Office), and the Mobile Core that connects the RAN
to the rest of the Internet. The Mobile Core is like the BNG in that
it is an IP gateway that is also responsible for authentication, QoS,
and billing. Plus the Mobile Core has added responsibility of tracking
mobility (i.e., recording which base station is currently serving each
active device, or so-called UE).

.. _fig-ran:
.. figure:: access/Slide2.png
   :width: 700px
   :align: center

   A Radio Access Network (RAN) connecting a set of cellular devices 
   (UEs) to a Mobile Core hosted in a Central Office.

The figure also shows the Mobile Core and set of base stations
interconnected by a backhaul network. The technology used to implement
this backhaul is an implementation choice—e.g., it could be
ethernet-based or PON-based—but for our purposes, the important point
is that the RAN is effectively a regional (e.g., metro-area)
packet-switched network, overlaid on the backhaul, where the base
stations are the "nodes" of that overlay network. Packets are "routed"
through this network to reach the best base station(s) to serve each
UE at a given moment in time.\ [#]_ These forwarding decisions are
implemented by the base stations, which make decisions about
*handovers* (one base station handing a given UE's traffic off to
another) and *link aggregation* (multiple base stations deciding to
jointly transmit to a given UE).

.. [#] We say "routed" because the decision is based on a combination
       of mobility tracking and monitoring how to most efficiently use
       the radio spectrum, as opposed to the shortest-path criteria
       typically used in wired networks. What's important, however, is
       that the base stations cooperatively implement a distributed
       decision-making algorithm, and then forward packets to each
       other based on those decisions.

Key Takeaways
~~~~~~~~~~~~~~~~

There are three observations to make about these two network
technologies before we get to the question of how to apply SDN
principles. The first is the distinction between the "access network"
and the "IP gateway".  For example, Fiber-to-the-Home corresponds to
both the PON and the BNG, and similarly, the 5G Cellular Mobile
Network is implemented by a combination of the RAN and the Mobile
Core. This chapter focuses on how to apply SDN to the PON and RAN, but
as we have already seen (briefly) in Section 7.4, SDN can also be
applied to the BNG and Mobile Core. Both are just enhanced IP routers,
with the new features implemented as extensions to the P4 program
running in the switching fabric. We return to this topic in the last
section, where we describe these extensions in more detail.

Second, because the PON is passive, there is no opportunity for
software control *inside* the network. Applying SDN to PON involves
software control of the end-points (i.e., the OLTs and ONUs) and
treating everything between these end-points as a passive
backplane. Moreover, the ONU is a "dumb" device that responds to
directives from the OLT, all of which points to disaggregating the OLT
as the key.

Third, because the RAN is a packet-switch network that interconnects a
set of base stations, there is an opportunity for software
control. This requires disaggregating the base stations, which as as
we will see later in this chapter, have historically run a multi-layer
protocol stack. Once disaggregated, the pieces are then distributed
throughout the network, with some elements co-located with the radio
antenna, and some elements co-located with the Mobile Core in the
Central Office. In other words, the plan is to both "split" and
"distribute" the RAN.

.. todo::

   Somewhere, perhaps in a sidebar, we should talk about 3GPP and
   O-RAN.

9.2 SD-PON
-------------

9.3 SD-RAN
-------------

Split RAN
~~~~~~~~~

Start with a some more background on RAN and base stations, and then
jump into disaggregation -- Split RAN -- and how that's the
centerpiece of the story. Should be able to borrow from 5G book.

RAN Intelligent Controller
~~~~~~~~~~~~~~~~~~~~~~~~~~

Zoom in on RIC. Describe it's ONOS-based implementation, but also the
centrality of the two interfaces. Should be able to use some of the following.

Much of the early hype surrounding 5G is about the increase in
bandwidth it brings, but 5G’s promise is mostly about the transition
from a single access service (broadband connectivity) to a richer
collection of edge services and devices, including support for
immersive user interfaces (e.g., AR/VR), mission-critical applications
(e.g., public safety, autonomous vehicles), and the Internet-of-Things
(IoT). Many of these new applications will be feasible only if SDN
principles are applied to the Radio Access Network (RAN), resulting in
increased feature velocity. Because of this, mobile network operators
are working to make Software-Defined RAN (SD-RAN) happen.

.. _reading_sdran:
.. admonition:: Further Reading  
   
   `SD-RAN Project  
   <https://opennetworking.org/sd-ran/>`__.
   Open Networking Foundation. August 2020. 
   
To understand SD-RAN at a technical level, it is important to
recognize that the base stations that make up the RAN are, for all
practical purposes, packet forwarders. The set of base stations in a
given geographic area coordinate with each other to allocate the
shared—and extremely scarce—radio spectrum. They make hand-off
decisions, decide to jointly serve a given user (think of this as a
RAN variant of link aggregation), and make packet scheduling decisions
based on the observed signal quality. Today these are purely local
decisions, but transforming it into a global optimization problem is
in SDN’s wheelhouse.

The idea of SD-RAN is for each base station to report locally
collected statistics about radio transmission quality back to a
central SDN controller, which combines information from a set of base
stations to construct a global view of how the radio spectrum is being
utilized. A suite of control applications—for example, one focused on
handoffs, one focused on link aggregation, one focused on load
balancing, and one focused on frequency management—can then use this
information to make globally optimal decisions, and push control
instructions back to the individual base stations. These control
instructions are not at the granularity of scheduling individual
segments for transmission (i.e., there is still a real-time scheduler
on each base station, just as an SDN-controlled ethernet switch still
has a local packet scheduler), but they do exert near real-time
control over the base stations, with control loops measured in less
than ten milliseconds.

.. _fig-ric:
.. figure:: figures/Slide36.png
    :width: 500px
    :align: center

    3GPP-compliant RAN Intelligent Controller (RIC) built by adapting
    and extending ONOS.

Like the verified closed-loop control example, the scenario just
described is within reach, with a retargeting of ONOS at the SD-RAN
use case already underway. :numref:`Figure %s <fig-ric>` shows the
design, which introduces some new components, but largely builds on
the existing ONOS architecture. In some cases, the changes are
superficial. For example, ONOS adopts terminology coming out of the
3GPP and O-RAN standardization bodies,\ [#]_ most notably, that the
NOS is called a *RAN Intelligent Controller (RIC)*. In other cases,
it’s a matter of adopting standardized interfaces: the **C1**
interface by which control applications communicate with the RIC, the
**A1** interface by which the operator configures the RAN, and the
**E2** interface by which the RIC communicates with the underlying RAN
elements. The details of these interfaces is beyond the scope of this
book, but the important takeaway for our purposes is that they are no
different than supporting any other standard north- and south-facing
interface (e.g., gNMI, gNOI, OpenFlow).

.. [#] 3GPP (3rd Generation Partnership Project) has been responsible for
       standardizing the mobile cellular network ever since 3G, and
       O-RAN (Open-RAN Alliance) is a consortium of mobile network
       operators defining an SDN-based implementation strategy for 5G.

The ONOS-based RIC takes advantage of the Topology Service described
in Chapter 6, but it also introduces two new services: *Control* and
*Telemetry*. The Control Service, which builds on the Atomix key/value
store, manages the control state for all the base stations and user
devices, including which base station is serving each user device, as
well as the set of  “potential links” that could connect the device.
The Telemetry Service, which builds on a *Time Series Database
(TSDB)*, tracks all the link quality information being reported back
by the RAN elements. Various of the control applications then analyze
this data to make informed decisions about how the RAN can best meet
its data delivery objectives.

For a broad introduction into what’s involved in disaggregating 5G
mobile networks so they can be implemented in software, we recommend
the following companion book.

.. _reading_5g:
.. admonition:: Further Reading  

   L. Peterson and O. Sunay.
   `5G Mobile Networks: A Systems Approach <https://5g.systemsapproach.org/>`__.
   June 2020.  
 
9.4  Relationship to SD-Fabric
-----------------------------------

Circle back to SD-Fabric and especially ``fabric.p4``, where we
implement UPF and BNG.
