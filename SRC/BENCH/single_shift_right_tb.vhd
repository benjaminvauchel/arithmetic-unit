--*****************************************
--
-- Author: Benjamin
--
-- File: single_shift_right_tb.vhd
--
-- Design units:
--	entity single_shift_right_tb
--		function: check the acurracy of the single bit right shift component
--	architecture tb_arch:
--		component: single_shift_right
--			input: a_i
--			output: s_o
--		for statement implementation
--	configuration single_shift_right_tb_conf
--		function: specify entity & architecture
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic_vector, natural, boolean
--	LIB_RTL.design_pack
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
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

entity single_shift_right_tb is
    generic(nb_g : natural := 3);
end single_shift_right_tb;

architecture tb_arch of single_shift_right_tb is
	
	component single_shift_right
		generic (
			nb_g : natural := nb_g);
		port(
			a_i :	in std_logic_vector(nb_g-1 downto 0);
			s_o : out std_logic_vector(nb_g-1 downto 0)
		);
	end component;

  type sample is record
    a_i 		: std_logic_vector(nb_g-1 downto 0);
    s_o 		: std_logic_vector(nb_g-1 downto 0);
  end record;
  type sample_array is array (natural range <>) of sample;

  constant test_data: sample_array(7 downto 0) := (
  ("000", "000"),
	("001", "000"),
	("010", "001"),
	("011", "001"),
	("100", "110"),
	("101", "110"),
	("110", "111"),
	("111", "111"));

  signal a_s, s_s	: std_logic_vector(nb_g-1 downto 0);
  signal test_ok	: boolean := true;

begin

  process
    begin
      for i in test_data'range loop
        a_s <= test_data(i).a_i;
        wait for 10 ns;

        if (s_s /= test_data(i).s_o) then
          test_ok <= false;
        else
          test_ok <= true;
        end if;

        assert (s_s = test_data(i).s_o)
        report "OUTPUT s_o WRONG."
        severity error;
        
      end  loop;
    wait;
  end process;

  DUT: single_shift_right port map(a_s, s_s);

end architecture tb_arch;


configuration single_shift_right_tb_conf of single_shift_right_tb is
  for tb_arch
    for all: single_shift_right
      use entity lib_rtl.single_shift_right(beh_arch);
    end for;
  end for;
end configuration single_shift_right_tb_conf;

