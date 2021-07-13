Chapter 9:  Access Networks
===========================

If Network Virtualization was the first successful use case of SDN,
then bringing SDN principles to the Access Network—both
Fiber-to-the-Home and the Mobile Cellular Network—is the latest, and
potentially just as impactful. It is still early (producion
deployments are just starting to happen), but the general approach is
clear. This chapter describes the approach by looking at two example
access networks: *Passive Optical Networks PON)* and *Radio Access
Networks (RAN)*, the technologies at the core of Fiber-to-the-Home and
the Mobile Cellular Network, respectively.


9.1 Background
-------------------

General background about cellular and fiber-to-the-home, and how
both include a unique access network technology (RAN, PON) and an
Access-to-IP gateway (Core, BNG). Preview how Core & BNG can be
implemented as extensions to Trellis (in P4), but hone in on the
uniqueness of the access technology.

Transition to the present: Talk about motivation and what's driving
this. Focus on disaggregation and cloudification. Tell the O-RAN vs
3GPP story.

9.2 SD-PON
-------------

9.3 SD-RAN
-------------

Disaggregation
~~~~~~~~~~~~~~~~~

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
