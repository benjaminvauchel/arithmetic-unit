--*****************************************
--
-- Author: Di
--
-- File: my_register.vhd
--
-- Design units:
--	entity my_register
--		input: clk, reset, en, d
--		output: q
--	architecture two_seg_arch:
--		component: single_shift_right
--		if statement implementation
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic, std_logic_vector, natural
--	LIB_RTL.design_pack
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: my_register_tb
--
-- Revision history
--	version: 1.1
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;

entity my_register is
	generic (
		nb_g : natural := 4);
	port (
		clk, reset, en : in std_logic;
		d							 : in std_logic_vector(nb_g-1 downto 0);
		q 						 : out std_logic_vector(nb_g-1 downto 0));
end my_register;

architecture two_seg_arch of my_register is

	signal q_reg, q_next : std_logic_vector(nb_g-1 downto 0);

begin

	process(clk, reset)
	begin
		if (reset = '0') then
			q_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			q_reg <= q_next;
		end if;
	end process;

	q_next <= d when en = '1' else
						q_reg;
	q			 <= q_reg;

end two_seg_arch;

