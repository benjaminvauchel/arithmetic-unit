--*****************************************
--
-- Author: Benjamin
--
-- File: my_shift_right.vhd
--
-- Design units:
--	entity my_shift_right
--		input: multiplicand, multiplier_int
--		output: S
--	architecture combinational_struct_arch:
--		component: single_shift_right
--	configuration my_shift_right_conf:
--		function: specifiy the relation between entity & architecture
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
--	Test bench: my_shift_right_tb
--
-- Revision history
--	version: 1.4
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;

entity my_shift_right is
	generic (
		nb_g : natural := 8);
	port(
			a_i			: in std_logic_vector(nb_g-1 downto 0);
			shift_i 	: in natural;
			s_o 		: out std_logic_vector(nb_g-1 downto 0)
		);
end entity my_shift_right;

architecture combinational_struct_arch of my_shift_right is

	component single_shift_right
		generic (
			nb_g : natural := 8);
		port(
			a_i :	in std_logic_vector(nb_g-1 downto 0);
			s_o : out std_logic_vector(nb_g-1 downto 0)
		);
	end component;

	type std_logic_vector_array is array (natural range <>) of std_logic_vector(nb_g-1 downto 0);

	signal rstmp_array : std_logic_vector_array(0 to nb_g);
	signal max_shift_s : natural;

begin

	max_shift_s <= shift_i when shift_i < nb_g else nb_g;
	rstmp_array(0) <= a_i;
	s_o <= rstmp_array(max_shift_s);

	shift_gen: for i in 0 to nb_g-1 generate
		single_shift_right_i: single_shift_right
		generic map (
			nb_g => nb_g
		)
		port map (
			a_i => rstmp_array(i),
			s_o => rstmp_array(i+1)
		);
	end generate;

end architecture combinational_struct_arch;

configuration my_shift_right_conf of my_shift_right is
	for combinational_struct_arch
		for all: single_shift_right
			use entity LIB_RTL.single_shift_right(beh_arch)
			generic map (nb_g => nb_g);
		end for;
	end for;
end my_shift_right_conf;
