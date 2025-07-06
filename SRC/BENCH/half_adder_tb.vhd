--*****************************************
--
-- Author: Daphne
--
-- File: half_adder_tb.vhd
--
-- Design units:
--	entity half_adder_tb
--		function: check the acurracy of the half adder component
--	architecture tb_arch:
--		component: half_adder
--			input: a_i, b_i
--			output: s_o, c_o
--		for statement implementation
--	configuration half_adder_tb_conf
--		function: specify entity & architecture
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic, natural, boolean
--	LIB_RTL.design_pack
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--
-- Revision history
--	version: 1.0
--	Date: 10/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;

entity half_adder_tb is
end half_adder_tb;

architecture tb_arch of half_adder_tb is
  component half_adder
    port(
      a_i, b_i: in std_logic;
      s_o, c_o: out std_logic);
  end component;

  type sample is record
    a_i, b_i, s_o, c_o: std_logic;
  end record;
  type sample_array is array (natural range <>) of sample;

  constant test_data: sample_array(3 downto 0) := (
    ('0', '0', '0', '0'),
    ('0', '1', '1', '0'),
    ('1', '0', '1', '0'),
    ('1', '1', '0', '1'));

  signal a_s, b_s, s_s, c_s: std_logic;
  signal test_ok: boolean := true;

begin

  process
    begin
      for i in test_data'range loop
        a_s <= test_data(i).a_i;
        b_s <= test_data(i).b_i;
        wait for 10 ns;

        if ((s_s /= test_data(i).s_o) or (c_s /= test_data(i).c_o)) then
          test_ok <= false;
        else
          test_ok <= true;
        end if;

        assert ((s_s = test_data(i).s_o) and (c_s = test_data(i).c_o))
        report "OUTPUT s_o OR c_o WRONG."
        severity error;
        
      end  loop;
    wait;
  end process;

  DUT: half_adder port map(a_s, b_s, s_s, c_s);

end architecture tb_arch;


configuration half_adder_tb_conf of half_adder_tb is
  for tb_arch
    for all: half_adder
      use entity lib_rtl.half_adder(half_adder_arch);
    end for;
  end for;
end configuration half_adder_tb_conf;
