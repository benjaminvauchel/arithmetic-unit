--*****************************************
--
-- Author: Benjamin
--
-- File: my_shift_right_tb.vhd
--
-- Design units:
--	entity my_shift_right_tb
--		function: check the acurracy of the shift right component
--	architecture tb_arch:
--		component: my_shift_right
--			input: a_i, shift_i
--			output: s_o
--		for statement implementation
--	configuration my_shift_right_tb_conf
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
--	version: 1.2
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;

library lib_rtl;

entity my_shift_right_tb is
    generic(nb_g : natural := 3);
end my_shift_right_tb;

architecture tb_arch of my_shift_right_tb is
	
	component my_shift_right
		generic (
			nb_g : natural := nb_g);
		port(
			a_i:				in std_logic_vector(nb_g-1 downto 0);
			shift_i : in natural;
			s_o : out std_logic_vector(nb_g-1 downto 0)
		);
	end component;

  type sample is record
    a_i 		: std_logic_vector(nb_g-1 downto 0);
    shift_i : natural;
    s_o 		: std_logic_vector(nb_g-1 downto 0);
  end record;
  type sample_array is array (natural range <>) of sample;

  constant test_data: sample_array(39 downto 0) := (
  ("000", 0, "000"), ("000", 1, "000"), ("000", 2, "000"), ("000", 3, "000"), ("000", 4, "000"),
	("001", 0, "001"), ("001", 1, "000"), ("001", 2, "000"), ("001", 3, "000"), ("001", 4, "000"),
	("010", 0, "010"), ("010", 1, "001"), ("010", 2, "000"), ("010", 3, "000"), ("010", 4, "000"),
	("011", 0, "011"), ("011", 1, "001"), ("011", 2, "000"), ("011", 3, "000"), ("011", 4, "000"),
	("100", 0, "100"), ("100", 1, "110"), ("100", 2, "111"), ("100", 3, "111"), ("100", 4, "111"),
	("101", 0, "101"), ("101", 1, "110"), ("101", 2, "111"), ("101", 3, "111"), ("101", 4, "111"),
	("110", 0, "110"), ("110", 1, "111"), ("110", 2, "111"), ("110", 3, "111"), ("110", 4, "111"),
	("111", 0, "111"), ("111", 1, "111"), ("111", 2, "111"), ("111", 3, "111"), ("111", 4, "111"));

  signal a_s, s_s	: std_logic_vector(nb_g-1 downto 0);
  signal shift_s	: natural;
  signal test_ok	: boolean := true;

begin

  process
    begin
      for i in test_data'range loop
        a_s <= test_data(i).a_i;
        shift_s <= test_data(i).shift_i;
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

  DUT: my_shift_right port map(a_s, shift_s, s_s);

end architecture tb_arch;


configuration my_shift_right_tb_conf of my_shift_right_tb is
  for tb_arch
    for all: my_shift_right
      use entity lib_rtl.my_shift_right(struct_arch);
    end for;
  end for;
end configuration my_shift_right_tb_conf;
