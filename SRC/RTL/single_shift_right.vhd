--*****************************************
--
-- Author: 
--
-- File: single_shift_right.vhd
--
-- Design units:
--	entity single_shift_right
--		input: a_i
--		output: s_o
--	architecture beh_arch:
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic_vector, natural
--	ieee.numeric_std
--	LIB_RTL.design_pack
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: single_shift_right_tb
--
-- Revision history
--	version: 1.1
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;

entity single_shift_right is
	generic (
		nb_g : natural := 8);
	port(
			a_i:				in std_logic_vector(nb_g-1 downto 0);
			s_o : out std_logic_vector(nb_g-1 downto 0)
		);
end entity single_shift_right;

architecture beh_arch of single_shift_right is

begin

	s_o <= a_i(nb_g-1) & a_i(nb_g-1 downto 1);

end architecture beh_arch;
