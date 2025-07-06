--*****************************************
--
-- Author: Daphne
--
-- File: half_adder.vhd
--
-- Design units:
--	entity half_adder
--		input: a_i, b_i
--		output: s_o, c_o
--	architecture struct_arch:
--		component: signed_nbit_adder
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic
--	LIB_RTL.design_pack
--	
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: half_adder_tb
--
-- Revision history
--	version: 1.1
--	Date: 10/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;

entity half_adder is

	port (
		a_i, b_i : in std_logic;
		s_o, c_o : out std_logic);

end half_adder;

architecture half_adder_arch of half_adder is

begin

	s_o <= a_i xor b_i;
	c_o <= a_i and b_i;

end half_adder_arch;
