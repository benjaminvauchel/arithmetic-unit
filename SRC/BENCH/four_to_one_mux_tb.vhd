--*****************************************
--
-- Author: 
--
-- File: four_to_one_mux_tb.vhd
--
-- Design units:
--	entity four_to_one_mux_tb
--		function: check the acurracy of the 4-1 mux component
--	architecture tb_arch:
--		component: four_to_one_mux
--		input: in0_i, in1_i, in2_i, in3_i
--		output: sel_i, out_o
--		for statement implementation
--	configuration four_to_one_mux_tb_conf
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
--	version: 1.0
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;

library lib_rtl;

entity four_to_one_mux_tb is
    generic(nb_g : natural := 2);
end four_to_one_mux_tb;

architecture tb_arch of four_to_one_mux_tb is
  component four_to_one_mux
		generic(nb_g : natural := nb_g);
    port(
		in0_i, in1_i, in2_i, in3_i 	: in std_logic_vector(nb_g-1 downto 0);
		sel_i												: in std_logic_vector(1 downto 0);
		out_o												: out std_logic_vector(nb_g-1 downto 0));
  end component;

  type sample is record
    in0_i, in1_i, in2_i, in3_i : std_logic_vector(nb_g-1 downto 0);
		sel_i											 : std_logic_vector(1 downto 0);
		out_o											 : std_logic_vector(nb_g-1 downto 0);
  end record;
  type sample_array is array (natural range <>) of sample;

  constant test_data: sample_array(3 downto 0) := (
    ("00", "01", "10", "11", "00", "00"),
    ("00", "01", "10", "11", "01", "01"),
    ("00", "01", "10", "11", "10", "10"),
    ("00", "01", "10", "11", "11", "11"));

  --for all: four_to_one_mux use entity lib_rtl.four_to_one_mux;

  signal in0_s, in1_s, in2_s, in3_s, out_s: std_logic_vector(nb_g-1 downto 0);
	signal sel_s : std_logic_vector(1 downto 0);
  signal test_ok: boolean := true;

begin

  process
    begin
      for i in test_data'range loop
        in0_s <= test_data(i).in0_i;
        in1_s <= test_data(i).in1_i;
        in2_s <= test_data(i).in2_i;
        in3_s <= test_data(i).in3_i;
        sel_s <= test_data(i).sel_i;
        wait for 10 ns;

        if (out_s /= test_data(i).out_o) then
          test_ok <= false;
        else
          test_ok <= true;
        end if;

        assert (out_s = test_data(i).out_o)
        report "OUTPUT s_o OR c_o WRONG."
        severity error;
        
      end  loop;
    wait;
  end process;

  DUT: four_to_one_mux port map(in0_s, in1_s, in2_s, in3_s, sel_s, out_s);

end architecture tb_arch;


configuration four_to_one_mux_tb_conf of four_to_one_mux_tb is
  for tb_arch
    for all: four_to_one_mux
      use entity lib_rtl.four_to_one_mux(beh_arch)
			generic map (nb_g => nb_g);
    end for;
  end for;
end configuration four_to_one_mux_tb_conf;
