-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

-- DATE "09/21/2026 13:44:54"

-- 
-- Device: Altera EP3C16F484C6 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIII;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIII.CYCLONEIII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	TESTTT IS
    PORT (
	LED0 : OUT std_logic;
	CLK : IN std_logic;
	PS2_DATA : IN std_logic;
	PS2_CLK : IN std_logic;
	LED1 : OUT std_logic;
	LED2 : OUT std_logic;
	LED3 : OUT std_logic;
	LED4 : OUT std_logic
	);
END TESTTT;

-- Design Ports Information
-- LED0	=>  Location: PIN_E22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED1	=>  Location: PIN_H19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED2	=>  Location: PIN_H20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED3	=>  Location: PIN_E21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED4	=>  Location: PIN_H18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- CLK	=>  Location: PIN_G2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- PS2_DATA	=>  Location: PIN_F22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- PS2_CLK	=>  Location: PIN_M20,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF TESTTT IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_LED0 : std_logic;
SIGNAL ww_CLK : std_logic;
SIGNAL ww_PS2_DATA : std_logic;
SIGNAL ww_PS2_CLK : std_logic;
SIGNAL ww_LED1 : std_logic;
SIGNAL ww_LED2 : std_logic;
SIGNAL ww_LED3 : std_logic;
SIGNAL ww_LED4 : std_logic;
SIGNAL \CLK~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \inst|inst1|inst39|inst1~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \LED0~output_o\ : std_logic;
SIGNAL \LED1~output_o\ : std_logic;
SIGNAL \LED2~output_o\ : std_logic;
SIGNAL \LED3~output_o\ : std_logic;
SIGNAL \LED4~output_o\ : std_logic;
SIGNAL \CLK~input_o\ : std_logic;
SIGNAL \CLK~inputclkctrl_outclk\ : std_logic;
SIGNAL \PS2_CLK~input_o\ : std_logic;
SIGNAL \inst|inst1|inst39|inst~q\ : std_logic;
SIGNAL \inst|inst1|inst39|inst2|inst~0_combout\ : std_logic;
SIGNAL \inst|inst1|inst39|inst2|inst~q\ : std_logic;
SIGNAL \inst|inst1|inst39|inst3|inst~0_combout\ : std_logic;
SIGNAL \inst|inst1|inst39|inst3|inst~q\ : std_logic;
SIGNAL \inst|inst1|inst39|inst6~combout\ : std_logic;
SIGNAL \inst|inst1|inst39|inst4|inst~0_combout\ : std_logic;
SIGNAL \inst|inst1|inst39|inst4|inst~q\ : std_logic;
SIGNAL \inst|inst1|inst39|inst5~combout\ : std_logic;
SIGNAL \inst|inst1|inst39|inst1~q\ : std_logic;
SIGNAL \inst|inst1|inst39|inst1~clkctrl_outclk\ : std_logic;
SIGNAL \PS2_DATA~input_o\ : std_logic;
SIGNAL \inst|inst1|inst~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst~q\ : std_logic;
SIGNAL \inst|inst1|inst1~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst1~q\ : std_logic;
SIGNAL \inst|inst1|inst2~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst2~q\ : std_logic;
SIGNAL \inst|inst1|inst3~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst3~q\ : std_logic;
SIGNAL \inst|inst1|inst4~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst4~q\ : std_logic;
SIGNAL \inst|inst1|inst5~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst5~q\ : std_logic;
SIGNAL \inst|inst1|inst21~1_combout\ : std_logic;
SIGNAL \inst|inst1|inst21~0_combout\ : std_logic;
SIGNAL \inst|inst1|inst21~2_combout\ : std_logic;
SIGNAL \inst|inst1|inst21~3_combout\ : std_logic;
SIGNAL \inst|inst1|inst10~q\ : std_logic;
SIGNAL \inst|inst1|inst11~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst11~q\ : std_logic;
SIGNAL \inst|inst1|inst12~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst12~q\ : std_logic;
SIGNAL \inst|inst1|inst13~q\ : std_logic;
SIGNAL \inst|inst1|inst14~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst14~q\ : std_logic;
SIGNAL \inst|inst1|inst15~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst15~q\ : std_logic;
SIGNAL \inst|inst1|inst16~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst16~q\ : std_logic;
SIGNAL \inst|inst1|inst17~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst17~q\ : std_logic;
SIGNAL \inst|inst1|inst18~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst18~q\ : std_logic;
SIGNAL \inst|inst1|inst19~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst19~q\ : std_logic;
SIGNAL \inst|inst1|inst38|inst~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst38|inst~q\ : std_logic;
SIGNAL \inst|inst1|inst38|inst1~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst38|inst1~q\ : std_logic;
SIGNAL \inst|inst1|inst38|inst2~combout\ : std_logic;
SIGNAL \inst|inst1|inst34~q\ : std_logic;
SIGNAL \inst|inst1|inst32~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst32~q\ : std_logic;
SIGNAL \inst|inst1|inst31~q\ : std_logic;
SIGNAL \inst|inst1|inst6~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst6~q\ : std_logic;
SIGNAL \inst|inst1|inst7~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst7~q\ : std_logic;
SIGNAL \inst|inst1|inst36~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst36~q\ : std_logic;
SIGNAL \inst|inst|inst~1_combout\ : std_logic;
SIGNAL \inst|inst1|inst8~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst8~q\ : std_logic;
SIGNAL \inst|inst1|inst37~q\ : std_logic;
SIGNAL \inst|inst1|inst35~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst35~q\ : std_logic;
SIGNAL \inst|inst1|inst30~q\ : std_logic;
SIGNAL \inst|inst1|inst33~feeder_combout\ : std_logic;
SIGNAL \inst|inst1|inst33~q\ : std_logic;
SIGNAL \inst|inst|inst~0_combout\ : std_logic;
SIGNAL \inst|inst|inst~combout\ : std_logic;
SIGNAL \inst|inst1|inst28~0_combout\ : std_logic;
SIGNAL \inst|inst1|inst28~q\ : std_logic;
SIGNAL \inst|inst|inst2~q\ : std_logic;
SIGNAL \inst|inst|inst5~0_combout\ : std_logic;
SIGNAL \inst|inst|inst5~1_combout\ : std_logic;
SIGNAL \inst|inst|inst36~0_combout\ : std_logic;
SIGNAL \inst|inst|inst36~q\ : std_logic;
SIGNAL \inst|inst|inst35~0_combout\ : std_logic;
SIGNAL \inst|inst|inst35~q\ : std_logic;
SIGNAL \inst|inst|inst38~0_combout\ : std_logic;
SIGNAL \inst|inst|inst38~q\ : std_logic;
SIGNAL \inst|inst|inst37~0_combout\ : std_logic;
SIGNAL \inst|inst|inst37~q\ : std_logic;
SIGNAL \inst|inst|inst39~0_combout\ : std_logic;
SIGNAL \inst|inst|inst39~q\ : std_logic;

BEGIN

LED0 <= ww_LED0;
ww_CLK <= CLK;
ww_PS2_DATA <= PS2_DATA;
ww_PS2_CLK <= PS2_CLK;
LED1 <= ww_LED1;
LED2 <= ww_LED2;
LED3 <= ww_LED3;
LED4 <= ww_LED4;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\CLK~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \CLK~input_o\);

\inst|inst1|inst39|inst1~clkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \inst|inst1|inst39|inst1~q\);

-- Location: IOOBUF_X41_Y23_N16
\LED0~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|inst|inst36~q\,
	devoe => ww_devoe,
	o => \LED0~output_o\);

-- Location: IOOBUF_X41_Y23_N23
\LED1~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|inst|inst35~q\,
	devoe => ww_devoe,
	o => \LED1~output_o\);

-- Location: IOOBUF_X41_Y22_N2
\LED2~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|inst|inst38~q\,
	devoe => ww_devoe,
	o => \LED2~output_o\);

-- Location: IOOBUF_X41_Y23_N9
\LED3~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|inst|inst37~q\,
	devoe => ww_devoe,
	o => \LED3~output_o\);

-- Location: IOOBUF_X41_Y23_N2
\LED4~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|inst|inst39~q\,
	devoe => ww_devoe,
	o => \LED4~output_o\);

-- Location: IOIBUF_X0_Y14_N1
\CLK~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_CLK,
	o => \CLK~input_o\);

-- Location: CLKCTRL_G4
\CLK~inputclkctrl\ : cycloneiii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \CLK~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \CLK~inputclkctrl_outclk\);

-- Location: IOIBUF_X41_Y14_N15
\PS2_CLK~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_PS2_CLK,
	o => \PS2_CLK~input_o\);

-- Location: FF_X40_Y15_N3
\inst|inst1|inst39|inst\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	asdata => \PS2_CLK~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst39|inst~q\);

-- Location: LCCOMB_X40_Y15_N20
\inst|inst1|inst39|inst2|inst~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst39|inst2|inst~0_combout\ = (!\inst|inst1|inst39|inst2|inst~q\ & (\PS2_CLK~input_o\ $ (!\inst|inst1|inst39|inst~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000000011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \PS2_CLK~input_o\,
	datac => \inst|inst1|inst39|inst2|inst~q\,
	datad => \inst|inst1|inst39|inst~q\,
	combout => \inst|inst1|inst39|inst2|inst~0_combout\);

-- Location: FF_X40_Y15_N21
\inst|inst1|inst39|inst2|inst\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst39|inst2|inst~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst39|inst2|inst~q\);

-- Location: LCCOMB_X40_Y15_N24
\inst|inst1|inst39|inst3|inst~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst39|inst3|inst~0_combout\ = (\inst|inst1|inst39|inst2|inst~q\ & (!\inst|inst1|inst39|inst3|inst~q\ & (\PS2_CLK~input_o\ $ (!\inst|inst1|inst39|inst~q\)))) # (!\inst|inst1|inst39|inst2|inst~q\ & (\inst|inst1|inst39|inst3|inst~q\ & 
-- (\PS2_CLK~input_o\ $ (!\inst|inst1|inst39|inst~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100100000010010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst39|inst2|inst~q\,
	datab => \PS2_CLK~input_o\,
	datac => \inst|inst1|inst39|inst3|inst~q\,
	datad => \inst|inst1|inst39|inst~q\,
	combout => \inst|inst1|inst39|inst3|inst~0_combout\);

-- Location: FF_X40_Y15_N25
\inst|inst1|inst39|inst3|inst\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst39|inst3|inst~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst39|inst3|inst~q\);

-- Location: LCCOMB_X40_Y15_N28
\inst|inst1|inst39|inst6\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst39|inst6~combout\ = \PS2_CLK~input_o\ $ (\inst|inst1|inst39|inst~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \PS2_CLK~input_o\,
	datad => \inst|inst1|inst39|inst~q\,
	combout => \inst|inst1|inst39|inst6~combout\);

-- Location: LCCOMB_X40_Y15_N30
\inst|inst1|inst39|inst4|inst~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst39|inst4|inst~0_combout\ = (!\inst|inst1|inst39|inst6~combout\ & (\inst|inst1|inst39|inst4|inst~q\ $ (((\inst|inst1|inst39|inst2|inst~q\ & \inst|inst1|inst39|inst3|inst~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst39|inst2|inst~q\,
	datab => \inst|inst1|inst39|inst3|inst~q\,
	datac => \inst|inst1|inst39|inst4|inst~q\,
	datad => \inst|inst1|inst39|inst6~combout\,
	combout => \inst|inst1|inst39|inst4|inst~0_combout\);

-- Location: FF_X40_Y15_N31
\inst|inst1|inst39|inst4|inst\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst39|inst4|inst~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst39|inst4|inst~q\);

-- Location: LCCOMB_X40_Y15_N26
\inst|inst1|inst39|inst5\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst39|inst5~combout\ = (\inst|inst1|inst39|inst4|inst~q\ & (\inst|inst1|inst39|inst2|inst~q\ & \inst|inst1|inst39|inst3|inst~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst39|inst4|inst~q\,
	datab => \inst|inst1|inst39|inst2|inst~q\,
	datad => \inst|inst1|inst39|inst3|inst~q\,
	combout => \inst|inst1|inst39|inst5~combout\);

-- Location: FF_X40_Y15_N27
\inst|inst1|inst39|inst1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	asdata => \inst|inst1|inst39|inst~q\,
	sload => VCC,
	ena => \inst|inst1|inst39|inst5~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst39|inst1~q\);

-- Location: CLKCTRL_G7
\inst|inst1|inst39|inst1~clkctrl\ : cycloneiii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \inst|inst1|inst39|inst1~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \inst|inst1|inst39|inst1~clkctrl_outclk\);

-- Location: IOIBUF_X41_Y22_N22
\PS2_DATA~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_PS2_DATA,
	o => \PS2_DATA~input_o\);

-- Location: LCCOMB_X38_Y23_N4
\inst|inst1|inst~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst~feeder_combout\ = \PS2_DATA~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \PS2_DATA~input_o\,
	combout => \inst|inst1|inst~feeder_combout\);

-- Location: FF_X38_Y23_N5
\inst|inst1|inst\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst~q\);

-- Location: LCCOMB_X39_Y23_N26
\inst|inst1|inst1~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst1~feeder_combout\ = \inst|inst1|inst~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst1|inst~q\,
	combout => \inst|inst1|inst1~feeder_combout\);

-- Location: FF_X39_Y23_N27
\inst|inst1|inst1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst1~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst1~q\);

-- Location: LCCOMB_X39_Y23_N4
\inst|inst1|inst2~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst2~feeder_combout\ = \inst|inst1|inst1~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst1|inst1~q\,
	combout => \inst|inst1|inst2~feeder_combout\);

-- Location: FF_X39_Y23_N5
\inst|inst1|inst2\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst2~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst2~q\);

-- Location: LCCOMB_X39_Y23_N16
\inst|inst1|inst3~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst3~feeder_combout\ = \inst|inst1|inst2~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst1|inst2~q\,
	combout => \inst|inst1|inst3~feeder_combout\);

-- Location: FF_X39_Y23_N17
\inst|inst1|inst3\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst3~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst3~q\);

-- Location: LCCOMB_X39_Y23_N2
\inst|inst1|inst4~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst4~feeder_combout\ = \inst|inst1|inst3~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst3~q\,
	combout => \inst|inst1|inst4~feeder_combout\);

-- Location: FF_X39_Y23_N3
\inst|inst1|inst4\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst4~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst4~q\);

-- Location: LCCOMB_X39_Y23_N14
\inst|inst1|inst5~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst5~feeder_combout\ = \inst|inst1|inst4~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst4~q\,
	combout => \inst|inst1|inst5~feeder_combout\);

-- Location: FF_X39_Y23_N15
\inst|inst1|inst5\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst5~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst5~q\);

-- Location: LCCOMB_X38_Y23_N20
\inst|inst1|inst21~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst21~1_combout\ = (!\inst|inst1|inst13~q\ & (!\inst|inst1|inst14~q\ & (!\inst|inst1|inst15~q\ & !\inst|inst1|inst16~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst13~q\,
	datab => \inst|inst1|inst14~q\,
	datac => \inst|inst1|inst15~q\,
	datad => \inst|inst1|inst16~q\,
	combout => \inst|inst1|inst21~1_combout\);

-- Location: LCCOMB_X38_Y23_N22
\inst|inst1|inst21~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst21~0_combout\ = (!\PS2_DATA~input_o\ & (!\inst|inst1|inst19~q\ & (!\inst|inst1|inst18~q\ & !\inst|inst1|inst17~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \PS2_DATA~input_o\,
	datab => \inst|inst1|inst19~q\,
	datac => \inst|inst1|inst18~q\,
	datad => \inst|inst1|inst17~q\,
	combout => \inst|inst1|inst21~0_combout\);

-- Location: LCCOMB_X38_Y23_N28
\inst|inst1|inst21~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst21~2_combout\ = (!\inst|inst1|inst10~q\ & (!\inst|inst1|inst11~q\ & (\inst|inst1|inst~q\ & !\inst|inst1|inst12~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst10~q\,
	datab => \inst|inst1|inst11~q\,
	datac => \inst|inst1|inst~q\,
	datad => \inst|inst1|inst12~q\,
	combout => \inst|inst1|inst21~2_combout\);

-- Location: LCCOMB_X38_Y23_N12
\inst|inst1|inst21~3\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst21~3_combout\ = (\inst|inst1|inst21~1_combout\ & (\inst|inst1|inst21~0_combout\ & \inst|inst1|inst21~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|inst1|inst21~1_combout\,
	datac => \inst|inst1|inst21~0_combout\,
	datad => \inst|inst1|inst21~2_combout\,
	combout => \inst|inst1|inst21~3_combout\);

-- Location: FF_X38_Y23_N13
\inst|inst1|inst10\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst21~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst10~q\);

-- Location: LCCOMB_X38_Y23_N14
\inst|inst1|inst11~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst11~feeder_combout\ = \inst|inst1|inst10~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst10~q\,
	combout => \inst|inst1|inst11~feeder_combout\);

-- Location: FF_X38_Y23_N15
\inst|inst1|inst11\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst11~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst11~q\);

-- Location: LCCOMB_X38_Y23_N2
\inst|inst1|inst12~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst12~feeder_combout\ = \inst|inst1|inst11~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst11~q\,
	combout => \inst|inst1|inst12~feeder_combout\);

-- Location: FF_X38_Y23_N3
\inst|inst1|inst12\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst12~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst12~q\);

-- Location: FF_X38_Y23_N7
\inst|inst1|inst13\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	asdata => \inst|inst1|inst12~q\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst13~q\);

-- Location: LCCOMB_X38_Y23_N0
\inst|inst1|inst14~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst14~feeder_combout\ = \inst|inst1|inst13~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst1|inst13~q\,
	combout => \inst|inst1|inst14~feeder_combout\);

-- Location: FF_X38_Y23_N1
\inst|inst1|inst14\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst14~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst14~q\);

-- Location: LCCOMB_X38_Y23_N26
\inst|inst1|inst15~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst15~feeder_combout\ = \inst|inst1|inst14~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst14~q\,
	combout => \inst|inst1|inst15~feeder_combout\);

-- Location: FF_X38_Y23_N27
\inst|inst1|inst15\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst15~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst15~q\);

-- Location: LCCOMB_X38_Y23_N16
\inst|inst1|inst16~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst16~feeder_combout\ = \inst|inst1|inst15~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst1|inst15~q\,
	combout => \inst|inst1|inst16~feeder_combout\);

-- Location: FF_X38_Y23_N17
\inst|inst1|inst16\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst16~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst16~q\);

-- Location: LCCOMB_X38_Y23_N10
\inst|inst1|inst17~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst17~feeder_combout\ = \inst|inst1|inst16~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst16~q\,
	combout => \inst|inst1|inst17~feeder_combout\);

-- Location: FF_X38_Y23_N11
\inst|inst1|inst17\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst17~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst17~q\);

-- Location: LCCOMB_X38_Y23_N30
\inst|inst1|inst18~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst18~feeder_combout\ = \inst|inst1|inst17~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst1|inst17~q\,
	combout => \inst|inst1|inst18~feeder_combout\);

-- Location: FF_X38_Y23_N31
\inst|inst1|inst18\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst18~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst18~q\);

-- Location: LCCOMB_X38_Y23_N18
\inst|inst1|inst19~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst19~feeder_combout\ = \inst|inst1|inst18~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst18~q\,
	combout => \inst|inst1|inst19~feeder_combout\);

-- Location: FF_X38_Y23_N19
\inst|inst1|inst19\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst19~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst19~q\);

-- Location: LCCOMB_X38_Y23_N8
\inst|inst1|inst38|inst~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst38|inst~feeder_combout\ = \inst|inst1|inst19~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst19~q\,
	combout => \inst|inst1|inst38|inst~feeder_combout\);

-- Location: FF_X38_Y23_N9
\inst|inst1|inst38|inst\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst38|inst~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst38|inst~q\);

-- Location: LCCOMB_X38_Y23_N24
\inst|inst1|inst38|inst1~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst38|inst1~feeder_combout\ = \inst|inst1|inst38|inst~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst38|inst~q\,
	combout => \inst|inst1|inst38|inst1~feeder_combout\);

-- Location: FF_X38_Y23_N25
\inst|inst1|inst38|inst1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst38|inst1~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst38|inst1~q\);

-- Location: LCCOMB_X38_Y23_N6
\inst|inst1|inst38|inst2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst38|inst2~combout\ = (\inst|inst1|inst38|inst~q\ & !\inst|inst1|inst38|inst1~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|inst1|inst38|inst~q\,
	datad => \inst|inst1|inst38|inst1~q\,
	combout => \inst|inst1|inst38|inst2~combout\);

-- Location: FF_X39_Y23_N13
\inst|inst1|inst34\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	asdata => \inst|inst1|inst5~q\,
	sload => VCC,
	ena => \inst|inst1|inst38|inst2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst34~q\);

-- Location: LCCOMB_X39_Y23_N0
\inst|inst1|inst32~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst32~feeder_combout\ = \inst|inst1|inst3~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst3~q\,
	combout => \inst|inst1|inst32~feeder_combout\);

-- Location: FF_X39_Y23_N1
\inst|inst1|inst32\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst32~feeder_combout\,
	ena => \inst|inst1|inst38|inst2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst32~q\);

-- Location: FF_X39_Y23_N7
\inst|inst1|inst31\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	asdata => \inst|inst1|inst2~q\,
	sload => VCC,
	ena => \inst|inst1|inst38|inst2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst31~q\);

-- Location: LCCOMB_X39_Y23_N22
\inst|inst1|inst6~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst6~feeder_combout\ = \inst|inst1|inst5~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst1|inst5~q\,
	combout => \inst|inst1|inst6~feeder_combout\);

-- Location: FF_X39_Y23_N23
\inst|inst1|inst6\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst6~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst6~q\);

-- Location: LCCOMB_X39_Y23_N18
\inst|inst1|inst7~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst7~feeder_combout\ = \inst|inst1|inst6~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst1|inst6~q\,
	combout => \inst|inst1|inst7~feeder_combout\);

-- Location: FF_X39_Y23_N19
\inst|inst1|inst7\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst7~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst7~q\);

-- Location: LCCOMB_X39_Y23_N28
\inst|inst1|inst36~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst36~feeder_combout\ = \inst|inst1|inst7~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|inst1|inst7~q\,
	combout => \inst|inst1|inst36~feeder_combout\);

-- Location: FF_X39_Y23_N29
\inst|inst1|inst36\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst36~feeder_combout\,
	ena => \inst|inst1|inst38|inst2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst36~q\);

-- Location: LCCOMB_X39_Y23_N6
\inst|inst|inst~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst~1_combout\ = (!\inst|inst1|inst34~q\ & (\inst|inst1|inst32~q\ & (\inst|inst1|inst31~q\ & !\inst|inst1|inst36~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst34~q\,
	datab => \inst|inst1|inst32~q\,
	datac => \inst|inst1|inst31~q\,
	datad => \inst|inst1|inst36~q\,
	combout => \inst|inst|inst~1_combout\);

-- Location: LCCOMB_X39_Y23_N8
\inst|inst1|inst8~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst8~feeder_combout\ = \inst|inst1|inst7~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \inst|inst1|inst7~q\,
	combout => \inst|inst1|inst8~feeder_combout\);

-- Location: FF_X39_Y23_N9
\inst|inst1|inst8\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \inst|inst1|inst39|inst1~clkctrl_outclk\,
	d => \inst|inst1|inst8~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst8~q\);

-- Location: FF_X39_Y23_N31
\inst|inst1|inst37\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	asdata => \inst|inst1|inst8~q\,
	sload => VCC,
	ena => \inst|inst1|inst38|inst2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst37~q\);

-- Location: LCCOMB_X39_Y23_N20
\inst|inst1|inst35~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst35~feeder_combout\ = \inst|inst1|inst6~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst6~q\,
	combout => \inst|inst1|inst35~feeder_combout\);

-- Location: FF_X39_Y23_N21
\inst|inst1|inst35\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst35~feeder_combout\,
	ena => \inst|inst1|inst38|inst2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst35~q\);

-- Location: FF_X39_Y23_N11
\inst|inst1|inst30\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	asdata => \inst|inst1|inst1~q\,
	sload => VCC,
	ena => \inst|inst1|inst38|inst2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst30~q\);

-- Location: LCCOMB_X39_Y23_N24
\inst|inst1|inst33~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst33~feeder_combout\ = \inst|inst1|inst4~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|inst1|inst4~q\,
	combout => \inst|inst1|inst33~feeder_combout\);

-- Location: FF_X39_Y23_N25
\inst|inst1|inst33\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst33~feeder_combout\,
	ena => \inst|inst1|inst38|inst2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst33~q\);

-- Location: LCCOMB_X39_Y23_N10
\inst|inst|inst~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst~0_combout\ = (!\inst|inst1|inst37~q\ & (!\inst|inst1|inst35~q\ & (\inst|inst1|inst30~q\ & \inst|inst1|inst33~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst37~q\,
	datab => \inst|inst1|inst35~q\,
	datac => \inst|inst1|inst30~q\,
	datad => \inst|inst1|inst33~q\,
	combout => \inst|inst|inst~0_combout\);

-- Location: LCCOMB_X40_Y23_N22
\inst|inst|inst\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst~combout\ = (\inst|inst|inst~1_combout\ & \inst|inst|inst~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst|inst~1_combout\,
	datad => \inst|inst|inst~0_combout\,
	combout => \inst|inst|inst~combout\);

-- Location: LCCOMB_X40_Y23_N0
\inst|inst1|inst28~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst1|inst28~0_combout\ = (!\inst|inst1|inst38|inst1~q\ & (!\inst|inst1|inst28~q\ & \inst|inst1|inst38|inst~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst38|inst1~q\,
	datac => \inst|inst1|inst28~q\,
	datad => \inst|inst1|inst38|inst~q\,
	combout => \inst|inst1|inst28~0_combout\);

-- Location: FF_X40_Y23_N1
\inst|inst1|inst28\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst1|inst28~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst1|inst28~q\);

-- Location: FF_X40_Y23_N23
\inst|inst|inst2\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst|inst~combout\,
	ena => \inst|inst1|inst28~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst|inst2~q\);

-- Location: LCCOMB_X39_Y23_N30
\inst|inst|inst5~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst5~0_combout\ = (!\inst|inst1|inst30~q\ & (!\inst|inst1|inst35~q\ & (!\inst|inst1|inst37~q\ & \inst|inst1|inst33~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst30~q\,
	datab => \inst|inst1|inst35~q\,
	datac => \inst|inst1|inst37~q\,
	datad => \inst|inst1|inst33~q\,
	combout => \inst|inst|inst5~0_combout\);

-- Location: LCCOMB_X39_Y23_N12
\inst|inst|inst5~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst5~1_combout\ = (!\inst|inst1|inst31~q\ & (!\inst|inst1|inst32~q\ & (\inst|inst1|inst34~q\ & \inst|inst1|inst36~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst1|inst31~q\,
	datab => \inst|inst1|inst32~q\,
	datac => \inst|inst1|inst34~q\,
	datad => \inst|inst1|inst36~q\,
	combout => \inst|inst|inst5~1_combout\);

-- Location: LCCOMB_X40_Y23_N16
\inst|inst|inst36~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst36~0_combout\ = (\inst|inst|inst5~0_combout\ & ((\inst|inst|inst5~1_combout\ & (!\inst|inst|inst2~q\)) # (!\inst|inst|inst5~1_combout\ & ((\inst|inst|inst36~q\))))) # (!\inst|inst|inst5~0_combout\ & (((\inst|inst|inst36~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|inst|inst2~q\,
	datab => \inst|inst|inst5~0_combout\,
	datac => \inst|inst|inst36~q\,
	datad => \inst|inst|inst5~1_combout\,
	combout => \inst|inst|inst36~0_combout\);

-- Location: FF_X40_Y23_N17
\inst|inst|inst36\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst|inst36~0_combout\,
	ena => \inst|inst1|inst28~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst|inst36~q\);

-- Location: LCCOMB_X40_Y23_N2
\inst|inst|inst35~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst35~0_combout\ = !\inst|inst|inst2~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst|inst2~q\,
	combout => \inst|inst|inst35~0_combout\);

-- Location: FF_X40_Y23_N3
\inst|inst|inst35\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst|inst35~0_combout\,
	ena => \inst|inst1|inst28~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst|inst35~q\);

-- Location: LCCOMB_X40_Y23_N20
\inst|inst|inst38~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst38~0_combout\ = !\inst|inst|inst2~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst|inst2~q\,
	combout => \inst|inst|inst38~0_combout\);

-- Location: FF_X40_Y23_N21
\inst|inst|inst38\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst|inst38~0_combout\,
	ena => \inst|inst1|inst28~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst|inst38~q\);

-- Location: LCCOMB_X40_Y23_N6
\inst|inst|inst37~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst37~0_combout\ = !\inst|inst|inst2~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst|inst2~q\,
	combout => \inst|inst|inst37~0_combout\);

-- Location: FF_X40_Y23_N7
\inst|inst|inst37\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst|inst37~0_combout\,
	ena => \inst|inst1|inst28~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst|inst37~q\);

-- Location: LCCOMB_X40_Y23_N12
\inst|inst|inst39~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|inst|inst39~0_combout\ = !\inst|inst|inst2~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|inst|inst2~q\,
	combout => \inst|inst|inst39~0_combout\);

-- Location: FF_X40_Y23_N13
\inst|inst|inst39\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK~inputclkctrl_outclk\,
	d => \inst|inst|inst39~0_combout\,
	ena => \inst|inst1|inst28~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|inst|inst39~q\);

ww_LED0 <= \LED0~output_o\;

ww_LED1 <= \LED1~output_o\;

ww_LED2 <= \LED2~output_o\;

ww_LED3 <= \LED3~output_o\;

ww_LED4 <= \LED4~output_o\;
END structure;


