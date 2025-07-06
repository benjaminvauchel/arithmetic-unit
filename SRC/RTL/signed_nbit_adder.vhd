--*****************************************
--
-- Author: 
--
-- File: signed_nbit_adder.vhd
--
-- Design units:
--	entity signed_nbit_adder
--		input: a_i, b_i
--		output: s_o
--	architecture struct_arch:
--		component: full_adder
--	configuration signed_nbit_adder_conf:
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
--	Test bench: signed_nbit_adder_tb
--
-- Revision history
--	version: 1.3
--	Date: 10/2023
--	Comments: Original
--
--******************************************


library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;

entity signed_nbit_adder is
	generic (
		nb_g : natural := 4);
	port (
		a_i, b_i : in std_logic_vector(nb_g-1 downto 0);
		s_o      : out std_logic_vector(nb_g downto 0));

end signed_nbit_adder;

architecture struct_arch of signed_nbit_adder is
-- component declarations

	component full_adder
		port (
			a_i, b_i, cin_i		: in  std_logic;
			s_o, cout_o		: out std_logic);
	end component;
	
	-- signal declarations
	signal tmp_s : std_logic_vector(nb_g downto 0);
	signal a_s, b_s : std_logic_vector(nb_g downto 0);
	signal carry_s : std_logic_vector(nb_g downto 0);

	begin -- gener_arch
		
		a_s(nb_g-1 downto 0) <= a_i;
		b_s(nb_g-1 downto 0) <= b_i;
		a_s(nb_g) <= a_i(nb_g-1);
		b_s(nb_g) <= b_i(nb_g-1);

		adder_0 : full_adder
			port map (
				a_i => a_s(0),
				b_i => b_s(0),
				cin_i => '0',
				s_o => tmp_s(0),
				cout_o => carry_s(0));
		G_adder : for i in 1 to nb_g generate
			adder_i : full_adder
				port map (
					a_i     => a_s(i),
					b_i     => b_s(i),
					cin_i   => carry_s(i-1),
					s_o     => tmp_s(i),
					cout_o  => carry_s(i));
		end generate G_adder;

		s_o <= tmp_s;

end struct_arch;
	
configuration signed_nbit_adder_conf of signed_nbit_adder is
	
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

end signed_nbit_adder_conf;
