--*****************************************
--
-- Author: Benjamin
--
-- File: get_opposite.vhd
--
-- Design units:
--	entity get_opposite
--		input: a_i, b_i, cin_i
--		output: s_o, cout_o
--	architecture struct_arch:
--		component: signed_nbit_adder
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic_vector
--	LIB_RTL.design_pack
--	
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: get_opposite_tb
--
-- Revision history
--	version: 1.3
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;

entity get_opposite is
	generic (
		nb_g : natural := 4);
	port (
		a_i : in std_logic_vector(nb_g-1 downto 0);
		s_o : out std_logic_vector(nb_g-1 downto 0));

end get_opposite;

architecture beh_arch of get_opposite is
	
	component signed_nbit_adder
    generic(nb_g : natural := nb_g);
    port(
      a_i, b_i : in std_logic_vector(nb_g-1 downto 0);
      s_o      : out std_logic_vector(nb_g downto 0));
	end component;

	signal adder_a_s, adder_b_s: std_logic_vector(nb_g-1 downto 0);
	signal adder_s_s: std_logic_vector(nb_g downto 0);
	signal ones_s: std_logic_vector(nb_g-1 downto 0) := (others => '1');

	begin
		
		adder_a_s <= a_i xor ones_s when a_i(nb_g-1) = '1' else a_i;
		adder_b_s <= (0 => '1', others => '0') when a_i(nb_g-1) = '1' else (others => '1');

		adder_0 : signed_nbit_adder
			port map (
				a_i => adder_a_s,
				b_i => adder_b_s,
				s_o => adder_s_s);

		s_o <= adder_s_s(nb_g-1 downto 0) when a_i(nb_g-1) = '1' else adder_s_s(nb_g-1 downto 0) xor ones_s;

end beh_arch;
