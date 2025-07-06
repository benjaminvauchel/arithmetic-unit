--*****************************************
--
-- Author: Benjamin
--
-- File: multiplier_tb.vhd
--
-- Design units:
--	entity multiplier_tb
--		function: check the acurracy of the multiplier component
--	architecture tb_arch:
--		component: multiplier
--			input: multiplicand, multiplier_int
--			output: S
--		for statement implementation
--	configuration multiplier_tb_conf
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
--	version: 1.2
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;

library lib_rtl;

entity multiplier_tb is
    generic(nb_g : natural := 3);
end multiplier_tb;

architecture tb_arch of multiplier_tb is
  component multiplier
    generic(nb_g : natural := 3);
    port(
			multiplicand : in std_logic_vector(nb_g-1 downto 0);
			multiplier_int : in std_logic_vector(nb_g-1 downto 0);
			S : out std_logic_vector(nb_g+nb_g-1 downto 0)
		);
	end component;

  type sample is record
    multiplicand : std_logic_vector(nb_g-1 downto 0);
    multiplier_int : std_logic_vector(nb_g-1 downto 0);
    S : std_logic_vector(2*nb_g-1 downto 0);
  end record;
  type sample_array is array (natural range <>) of sample;

--  constant test_data: sample_array(2 downto 0) := (("00011", "11100", "1111110100"), ("00000", "00000", "0000000000"), ("11000", "00110", "1111010000"));
--	constant test_data: sample_array(2 downto 0) := (("000000", "000000", "000000000000"), ("010111", "110111", "111100110001"), ("000000", "000000", "000000000000"));
--	constant test_data: sample_array(2 downto 0) := (("0011", "1100", "11110100"), ("0000", "0000", "00000000"), ("1000", "0110", "11010000"));
	constant test_data: sample_array(63 downto 0) := (("000", "000", "000000"), ("000", "001", "000000"), ("000", "010", "000000"), ("000", "011", "000000"), ("000", "100", "000000"), ("000", "101", "000000"), ("000", "110", "000000"), ("000", "111", "000000"),
("001", "000", "000000"), ("001", "001", "000001"), ("001", "010", "000010"), ("001", "011", "000011"), ("001", "100", "111100"), ("001", "101", "111101"), ("001", "110", "111110"), ("001", "111", "111111"),
("010", "000", "000000"), ("010", "001", "000010"), ("010", "010", "000100"), ("010", "011", "000110"), ("010", "100", "111000"), ("010", "101", "111010"), ("010", "110", "111100"), ("010", "111", "111110"),
("011", "000", "000000"), ("011", "001", "000011"), ("011", "010", "000110"), ("011", "011", "001001"), ("011", "100", "110100"), ("011", "101", "110111"), ("011", "110", "111010"), ("011", "111", "111101"),
("100", "000", "000000"), ("100", "001", "111100"), ("100", "010", "111000"), ("100", "011", "110100"), ("100", "100", "010000"), ("100", "101", "001100"), ("100", "110", "001000"), ("100", "111", "000100"),
("101", "000", "000000"), ("101", "001", "111101"), ("101", "010", "111010"), ("101", "011", "110111"), ("101", "100", "001100"), ("101", "101", "001001"), ("101", "110", "000110"), ("101", "111", "000011"), 
("110", "000", "000000"), ("110", "001", "111110"), ("110", "010", "111100"), ("110", "011", "111010"), ("110", "100", "001000"), ("110", "101", "000110"), ("110", "110", "000100"), ("110", "111", "000010"),
("111", "000", "000000"), ("111", "001", "111111"), ("111", "010", "111110"), ("111", "011", "111101"), ("111", "100", "000100"), ("111", "101", "000011"), ("111", "110", "000010"), ("111", "111", "000001"));

  signal multiplicand_s, multiplier_int_s: std_logic_vector(nb_g-1 downto 0);
  signal S_s: std_logic_vector(nb_g+nb_g-1 downto 0);
  signal test_ok: boolean := true;

begin

  process
    begin
      for i in test_data'range loop
        multiplicand_s <= test_data(i).multiplicand;
        multiplier_int_s <= test_data(i).multiplier_int;
        wait for 5 ns;

        if (S_s /= test_data(i).S) then
          test_ok <= false;
        else
          test_ok <= true;
        end if;

        assert (S_s = test_data(i).S)
        report "OUTPUT s_o WRONG."
        severity error;
        
      end  loop;
    wait;
  end process;

  DUT: multiplier port map(multiplicand_s, multiplier_int_s, S_s);

end architecture tb_arch;


configuration multiplier_tb_conf of multiplier_tb is
  for tb_arch
    for all: multiplier
      use entity lib_rtl.multiplier(booth_arch);
    end for;
  end for;
end configuration multiplier_tb_conf;
