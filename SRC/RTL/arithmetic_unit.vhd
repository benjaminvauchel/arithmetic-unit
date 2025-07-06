--*****************************************
--
-- Author: Benjamin, Di
--
-- File: arithmetic_unit.vhd
--
-- Design units:
--	entity arithmetic_unit
--		input: A,B,C,D
--		output: P
--	architecture struct_arch:
--		component: signed_nbit_adder, multiplier, my_shift_right, multiplier, my_shift,right
--		
--	configuration arithmetic_unit_conf
--		function: specify entity & architecture
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
--	Test bench: arithmetic_unit_tb
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

entity arithmetic_unit is
	generic (
		nb_g : natural := 8);
	port(
			A,B : in std_logic_vector(nb_g-1 downto 0);
			C : in natural;
			D : in std_logic_vector(nb_g*2-1 downto 0);
			P : out std_logic_vector(nb_g*2 downto 0)
		);
end entity arithmetic_unit;

architecture struct_arch of arithmetic_unit is

	component signed_nbit_adder
		generic (
			nb_g : natural := nb_g*2);
		port (
			a_i, b_i : in std_logic_vector(nb_g-1 downto 0);
			s_o      : out std_logic_vector(nb_g downto 0));
	end component;

	component multiplier
		generic (
			nb_g : natural := nb_g);
		port(
				multiplicand : in std_logic_vector(nb_g-1 downto 0);
				multiplier_int : in std_logic_vector(nb_g-1 downto 0);
				S : out std_logic_vector(nb_g+nb_g-1 downto 0)
		);
	end component;

	component my_shift_right
	generic (
		nb_g : natural := nb_g*2);
	port(
			a_i			:	in std_logic_vector(nb_g-1 downto 0);
			shift_i : in natural;
			s_o 		: out std_logic_vector(nb_g-1 downto 0)
		);
	end component;

	signal AB_s, AB2C_s : std_logic_vector(nb_g*2-1 downto 0);

begin

	multiplier1: multiplier
		port map(
			multiplicand => A,
			multiplier_int => B,
			S => AB_s
		);

	divider1: my_shift_right
		port map(
			a_i => AB_s,
			shift_i => C,
			s_o => AB2C_s
		);

	adder1: signed_nbit_adder
		port map(
			a_i => AB2C_s,
			b_i => D,
			s_o => P
		);

end architecture struct_arch;

configuration arithmetic_unit_conf of arithmetic_unit is
	for struct_arch
		for all: multiplier
			use entity LIB_RTL.multiplier(booth_arch)
			generic map (nb_g => nb_g);
		end for;
		for all: signed_nbit_adder
			use entity LIB_RTL.signed_nbit_adder(struct_arch)
			generic map (nb_g => nb_g);
		end for;
		for all: my_shift_right
			use entity LIB_RTL.my_shift_right(struct_arch)
			generic map (nb_g => nb_g);
		end for;
	end for;
end arithmetic_unit_conf;