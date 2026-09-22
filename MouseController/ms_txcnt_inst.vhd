ms_txcnt_inst : ms_txcnt PORT MAP (
		clock	 => clock_sig,
		cnt_en	 => cnt_en_sig,
		sclr	 => sclr_sig,
		cout	 => cout_sig,
		q	 => q_sig
	);
