--*****************************************
--
-- Author: Daphne
--
-- File: full_adder_tb.vhd
--
-- Design units:
--	entity full_adder_tb
--		function: check the acurracy of the full adder
--	architecture tb_arch:
--		component: full_adder
--			input: a_i, b_i, cin_i
--			output: s_o, cout_o
--		for statement implementation
--	configuration full_adder_tb_conf
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
--	version: 1.1
--	Date: 10/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
library lib_rtl;


entity full_adder_tb is
end full_adder_tb;

architecture tb_arch of full_adder_tb is
  component full_adder
    port(
      a_i, b_i, cin_i  : in std_logic;
      s_o, cout_o      : out std_logic
    );
end component;

  type sample is record
    a_i, b_i, cin_i, s_o, cout_o: std_logic;
  end record;
  type sample_array is array (natural range <>) of sample;

  constant test_data: sample_array(7 downto 0) := (
    ('0', '0', '0', '0', '0'),
    ('0', '0', '1', '1', '0'),
    ('0', '1', '0', '1', '0'),
    ('0', '1', '1', '0', '1'),
    ('1', '0', '0', '1', '0'),
    ('1', '0', '1', '0', '1'),
    ('1', '1', '0', '0', '1'),
    ('1', '1', '1', '1', '1'));

  signal a_s, b_s, cin_s, s_s, cout_s: std_logic;
  signal test_ok: boolean := true;

begin

  DUT: full_adder port map(a_s, b_s, cin_s, s_s, cout_s);

  process
    begin
      for i in test_data'range loop
        a_s <= test_data(i).a_i;
        b_s <= test_data(i).b_i;
        cin_s <= test_data(i).cin_i;
        wait for 10 ns;

        if ((s_s /= test_data(i).s_o) or (cout_s /= test_data(i).cout_o)) then
          test_ok <= false;
        else
          test_ok <= true;
        end if;

        assert ((s_s = test_data(i).s_o) and (cout_s = test_data(i).cout_o))
        report "OUTPUT s_o OR cout_o WRONG."
        severity error;
        
      end  loop;
    wait;
  end process;


end architecture tb_arch;


configuration full_adder_tb_conf of full_adder_tb is
  for tb_arch
    for all: full_adder
      use entity lib_rtl.full_adder(full_adder_arch);
    end for;
  end for;
end configuration full_adder_tb_conf;
