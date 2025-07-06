--*****************************************
--
-- Author: 
--
-- File: signed_overflow_nbit_adder.vhd
--
-- Design units:
--	entity signed_overflow_nbit_adder
--		input: a_i, b_i
--		output: s_o, carry_o
--	architecture struct_arch:
--		component: full_adder
--	configuration signed_overflow_nbit_adder_conf:
--		function: specifiy the relation between entity & architecture
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic_vector, natural
--	LIB_RTL.design_pack
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: signed_overflow_nbit_adder_tb
--
-- Revision history
--	version: 1.2
--	Date: 10/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;

entity signed_overflow_nbit_adder is
	generic (
		nb_g : natural := 4);
	port (
		a_i, b_i : in std_logic_vector(nb_g-1 downto 0);
		s_o      : out std_logic_vector(nb_g-1 downto 0);
		carry_o: out std_logic);

end signed_overflow_nbit_adder;

architecture struct_arch of signed_overflow_nbit_adder is

	component full_adder
		port (
			a_i, b_i, cin_i		: in  std_logic;
			s_o, cout_o		: out std_logic);
	end component;

	signal carry_s : std_logic_vector(nb_g-1 downto 0);
	
	begin
		
		adder_0 : full_adder
			port map (
				a_i => a_i(0),
				b_i => b_i(0),
				cin_i => '0',
				s_o => s_o(0),
				cout_o => carry_s(0));
		G_adder : for i in 1 to nb_g-1 generate
			adder_i : full_adder
				port map (
					a_i     => a_i(i),
					b_i     => b_i(i),
					cin_i   => carry_s(i-1),
					s_o     => s_o(i),
					cout_o  => carry_s(i));
		end generate G_adder;

	carry_o <= carry_s(nb_g-1);

end struct_arch;
	
configuration signed_overflow_nbit_adder_conf of signed_overflow_nbit_adder is
	
	for struct_arch --architecture name
		for all : full_adder -- component name
			use configuration lib_rtl.full_adder_conf; --model choice
		end for;
		for G_adder
			for all : full_adder --component name
				use configuration lib_rtl.full_adder_conf; --model choice
			end for;
		end for;
	end for;

end signed_overflow_nbit_adder_conf;
