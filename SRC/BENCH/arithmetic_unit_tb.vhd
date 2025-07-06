--*****************************************
--
-- Author: Benjamin
--
-- File: arithmetic_unit_tb.vhd
--
-- Design units:
--	entity arithmetic_unit_tb
--		function: check the acurracy of the arithmetic unit
--	architecture tb_arch:
--		component: arithmetic_unit
--		input: A,B,C,D
--		output: P
--		for statement implementation
--	configuration arithmetic_unit_tb_conf
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
--	version: 1.4
--	Date: 12/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;

library lib_rtl;

entity arithmetic_unit_tb is
    generic(nb_g : natural := 2);
end arithmetic_unit_tb;

architecture tb_arch of arithmetic_unit_tb is
  component arithmetic_unit
    generic(nb_g : natural := nb_g);
    port(
			A,B : in std_logic_vector(nb_g-1 downto 0);
			C : in natural;
			D : in std_logic_vector(nb_g*2-1 downto 0);
			P : out std_logic_vector(nb_g*2 downto 0));
	end component;

  type sample is record
			A,B : std_logic_vector(nb_g-1 downto 0);
			C : natural;
			D : std_logic_vector(nb_g*2-1 downto 0);
			P : std_logic_vector(nb_g*2 downto 0);
  end record;
  type sample_array is array (natural range <>) of sample;

  constant test_data: sample_array(95 downto 0) := (
("00", "00", 0, "0000", "00000"),
("00", "00", 0, "0001", "00001"),
("00", "00", 1, "0000", "00000"),
("00", "00", 1, "0001", "00001"),
("00", "00", 2, "0000", "00000"),
("00", "00", 2, "0001", "00001"),
("00", "01", 0, "0000", "00000"),
("00", "01", 0, "0001", "00001"),
("00", "01", 1, "0000", "00000"),
("00", "01", 1, "0001", "00001"),
("00", "01", 2, "0000", "00000"),
("00", "01", 2, "0001", "00001"),
("00", "10", 0, "0000", "00000"),
("00", "10", 0, "0001", "00001"),
("00", "10", 1, "0000", "00000"),
("00", "10", 1, "0001", "00001"),
("00", "10", 2, "0000", "00000"),
("00", "10", 2, "0001", "00001"),
("00", "11", 0, "0000", "00000"),
("00", "11", 0, "0001", "00001"),
("00", "11", 1, "0000", "00000"),
("00", "11", 1, "0001", "00001"),
("00", "11", 2, "0000", "00000"),
("00", "11", 2, "0001", "00001"),
("01", "00", 0, "0000", "00000"),
("01", "00", 0, "0001", "00001"),
("01", "00", 1, "0000", "00000"),
("01", "00", 1, "0001", "00001"),
("01", "00", 2, "0000", "00000"),
("01", "00", 2, "0001", "00001"),
("01", "01", 0, "0000", "00001"),
("01", "01", 0, "0001", "00010"),
("01", "01", 1, "0000", "00000"),
("01", "01", 1, "0001", "00001"),
("01", "01", 2, "0000", "00000"),
("01", "01", 2, "0001", "00001"),
("01", "10", 0, "0000", "11110"),
("01", "10", 0, "0001", "11111"),
("01", "10", 1, "0000", "11111"),
("01", "10", 1, "0001", "00000"),
("01", "10", 2, "0000", "11111"),
("01", "10", 2, "0001", "00000"),
("01", "11", 0, "0000", "11111"),
("01", "11", 0, "0001", "00000"),
("01", "11", 1, "0000", "11111"),
("01", "11", 1, "0001", "00000"),
("01", "11", 2, "0000", "11111"),
("01", "11", 2, "0001", "00000"),
("10", "00", 0, "0000", "00000"),
("10", "00", 0, "0001", "00001"),
("10", "00", 1, "0000", "00000"),
("10", "00", 1, "0001", "00001"),
("10", "00", 2, "0000", "00000"),
("10", "00", 2, "0001", "00001"),
("10", "01", 0, "0000", "11110"),
("10", "01", 0, "0001", "11111"),
("10", "01", 1, "0000", "11111"),
("10", "01", 1, "0001", "00000"),
("10", "01", 2, "0000", "11111"),
("10", "01", 2, "0001", "00000"),
("10", "10", 0, "0000", "00100"),
("10", "10", 0, "0001", "00101"),
("10", "10", 1, "0000", "00010"),
("10", "10", 1, "0001", "00011"),
("10", "10", 2, "0000", "00001"),
("10", "10", 2, "0001", "00010"),
("10", "11", 0, "0000", "00010"),
("10", "11", 0, "0001", "00011"),
("10", "11", 1, "0000", "00001"),
("10", "11", 1, "0001", "00010"),
("10", "11", 2, "0000", "00000"),
("10", "11", 2, "0001", "00001"),
("11", "00", 0, "0000", "00000"),
("11", "00", 0, "0001", "00001"),
("11", "00", 1, "0000", "00000"),
("11", "00", 1, "0001", "00001"),
("11", "00", 2, "0000", "00000"),
("11", "00", 2, "0001", "00001"),
("11", "01", 0, "0000", "11111"),
("11", "01", 0, "0001", "00000"),
("11", "01", 1, "0000", "11111"),
("11", "01", 1, "0001", "00000"),
("11", "01", 2, "0000", "11111"),
("11", "01", 2, "0001", "00000"),
("11", "10", 0, "0000", "00010"),
("11", "10", 0, "0001", "00011"),
("11", "10", 1, "0000", "00001"),
("11", "10", 1, "0001", "00010"),
("11", "10", 2, "0000", "00000"),
("11", "10", 2, "0001", "00001"),
("11", "11", 0, "0000", "00001"),
("11", "11", 0, "0001", "00010"),
("11", "11", 1, "0000", "00000"),
("11", "11", 1, "0001", "00001"),
("11", "11", 2, "0000", "00000"),
("11", "11", 2, "0001", "00001"));

	signal A,B : std_logic_vector(nb_g-1 downto 0);
	signal C : natural;
	signal D : std_logic_vector(nb_g*2-1 downto 0);
	signal P : std_logic_vector(nb_g*2 downto 0);
  signal test_ok: boolean := true;

begin

  process
    begin
      for i in test_data'range loop
        A <= test_data(i).A;
        B <= test_data(i).B;
				C <= test_data(i).C;
				D <= test_data(i).D;
        wait for 10 ns;

        if (P /= test_data(i).P) then
          test_ok <= false;
        else
          test_ok <= true;
        end if;

        assert (P = test_data(i).P)
        report "OUTPUT s_o WRONG."
        severity error;
        
      end  loop;
    wait;
  end process;

  DUT: arithmetic_unit port map(A, B, C, D, P);

end architecture tb_arch;


configuration arithmetic_unit_tb_conf of arithmetic_unit_tb is
  for tb_arch
    for all: arithmetic_unit
      use entity lib_rtl.arithmetic_unit(struct_arch);
    end for;
  end for;
end configuration arithmetic_unit_tb_conf;
