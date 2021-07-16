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
backplane. Moreover, because the ONU is a "dumb" device that responds
to directives from the OLT, this really boils down to disaggregating
the OLT.

Third, because the RAN is a packet-switch network that interconnects a
set of base stations (running as an overlay on the backhaul), there is
an opportunity for software control. This requires disaggregating the
base stations, which as as we will see later in this chapter, have
historically run a multi-layer protocol stack. Once disaggregated, the
pieces are then distributed throughout the network, with some elements
co-located with the radio antenna, and some elements co-located with
the Mobile Core in the Central Office. In other words, the plan is to
both "split" and "distribute" the RAN.

For a broad introduction into what’s involved in disaggregating 5G
mobile networks so they can be implemented in software, we recommend
the following companion book.

.. _reading_5g:
.. admonition:: Further Reading  

   L. Peterson and O. Sunay.
   `5G Mobile Networks: A Systems Approach <https://5g.systemsapproach.org/>`__.
   June 2020. 


9.2 SD-PON
-------------

9.3 SD-RAN
-------------

Much of the early hype surrounding 5G is about the increase in
bandwidth it brings, but 5G’s promise is mostly about the transition
from a single access service (broadband connectivity) to a richer
collection of edge services and devices, including support for
immersive user interfaces (e.g., AR/VR), mission-critical applications
(e.g., public safety, autonomous vehicles), and the Internet-of-Things
(IoT). Many of these new applications will be feasible only if SDN
principles are applied to the RAN, resulting in increased feature
velocity. Because of this, mobile network operators are working to
make Software-Defined RAN (SD-RAN) happen.

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

Split RAN
~~~~~~~~~

To better see how this works, we start with a finer-grain view of the
packet processing pipeline running on each base station shown in
:numref:`Figure %s <fig-basestation>`. Note that the figure depicts
the base station as a pipeline (running left-to-right for packets sent
to the UE) but it is equally valid to view it as a protocol stack.

.. _fig-basestation:
.. figure:: access/Slide3.png 
    :width: 600px
    :align: center
	    
    RAN processing pipeline, including both user and
    control plane components.

The key stages are as follows.

-  RRC (Radio Resource Control) → Responsible for configuring the
   coarse-grain and policy-related aspects of the pipeline. The RRC runs
   in the RAN’s control plane; it does not process packets on the user
   plane.

-  PDCP (Packet Data Convergence Protocol) → Responsible for compressing
   and decompressing IP headers, ciphering and integrity protection, and
   making an “early” forwarding decision (i.e., whether to send the
   packet down the pipeline to the UE or forward it to another base
   station).

-  RLC (Radio Link Control) → Responsible for segmentation and
   reassembly, including reliably transmitting/receiving segments by
   implementing a form of ARQ (automatic repeat request).

-  MAC (Media Access Control) → Responsible for buffering, multiplexing
   and demultiplexing segments, including all real-time scheduling
   decisions about what segments are transmitted when. Also able to make
   a “late” forwarding decision (i.e., to alternative carrier
   frequencies, including WiFi).

-  PHY (Physical Layer) → Responsible for coding and modulation (as
   discussed in an earlier chapter), including FEC.

The last two stages in :numref:`Figure %s <fig-basestation>` (D/A
conversion and the RF front-end) are beyond the scope of this book.

The next step is to understand how the functionality outlined above is
partitioned between physical elements, and hence, “split” across
centralized and distributed locations. The dominant option has
historically been "no split," with the entire pipeline shown in
:numref:`Figure %s <fig-basestation>` running in the base station.
Going forward, the 3GPP standard has been extended to allow for
multiple split-points, with the partition shown in :numref:`Figure %s
<fig-split-ran>` being actively pursued by the operator-led O-RAN
(Open RAN) Alliance. It is the split we adopt throughout the rest of
this chapter.

.. _fig-split-ran:
.. figure:: access/Slide4.png 
    :width: 600px
    :align: center

    Split-RAN processing pipeline distributed across a
    Central Unit (CU), Distributed Unit (DU), and Radio Unit (RU).

This results in a RAN-wide configuration similar to that shown in
:numref:`Figure %s <fig-ran-hierarchy>`, where a single *Central Unit (CU)*
running in the cloud serves multiple *Distributed Units (DUs)*, each of
which in turn serves multiple *Radio Units (RUs)*. Critically, the RRC
(centralized in the CU) is responsible for only near-real-time
configuration and control decision making, while the Scheduler that is
part of the MAC stage is responsible for all real-time scheduling
decisions.

.. _fig-ran-hierarchy:
.. figure:: access/Slide5.png 
    :width: 350px
    :align: center
	    
    Split-RAN hierarchy, with one CU serving multiple DUs,
    each of which serves multiple RUs.

Because scheduling decisions for radio transmission are made by the
MAC layer in real time, a DU needs to be “near” (within 1ms) the RUs
it manages. (You can't afford to make scheduling decisions based on
out-of-date channel information.) One familiar configuration is to
co-locate a DU and an RU in a cell tower. But when an RU corresponds
to a small cell, many of which might be spread across a modestly-sized
geographic area (e.g., a mall, campus, or factory), then a single DU
would likely service multiple RUs. The use of mmWave in 5G is likely
to make this later configuration all the more common.

One observation about the CU is that one might co-locate the CU and
Mobile Core in the same cluster.
    
RAN Intelligent Controller
~~~~~~~~~~~~~~~~~~~~~~~~~~

Need transition/intro... and this picture...

.. _fig-ric-overview:
.. figure:: access/Slide6.png
    :width: 350px
    :align: center

    Where RIC sits in the larger scheme of things...

This component is commonly referred to as the *RAN Intelligent
Controller (RIC)* in O-RAN architecture documents, so we adopt this
terminology.  The "Near-Real Time" qualifier indicates the RIC is part
of 10-100ms control loop implemented in the CU, as opposed to the ~1ms
control loop required by the MAC scheduler running in the DU.

As an SDN Controller (Network OS), there is an implementation based on
a retargeting of ONOS at the SD-RAN use case.  :numref:`Figure %s
<fig-ric>` shows the design, which introduces some new components, but
largely builds on the existing ONOS architecture.

.. _fig-ric:
.. figure:: figures/Slide36.png
    :width: 500px
    :align: center

    3GPP-compliant RAN Intelligent Controller (RIC) built by adapting
    and extending ONOS.

In some cases, the changes are superficial. For example, ONOS adopts
terminology coming out of the 3GPP and O-RAN standardization bodies,\
[#]_ most notably, that the NOS is called a *RAN Intelligent
Controller (RIC)*. In other cases, it’s a matter of adopting
standardized interfaces: the **C1** interface by which control
applications communicate with the RIC, the **A1** interface by which
the operator configures the RAN, and the **E2** interface by which the
RIC communicates with the underlying RAN elements. The details of
these interfaces is beyond the scope of this book, but the important
takeaway for our purposes is that they are no different than
supporting any other standard north- and south-facing interface (e.g.,
gNMI, gNOI, OpenFlow).

.. [#] 3GPP (3rd Generation Partnership Project) has been responsible for
       standardizing the mobile cellular network ever since 3G, and
       O-RAN (Open-RAN Alliance) is a consortium of mobile network
       operators defining an SDN-based implementation strategy for
       5G. **(Perhaps expand into sidebar... see last paragraph.)**

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

The example Control Apps in :numref:`Figure %s <fig-ric>`
include a range of possibilities, but is not intended to be an
exhaustive list.  The right-most example, RAN Slicing, is the most
ambitious in that it introduces a new capability: Virtualizing the
RAN. It is also an idea that has been implemented, which we describe
in more detail in the next chapter.

The next three (RF Configuration, Semi-Persistent Scheduling, Cipher Key
Assignment) are examples of configuration-oriented applications. They
provide a programmatic way to manage seldom-changing configuration
state, thereby enabling zero-touch operations. Coming up with meaningful
policies (perhaps driven by analytics) is likely to be an avenue for
innovation in the future.

The left-most four example Control Applications are the sweet spot for
SDN, with its emphasis on central control over distributed
forwarding. These functions—Link Aggregation Control, Interference
Management, Load Balancing, and Handover Control—are currently
implemented by individual base stations with only local visibility,
but they have global consequences. The SDN approach is to collect the
available input data centrally, make a globally optimal decision, and
then push the respective control parameters back to the base stations
for execution. Realizing this value in the RAN is still a
work-in-progress, but products that take this approach are
emerging. Evidence using an analogous approach to optimize
wide-area networks over many years is compelling.

While the above loosely categorizes the space of potential control
apps as either config-oriented or control-oriented, another possible
characterization is based on the current practice of controlling the
mobile link at two different levels. At a fine-grain level, per-node
and per-link control is conducted using Radio Resource Management
(RRM) functions that are distributed across the individual base
stations.  RRM functions include scheduling, handover control, link
and carrier aggregation control, bearer control, and access control.
At a coarse-grain level, regional mobile network optimization and
configuration is conducted using *Self-Organizing Network (SON)*
functions. These functions oversee neighbor lists, manage load
balancing, optimize coverage and capacity, aim for network-wide
interference mitigation, centrally configure parameters, and so on. As
a consequence of these two levels of control, it is not uncommon to
see reference to *RRM Applications* and *SON Applications*,
respectively, in O-RAN documents for SD-RAN.

The interface names are cryptic, and knowing their details adds little
to our conceptual understanding of the RAN, except perhaps to
re-enforce how challenging it is to introduce a transformative
technology like Software-Defined Networking into an operational
environment that is striving to achieve full backward compatibility
and universal interoperability. That said, we call out two notable
examples.

The first is the **A1** interface that the mobile operator's
management plane—typically called the *OSS/BSS (Operations Support
System / Business Support System)* in the Telco world—uses to
configure the RAN.  We have not discussed the Telco OSS/BSS up to this
point, but it safe to assume such a component sits at the top of any
Telco software stack. It is the source of all configuration settings
and business logic needed to operate a network. Notice that the
Management Plane shown in :numref:`Figure %s (c) <fig-ric>`
includes a *Non-Real-Time RIC* functional block, complementing the
Near-RT RIC that sits below the A1 interface. We return to the
relevance of these two RICs in a moment.

The second is the **E2** interface that the Near-RT RIC uses to
control the underlying RAN elements. A requirement of the E2 interface
is that it be able to connect the Near-RT RIC to different types of
RAN elements. This range is reflected in the API, which revolves
around a *Service Model* abstraction. The idea is that each RAN
element advertises a Service Model, which effectively defines the set
of RAN Functions the element is able to support. The RIC then issues a
combination of the following four operations against this Service
Model.

* **Report:** RIC asks the element to report a function-specific value setting.
* **Insert:** RIC instructs the element to activate a user plane function.
* **Control:** RIC instructs the element to activate a control plane function.
* **Policy:** RIC sets a policy parameter on one of the activated functions.

Of course, it is the RAN element, through its published Service Model,
that defines the relevant set of functions that can be activated, the
variables that can be reported, and policies that can be set.

Taken together, the A1 and E2 interfaces complete two of the three
major control loops of the RAN: the outer (non-real-time) loop has the
Non-RT RIC as its control point and the middle (near-real-time) loop has
the Near-RT RIC as its control point. The third (inner) control loop,
which is not shown in :numref:`Figure %s <fig-ric>`, runs inside
the DU: It includes the real-time Scheduler embedded in the MAC stage
of the RAN pipeline. The two outer control loops have rough time
bounds of >>1sec and >10ms, respectively, and as we saw in Chapter 2,
the real-time control loop is assumed to be <1ms.

This raises the question of how specific functionality is distributed
between the Non-RT RIC, Near-RT RIC, and DU. Starting with the second
pair (i.e., the two inner loops), it is important to recognize that
not all RRM functions can be centralized. After horizontal and
vertical CUPS disaggregation, the RRM functions are split between CU-C
and DU. For this reason, the SDN-based vertical disaggregation focuses
on centralizing CU-C-side RRM functions in the Near-RT RIC. In
addition to RRM control, this includes all the SON applications.

Turning to the outer two control loops, the Near RT-RIC opens the
possibility of introducing policy-based RAN control, whereby
interrupts (exceptions) to operator-defined policies would signal the
need for the outer loop to become involved. For example, one can
imagine developing learning-based controls, where the inference
engines for these controls would run as applications on the Near
RT-RIC, and their non-real-time learning counterparts would run
elsewhere. The Non-RT RIC would then interact with the Near-RT RIC to
deliver relevant operator policies from the Management Plane to the
Near RT-RIC over the A1 interface.

Finally, you may be wondering why there is an O-RAN Alliance in the
first place, given that 3GPP is already the standardization body
responsible for interoperability across the global cellular network.
The answer is that over time 3GPP has become a vendor-dominated
organization, whereas O-RAN was created more recently by network
operators. (AT&T and China Mobile were the founding members.) O-RAN’s
goal is to catalyze a software-based implementation that breaks the
vendor lock-in that dominates today’s marketplace. The E2 interface
in particular, which is architected around the idea of supporting
different Service Models, is central to this strategy. Whether the
operators will be successful in their ultimate goal is yet to be seen.

 
9.4  Relationship to SD-Fabric
-----------------------------------

Circle back to SD-Fabric and especially ``fabric.p4``, where we
implement UPF and BNG.
