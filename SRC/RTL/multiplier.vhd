--*****************************************
--
-- Author: Benjamin
--
-- File: multiplier.vhd
--
-- Design units:
--	entity multiplier
--		input: multiplicand, multiplier_int
--		output: S
--	architecture booth_arch:
--		component: signed_overflow_nbit_adder, get_opposite, four_to_one_mux
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
--	Test bench: multiplier_tb
--
-- Revision history
--	version: 1.3
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;

entity multiplier is
	generic (
		nb_g : natural := 8);
	port(
			multiplicand : in std_logic_vector(nb_g-1 downto 0);
			multiplier_int : in std_logic_vector(nb_g-1 downto 0);
			S : out std_logic_vector(nb_g+nb_g-1 downto 0)
		);
end entity multiplier;

architecture booth_arch of multiplier is

	component signed_overflow_nbit_adder
		generic (
			nb_g : natural := nb_g*2+2);
		port (
			a_i, b_i : in std_logic_vector(nb_g-1 downto 0);
			s_o      : out std_logic_vector(nb_g-1 downto 0));
			-- ignore carry_o
	end component;

	component get_opposite
		generic (
			nb_g : natural := nb_g);
		port (
			a_i : in std_logic_vector(nb_g-1 downto 0);
			s_o : out std_logic_vector(nb_g-1 downto 0));
	end component;

	component four_to_one_mux
		generic (
			nb_g : natural := nb_g*2+2);
		port (
			in0_i, in1_i, in2_i, in3_i : in std_logic_vector(nb_g-1 downto 0);
			sel_i : in std_logic_vector(1 downto 0);
			out_o: out std_logic_vector(nb_g-1 downto 0));
	end component;
	
	component single_shift_right
		generic (
			nb_g : natural := 2*nb_g+2);
		port (
			a_i : in std_logic_vector(nb_g-1 downto 0);
			s_o : out std_logic_vector(nb_g-1 downto 0)
		);
	end component;

	signal op_multiplicand_s: std_logic_vector(nb_g-1 downto 0);
	signal A_s, S_s, P_s: std_logic_vector(nb_g*2+1 downto 0);

	type std_logic_vector_array is array(0 to nb_g-1) of std_logic_vector(nb_g*2+1 downto 0);
	signal zeros_nb_g: std_logic_vector(nb_g-1 downto 0);
	signal temp_a_s, temp_b_s, temp_P_s: std_logic_vector_array;

begin
	zeros_nb_g <= (others => '0');

  get_op_0: get_opposite
	port map(
		a_i => multiplicand,
		s_o => op_multiplicand_s
	);

	A_s <= multiplicand(nb_g-1) & multiplicand & zeros_nb_g & '0';
	S_s <= '0' & op_multiplicand_s & zeros_nb_g & '0' when ((multiplicand(nb_g-1) = '1') or (multiplicand = zeros_nb_g)) else
		   '1' & op_multiplicand_s & zeros_nb_g & '0';
	P_s <= '0' & zeros_nb_g & multiplier_int & '0';
	temp_a_s(0) <= P_s;

	mux_0 : four_to_one_mux
		port map (
			in0_i => (others => '0'),
			in1_i => A_s,
			in2_i => S_s,
			in3_i => (others => '0'),
			sel_i => temp_a_s(0)(1 downto 0),
			out_o => temp_b_s(0));
	adder_0 : signed_overflow_nbit_adder
		port map (
			a_i => temp_a_s(0),
			b_i => temp_b_s(0),
			s_o => temp_P_s(0)
		);

	G_adder_and_mux : for i in 1 to nb_g-1 generate
		mux_i : four_to_one_mux
			port map (
				in0_i => (others => '0'),
				in1_i => A_s,
				in2_i => S_s,
				in3_i => (others => '0'),
				sel_i => temp_a_s(i)(1 downto 0),
				out_o => temp_b_s(i));
		adder_i : signed_overflow_nbit_adder
			port map (
				a_i => temp_a_s(i),
				b_i => temp_b_s(i),
				s_o => temp_P_s(i)
			);
		shift_right_i : single_shift_right
			port map (
				a_i => temp_P_s(i-1),
				s_o => temp_a_s(i)
			);
	end generate G_adder_and_mux;

S <= temp_P_s(nb_g-1)(nb_g*2+1 downto 2);


end architecture booth_arch;
