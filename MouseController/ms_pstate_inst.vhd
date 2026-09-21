ms_pstate_inst : ms_pstate PORT MAP (
		clock	 => clock_sig,
		cnt_en	 => cnt_en_sig,
		sclr	 => sclr_sig,
		cout	 => cout_sig,
		q	 => q_sig
	);
