import p4runtime_lib.helper
	...
table_entry = p4info_helper.buildTableEntry(
    table_name="MyIngress.ipv4_lpm",
    match_fields={
        "hdr.ipv4.dstAddr": (dst_ip_addr, 32)
    },
    action_name="MyIngress.ipv4_forward",
    action_params={
        "dstAddr": next_hop_mac_addr,
        "port": outport,
    })
ingress_sw.WriteTableEntry(table_entry)
