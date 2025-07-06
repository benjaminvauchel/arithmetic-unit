--*****************************************
--
-- Author: Daphne
--
-- File: full_adder.vhd
--
-- Design units:
--	entity full_adder
--		input: a_i, b_i, cin_i
--		output: s_o, cout_o
--	architecture struct_arch:
--		component: half_adder
--		
--	configuration full_adder_conf
--		function: specify entity & architecture
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic
--	LIB_RTL.design_pack
--	
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: full_adder_tb
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

entity full_adder is

	port(
		a_i, b_i, cin_i  : in std_logic;
		s_o, cout_o      : out std_logic
	);

end full_adder;

architecture struct_arch of full_adder is

	-- component declaration
	component half_adder
		port (
			a_i, b_i	: in std_logic;
			s_o, c_o	: out std_logic);
	end component;

	
	-- signal declarations
	signal n1_s, n2_s, n3_s : std_logic;
	
	begin -- structural description
		
		-- component instanciations
		half1 : half_adder port map (
			a_i => cin_i,
			b_i => a_i,
			s_o => n2_s,
			c_o => n1_s);
		
		half2 : half_adder port map (
			a_i => n2_s,
			b_i => b_i,
			s_o => s_o,
			c_o => n3_s);
			
		cout_o <= n1_s or n3_s;
	
end struct_arch;
	
configuration full_adder_conf of full_adder is
	for struct_arch --architecture name
		for all : half_adder -- component name
			use entity lib_rtl.half_adder(half_adder_arch); --model choice
		end for;
	end for;

end full_adder_conf;
