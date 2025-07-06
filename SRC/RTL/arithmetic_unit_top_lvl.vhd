--*****************************************
--
-- Author: Benjamin, Di
--
-- File: arithmetic_unit_top_lvl.vhd
--
-- Design units:
--	entity arithmetic_unit_top_lvl
--		input: A,B,C,D, clk, load, reset
--		output: P, status
--	architecture struct_arch:
--		component: arithmetic_unit, my_register
--		
--	configuration arithmetic_unit_top_lvl_conf
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
--	Test bench: arithmetic_unit_top_lvl_tb
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

entity arithmetic_unit_top_lvl is
	generic (
		nb_g : natural := 8);
	port(
			clk, load, reset : in std_logic;
			A,B : in std_logic_vector(nb_g-1 downto 0);
			C : in natural;
			D : in std_logic_vector(nb_g*2-1 downto 0);
			P : out std_logic_vector(nb_g*2 downto 0);
			status : out std_logic
		);
end entity arithmetic_unit_top_lvl;

architecture struct_arch of arithmetic_unit_top_lvl is

	component arithmetic_unit
	generic (
		nb_g : natural := nb_g);
	port(
			A,B : in std_logic_vector(nb_g-1 downto 0);
			C : in natural;
			D : in std_logic_vector(nb_g*2-1 downto 0);
			P : out std_logic_vector(nb_g*2 downto 0)
		);
	end component;

	component my_register
	generic (
		nb_g : natural := nb_g);
	port (
		clk, reset, en : in std_logic;
		d							 : in std_logic_vector(nb_g-1 downto 0);
		q 						 : out std_logic_vector(nb_g-1 downto 0));
	end component;

	signal A_u, B_u : std_logic_vector(nb_g-1 downto 0);
	signal Cvd, Cvq : std_logic_vector(nb_g-1 downto 0);
	signal C_u 		  : natural;
	signal D_u			: std_logic_vector(nb_g*2-1 downto 0);
	signal P_u			: std_logic_vector(nb_g*2 downto 0);
	signal status_u, status_tmp, status_s : std_logic_vector(0 downto 0);

begin

	Cvd <= std_logic_vector(to_unsigned(C, nb_g));
	C_u <= to_integer(unsigned(Cvq));
	status_u <= "1" when (reset = '1' and load = '1') else "0";
	status <= status_s(0);

	my_register_A : my_register
	generic map (nb_g)
	port map (clk, reset, load, A, A_u);

	my_register_B : my_register
	generic map (nb_g)
	port map (clk, reset, load, B, B_u);

	my_register_C : my_register
	generic map (nb_g)
	port map (clk, reset, load, Cvd, Cvq);

	my_register_D : my_register
	generic map (nb_g*2)
	port map (clk, reset, load, D, D_u);

	my_register_P : my_register
	generic map (nb_g*2+1)
	port map (clk, reset, load, P_u, P);

	my_register_status_tmp : my_register
	generic map (1)
	port map (clk, reset, load, status_u, status_tmp);

	my_register_status : my_register
	generic map (1)
	port map (clk, reset, load, status_tmp, status_s);

	arithmetic_unit0 : arithmetic_unit
	generic map (nb_g)
	port map (A_u, B_u, C_u, D_u, P_u);

end architecture struct_arch;
