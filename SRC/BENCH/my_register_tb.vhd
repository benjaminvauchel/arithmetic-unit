--*****************************************
--
-- Author: Di
--
-- File: my_register_tb.vhd
--
-- Design units:
--	entity my_register_tb
--		function: check the acurracy of the my_register component
--	architecture tb_arch:
--		component: my_register
--			input: clk, reset, en, d
--			output: q
--		for statement implementation
--	configuration my_register_tb_conf
--		function: specify entity & architecture
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic, std_logic_vector, natural, boolean
--	LIB_RTL.design_pack
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--
-- Revision history
--	version: 1.3
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;

library lib_rtl;

entity my_register_tb is
    generic(nb_g : natural := 3);
end my_register_tb;

architecture tb_arch of my_register_tb is
  component my_register
   	generic (
			nb_g : natural := nb_g);
		port (
			clk, reset, en : in std_logic;
			d							 : in std_logic_vector(nb_g-1 downto 0);
			q 						 : out std_logic_vector(nb_g-1 downto 0));
	end component;

  type sample is record
    reset, en : std_logic;
    d				  : std_logic_vector(nb_g-1 downto 0);
  end record;
  type sample_array is array (natural range <>) of sample;

  constant test_data: sample_array(3 downto 0) := (('0', '0', "101"), ('0', '1', "101"), ('1', '0', "101"), ('1', '1', "101"));

  signal clk_s				 : std_logic := '0';
	signal reset_s, en_s : std_logic;
  signal d_s, q_s			 : std_logic_vector(nb_g-1 downto 0);

begin

	clk_s <= not clk_s after 5 ns;

  process
    begin
      for i in test_data'range loop
        reset_s <= test_data(i).reset;
        en_s <= test_data(i).en;
				d_s <= test_data(i).d;
        wait for 20 ns;
        
      end  loop;
    wait;
  end process;

  DUT: my_register port map(clk_s, reset_s, en_s, d_s, q_s);

end architecture tb_arch;


configuration my_register_tb_conf of my_register_tb is
  for tb_arch
    for all: my_register
      use entity lib_rtl.my_register(two_seg_arch);
    end for;
  end for;
end configuration my_register_tb_conf;
