--*****************************************
--
-- Author: Benjamin
--
-- File: four_to_one_mux.vhd
--
-- Design units:
--	entity four_to_one_mux
--		input: in0_i, in1_i, in2_i, in3_i, sel_i
--		output: out_o
--	architecture beh_arch
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic_vector, natural
--	LIB_RTL.design_pack
--	ieee.numeric_std
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: four_to_one_mux_tb
--
-- Revision history
--	version: 1.2
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;

entity four_to_one_mux is
	generic(
		nb_g : natural := 4);
	port(
		in0_i, in1_i, in2_i, in3_i 	: in std_logic_vector(nb_g-1 downto 0);
		sel_i												: in std_logic_vector(1 downto 0);
		out_o												: out std_logic_vector(nb_g-1 downto 0)
	);

end four_to_one_mux;

architecture beh_arch of four_to_one_mux is

	begin
	
	with sel_i
	select out_o <= in0_i when "00", in1_i when "01", in2_i when "10", in3_i when others;
	
end beh_arch;
