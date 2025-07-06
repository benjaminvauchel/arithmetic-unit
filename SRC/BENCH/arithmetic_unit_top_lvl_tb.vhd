--*****************************************
--
-- Author: Benjamin
--
-- File: arithmetic_unit_top_lvl_tb.vhd
--
-- Design units:
--	entity arithmetic_unit_tb_top_lvl_tb
--		function: check the acurracy of the arithmetic unit top level
--	architecture tb_arch:
--		component: arithmetic_unit_top_lvl
--		input: A,B,C,D
--		output: P,status
--		for statement implementation
--	configuration arithmetic_unit_top_lvl_tb_conf
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

entity arithmetic_unit_top_lvl_tb is
    generic(nb_g : natural := 8);
end arithmetic_unit_top_lvl_tb;

architecture tb_arch of arithmetic_unit_top_lvl_tb is
  component arithmetic_unit_top_lvl
    generic(nb_g : natural := nb_g);
		port(
			clk, load, reset : in std_logic;
			A,B : in std_logic_vector(nb_g-1 downto 0);
			C : in natural;
			D : in std_logic_vector(nb_g*2-1 downto 0);
			P : out std_logic_vector(nb_g*2 downto 0);
			status : out std_logic
		);
	end component;

  type sample is record
    reset, load : std_logic;
		A,B : std_logic_vector(nb_g-1 downto 0);
		C : natural;
		D : std_logic_vector(nb_g*2-1 downto 0);
  end record;
  type sample_array is array (natural range <>) of sample;

  constant test_data: sample_array(7 downto 0) := (
('0', '0', "11011011", "10111001", 1, "0011011000110100"),
('0', '1', "11011011", "10111001", 1, "0011011000110100"),
('1', '0', "11011011", "10111001", 1, "0011011000110100"),
('1', '1', "11011011", "10111001", 1, "0011011000110100"),
('1', '1', "11011011", "10111001", 1, "0011011000110100"),
('1', '0', "11011011", "10111001", 1, "0011011000110100"),
('1', '1', "01100011", "11001010", 3, "1111111001011001"),
('1', '1', "01100011", "11001010", 3, "1111111001011001"));

  signal clk_s				 : std_logic := '0';
	signal reset_s, load_s, status_s : std_logic;
	signal A,B : std_logic_vector(nb_g-1 downto 0);
	signal C : natural;
	signal D : std_logic_vector(nb_g*2-1 downto 0);
	signal P : std_logic_vector(nb_g*2 downto 0);

begin

	clk_s <= not clk_s after 5 ns;

  process
    begin
      for i in test_data'range loop
				reset_s <= test_data(i).reset;
				load_s <= test_data(i).load;
        A <= test_data(i).A;
        B <= test_data(i).B;
				C <= test_data(i).C;
				D <= test_data(i).D;
        wait for 10 ns;
        
      end  loop;
    wait;
  end process;

  DUT: arithmetic_unit_top_lvl port map(clk_s, load_s, reset_s, A, B, C, D, P, status_s);

end architecture tb_arch;


configuration arithmetic_unit_top_lvl_tb_conf of arithmetic_unit_top_lvl_tb is
  for tb_arch
    for all: arithmetic_unit_top_lvl
      use entity lib_rtl.arithmetic_unit_top_lvl(struct_arch);
    end for;
  end for;
end configuration arithmetic_unit_top_lvl_tb_conf;

