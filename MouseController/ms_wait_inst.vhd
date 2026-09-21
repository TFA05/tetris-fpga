ms_wait_inst : ms_wait PORT MAP (
		clock	 => clock_sig,
		cnt_en	 => cnt_en_sig,
		cout	 => cout_sig,
		q	 => q_sig
	);
