/****************************************************
******  I N G R E S S   P R O C E S S I N G   *******
****************************************************/

control MyIngress(
	inout headers hdr,
	inout metadata meta,
	inout standard_metadata_t standard_metadata) {			

    action drop() {
        mark_to_drop(standard_metadata);
    }
    
    action ipv4_forward(macAddr_t dstAddr,
			egressSpec_t port) {
	standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.dstAddr = dstAddr;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }
    
    table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
       default_action = drop();
    }
   
    apply {
        if (hdr.ipv4.isValid()) {
            ipv4_lpm.apply();
        }
   }
}
