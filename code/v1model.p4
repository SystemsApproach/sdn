#include <core.p4>
#include <v1model.p4>

/* Headers */
struct metadata { ... }
struct headers {
	ethernet_t	ethernet;
	ipv4_t		ipv4;
}

/* Parser */
parser MyParser(
	packet_in packet,
	out headers hdr,
	inout metadata meta,
	inout standard_metadata_t smeta) {
    ...
}

/* Checksum Verification */
control MyVerifyChecksum(
	in headers, hdr,
	inout metadata meta) {
    ...
}

/* Ingress Proceessing */
control MyIngress(
	inout headers hdr,
	inout metadata meta,
	inout standard_metadata_t smeta) {
    ...
}

/* Egress Proceessing */
control MyEgress(
	inout headers hdr,
	inout metadata meta,
	inout standard_metadata_t smeta) {
    ...
}

/* Checksum Update */
control MyComputeChecksum(
	inout headers, hdr,
	inout metadata meta) {
    ...
}

/* Deparser */
parser MyDeparser(
	inout headers hdr,
	inout metadata meta) {
    ...
}

/* Switch */
V1Switch(
    MyParser(),
    MyVerifyChecksum(),
    MyIngress(),
    MyEgress(),
    MyComputeChecksum(),
    MyDeparser()
) main;