--*****************************************
--
-- Author: Benjamin
--
-- File: my_shift_right_seq_tb.vhd
--
-- Design units:
--	entity my_shift_right_seq_tb
--		function: check the accuracy of the sequential shift right component
--	architecture tb_arch:
--		component: my_shift_right_seq
--			input: clk, rst_n, a_i, shift_i, load_i
--			output: s_o, status_o
--		sequential test implementation with clock
--	configuration my_shift_right_seq_tb_conf
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
--	Comments: Sequential testbench for my_shift_right_seq (ARITHMETIC RIGHT SHIFT)
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lib_rtl;

entity my_shift_right_seq_tb is
    generic(nb_g : natural := 3);
end my_shift_right_seq_tb;

architecture tb_arch of my_shift_right_seq_tb is
	
	component my_shift_right_seq
		generic (
			nb_g : natural := nb_g);
		port(
			clk : in std_logic;
			rst_n : in std_logic;
			a_i : in std_logic_vector(nb_g-1 downto 0);
			shift_i : in natural;
			load_i : in std_logic;
			s_o : out std_logic_vector(nb_g-1 downto 0);
			status_o : out std_logic
		);
	end component;

  type sample is record
    a_i 		: std_logic_vector(nb_g-1 downto 0);
    shift_i : natural;
    s_o 		: std_logic_vector(nb_g-1 downto 0);
  end record;
  type sample_array is array (natural range <>) of sample;

  -- Test data for ARITHMETIC RIGHT SHIFT operations
  constant test_data: sample_array(39 downto 0) := (
  ("000", 0, "000"), ("000", 1, "000"), ("000", 2, "000"), ("000", 3, "000"), ("000", 4, "000"),
	("001", 0, "001"), ("001", 1, "000"), ("001", 2, "000"), ("001", 3, "000"), ("001", 4, "000"),
	("010", 0, "010"), ("010", 1, "001"), ("010", 2, "000"), ("010", 3, "000"), ("010", 4, "000"),
	("011", 0, "011"), ("011", 1, "001"), ("011", 2, "000"), ("011", 3, "000"), ("011", 4, "000"),
	("100", 0, "100"), ("100", 1, "110"), ("100", 2, "111"), ("100", 3, "111"), ("100", 4, "111"),
	("101", 0, "101"), ("101", 1, "110"), ("101", 2, "111"), ("101", 3, "111"), ("101", 4, "111"),
	("110", 0, "110"), ("110", 1, "111"), ("110", 2, "111"), ("110", 3, "111"), ("110", 4, "111"),
	("111", 0, "111"), ("111", 1, "111"), ("111", 2, "111"), ("111", 3, "111"), ("111", 4, "111"));

  signal clk_s : std_logic := '0';
  signal rst_n_s : std_logic := '0';
  
  -- Test signals
  signal a_s, s_s	: std_logic_vector(nb_g-1 downto 0);
  signal shift_s	: natural;
  signal load_s : std_logic := '0';
  signal status_s : std_logic;
  signal test_ok	: boolean := true;
  
  constant clk_period : time := 10 ns;

begin

  -- Clock generation
  clk_process: process
  begin
    clk_s <= '0';
    wait for clk_period/2;
    clk_s <= '1';
    wait for clk_period/2;
  end process;

  -- Test process
  test_process: process
    variable expected_cycles : natural;
  begin
    -- Reset sequence
    rst_n_s <= '0';
    load_s <= '0';
    wait for clk_period * 2;
    rst_n_s <= '1';
    wait for clk_period;
    
    -- Test each sample
    for i in test_data'range loop
      report "Testing case " & integer'image(i) & 
             ": a_i=" & integer'image(to_integer(unsigned(test_data(i).a_i))) &
             ", shift_i=" & integer'image(test_data(i).shift_i);
      
      -- Set inputs
      a_s <= test_data(i).a_i;
      shift_s <= test_data(i).shift_i;
      wait for clk_period;
      
      -- Assert load signal
      load_s <= '1';
      wait for clk_period;
      load_s <= '0';
      
      -- Wait for operation to complete
      -- Expected cycles: 1 for shift_i=0, shift_i+1 for shift_i>0
      if test_data(i).shift_i = 0 then
        expected_cycles := 1;
      else
        expected_cycles := test_data(i).shift_i + 1;
      end if;
      
      -- Wait for the expected number of clock cycles
      for j in 1 to expected_cycles loop
        wait until rising_edge(clk_s);
      end loop;
      
      wait for clk_period/4;
      
      -- Check result
      if (s_s /= test_data(i).s_o) then
        test_ok <= false;
        report "Test case " & integer'image(i) & " FAILED: " &
               "Expected " & integer'image(to_integer(unsigned(test_data(i).s_o))) &
               ", Got " & integer'image(to_integer(unsigned(s_s)))
        severity error;
      else
        test_ok <= true;
        report "Test case " & integer'image(i) & " PASSED"
        severity note;
      end if;
      
      assert (s_s = test_data(i).s_o)
      report "OUTPUT s_o WRONG for test case " & integer'image(i)
      severity error;
      
      wait for clk_period;
      
    end loop;
    
    -- Test reset during operation
    report "Testing reset during operation...";
    a_s <= "101";
    shift_s <= 2;
    wait for clk_period;
    
    load_s <= '1';
    wait for clk_period;
    load_s <= '0';
    wait for clk_period;
    
    -- Reset during shift operation
    rst_n_s <= '0';
    wait for clk_period;
    rst_n_s <= '1';
    wait for clk_period;
    
    assert (s_s = (s_s'range => '0'))
    report "Reset test FAILED: Output not reset to zero"
    severity error;
    
    report "All tests completed" severity note;
    wait;
  end process;

  DUT: my_shift_right_seq 
    generic map (nb_g => nb_g)
    port map(
      clk => clk_s,
      rst_n => rst_n_s,
      a_i => a_s,
      shift_i => shift_s,
      load_i => load_s,
      s_o => s_s,
      status_o => status_s
    );

end architecture tb_arch;

configuration my_shift_right_seq_tb_conf of my_shift_right_seq_tb is
  for tb_arch
    for all: my_shift_right_seq
      use entity lib_rtl.my_shift_right_seq(seq_beh_arch);
    end for;
  end for;
end configuration my_shift_right_seq_tb_conf;