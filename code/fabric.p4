apply {
#ifdef UPF
    upf_normalizer.apply(hdr.gtpu.isValid(), hdr.gtpu_ipv4,
	hdr.gtpu_udp, hdr.ipv4, hdr.udp, hdr.inner_ipv4,
	hdr.inner_udp);
#endif // UPF

    // Filtering Objective
    pkt_io_ingress.apply(hdr, fabric_metadata, standard_metadata);
    filtering.apply(hdr, fabric_metadata, standard_metadata);
#ifdef UPF
    upf_ingress.apply(hdr.gtpu_ipv4, hdr.gtpu_udp, hdr.gtpu,
	hdr.ipv4, hdr.udp, fabric_metadata, standard_metadata);
#endif // UPF

    // Forwarding Objective
    if (fabric_metadata.skip_forwarding == _FALSE) {
        forwarding.apply(hdr, fabric_metadata, standard_metadata);
    }
    acl.apply(hdr, fabric_metadata, standard_metadata);

    // Next Objective
    if (fabric_metadata.skip_next == _FALSE) {
        next.apply(hdr, fabric_metadata, standard_metadata);
#if defined INT
        process_set_source_sink.apply(hdr, fabric_metadata,
	    standard_metadata);
#endif // INT
    }	
#ifdef BNG
    bng_ingress.apply(hdr, fabric_metadata, standard_metadata);
#endif // BNG
}
