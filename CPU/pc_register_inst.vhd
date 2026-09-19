pc_register_inst : pc_register PORT MAP (
		aclr	 => aclr_sig,
		clock	 => clock_sig,
		data	 => data_sig,
		enable	 => enable_sig,
		load	 => load_sig,
		q	 => q_sig
	);
