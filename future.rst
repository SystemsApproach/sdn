Chapter 10:  Future of SDN
===========================

It is still early days for SDN. Cloud-hosted control planes are being
deployed in production networks, but we are only just starting to see
SDN being applied to access networks and programmable pipelines being
used to introduce new data plane functionality. Enterprises have
adopted network virtualization and SD-WAN to varying degrees, but
there are still a lot more traditional networks than software-defined
ones.

As the technology matures and the APIs stabilize we expect to
see increased adoption of the use cases discussed earlier, but it may
be new use cases still on the horizon that have the biggest impact on
the role SDN eventually plays. Indeed, the ability to support
capabilities that were impossible in traditional networks is a great
part of the promise of SDN.

This chapter looks at a promising opportunity, revolving around the
verification of correctness. Networks are notoriously difficult to make
verifiably robust and secure against failures, attacks, and
configuration mistakes. While network verification has been a field of
interest for several years, the lack of clear abstractions in
networking has limited the progress that can be made. Most networks are still built
using closed/proprietary software and complex/fixed-function hardware,
whose correctness is hard to prove and whose design has unknown
provenance. The distributed algorithms that determine how networks
operate are notoriously difficult to reason about, with BGP being a
classic example of a protocol whose failure modes have kept
researchers and practitioners occupied for decades.

The emergence of 5G networks and applications will only exacerbate the
situation. 5G networks will connect not only smart phones and people,
but also everything from doorbells, to lights, refrigerators,
self-driving cars, and drones. If we cannot correctly configure and
secure these networks, the risk of cyber disasters is much worse than
anything experienced to date.

A critical capability for a reliable and secure Internet is verifiability:
the ability to ensure that every packet in the network follows an
operator-specified path and encounters only a set of forwarding rules
within every device that the operator intended. Nothing more and
nothing less.

Experience has shown that verification works best in settings where
the overall system is constructed in a compositional (i.e.,
disaggregated) manner. Being able to reason about small pieces makes
verification tractable, and the reasoning needed to stitch the
components together into the composite system can also lead to
insights. With disaggregation as the foundation, verifiability follows
from (a) the ability to state intent *at the network level* rather
than at the box level, and (b) the ability to observe
behavior at fine granularity and in real-time. This is exactly the
value SDN brings to the table, which leads to optimism that
*verifiable closed-loop control* is now within reach.



.. _reading_pronto:
.. admonition:: Further Reading  
   
   N. Foster, et. al. `Using Deep Programmability to Put Network
   Owners in Control
   <https://ccronline.sigcomm.org/2020/ccr-october-2020/using-deep-programmability-to-put-network-owners-in-control/>`__.
   ACM SIGCOMM Computer Communication Review, October 2020. 

:numref:`Figure %s <fig-closed-loop>` illustrates the basic idea.  The
software stack described in this book is augmented with the
measurement, code generation, and verification elements needed for
verifiable closed-loop control. Fine-grained measurements can be
implemented using INT (Inband Network Telemetry), which allows every
packet to be stamped by the forwarding elements to indicate the path
it took, the queuing delay it experienced, and the rules it matched.
These measurements can then be analyzed and fed back into code
generation and formal verification tools. This closed loop complements
the intrinsic value of disaggregation, which makes it possible to
reason about correctness-by-construction.

.. _fig-closed-loop:
.. figure:: figures/Slide30.png
    :width: 600px
    :align: center

    INT generates fine-grain measurements, which in turn feed a closed
    control loop that verifies the network’s behavior.

.. sidebar:: Top-Down Verification
	     
   *The approach to verifying networks described in this chapter is
   similar to the one used in chip design. At the top is a behavioral
   model; then at the register-transfer level is a Verilog or VHDL
   model; and eventually at the bottom are transistors, polygons and
   metal. Tools are used to formally verify correctness across each
   boundary and abstraction level.*

   *This is a model for what we are talking about here: Verifying
   across boundaries in a top-down design approach. This is made
   possible by the new SDN interfaces and abstractions defined by the
   software stack, which extends all the way to the programmable
   forwarding pipelines provided by the switching chip.*

   *As experience with hardware verification demonstrates, this
   approach works best in composed systems, where each minimal
   component can be verified or reliably tested on its own. Formal
   tools are then applied as components are composed at layer
   boundaries.*

The goal is to enable network operators to specify a network’s
behavior top-down, and then verifying the correctness across each
interface. At the lowest level, P4 programs specify how packets are
processed; these programs are compiled to run on the forwarding plane
elements. Such an approach represents a fundamental new capability
that has not been possible in conventional designs, based on two key
insights.
   
First, while network control planes are inherently complicated, a P4
data plane captures *ground truth* for the network—i.e., how it
forwards packets—and is therefore an attractive platform for deploying
verification technologies. By observing and then validating behavior
at the data plane level, it is possible to reduce the trusted
computing base: the switch operating system, driver, and other
low-level components do not need to be trusted. Moreover, whereas the
control plane tends to be written in a general-purpose language and is
correspondingly complex, the data plane is necessarily simple: it is
ultimately compiled to an efficient, feed-forward pipeline
architecture with simple data types and limited state. While verifying
general-purpose software is impossible in the general case, data plane
verification is both powerful and practical.

This claim of practicality is grounded in the current
state-of-the-art.  Once the forwarding behavior is defined and known,
then forwarding table state defines forwarding behavior. For example,
if everything is known to be IPv4-forwarded, then the forwarding table
state in all routers is enough to define the network behavior. This
idea has been reduced to practice by techniques like Veriflow and
Header Space Analysis (HSA), and is now available commercially.
Knowing that this state is enough to verify networks with fixed
forwarding behavior means that we are "merely" adding one new
degree-of-freedom: allowing the network operator to program the
forwarding behavior (and evolve it over time) using P4. The use of P4
to program the data plane is key: the language carefully excludes
features such as loops and pointer-based data structures, which
typically make analysis impractical. To read more about the
opportunity, we recommend a paper by Jed Liu and colleagues.

.. _reading_p4:
.. admonition:: Further Reading

   J. Liu, et. al. `p4v: Practical Verification for Programmable Data Planes
   <http://yuba.stanford.edu/~nickm/papers/p4v.pdf>`__. ACM
   SIGCOMM 2018.

The second insight is that, in addition to building tools for
analyzing network programs, it is important also to develop
technologies that map the high-level intent of the network operator to
code that implements that intent. One of the challenges of current
approaches to network verification is that they take existing network
equipment, with their complex distributed control planes, as their
starting point, and build mathematical models of how those
control planes behave. If the reality doesn't precisely match the
model, then verification won't ensure that the network behaves as
required. But with the centralized control model of SDN,
the control plane is designed to map a centrally specified request
into a set of control directives that can be implemented in the data
plane. And we are starting to see systems in which the SDN control
plane itself is compiled from a high level specification of its
desired properties. Thus we can hope to see control planes that are
correct by construction, rather than trying to build models that
accurately capture the behavior of historically hard-to-analyze
systems like BGP.\ [#]_

.. [#] It's hard to imagine BGP ever going away entirely for
       interdomain routing, but at least for the large set of intradomain use
       cases the chance to design for verifiability seems possible.

.. _fig-phase3:
.. figure:: figures/Slide37.png
    :width: 600px
    :align: center

    Projecting into the future, with Phase 3 of SDN focusing on
    verifiable, top-down control of network behavior.

To put this all in an historical context, :numref:`Figure %s
<fig-phase3>` illustrates a view of three phases of SDN. It is fair to
say that we are in the early stages of phase 2, where the most
advanced operators have been able to take control of their software,
via disaggregated control planes, and of their packet processing,  via
P4-programmable data planes. We see an emerging third phase, during which
verifiable closed loop control will empower network operators to take
full ownership of the software that defines their networks. Not only
will they be able to determine the behavior of their networks through
software, but they will be able to provide that the network is
implementing their intent. Just as the hardware industry has developed
high confidence that chips will work as intended before they go into
manufacturing, network operators will have confidence that their
networks are reliable, secure, and meeting their specified
objectives. 


