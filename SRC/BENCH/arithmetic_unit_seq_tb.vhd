--*****************************************
--
-- Author: Benjamin
--
-- File: arithmetic_unit_seq_tb.vhd
--
-- Design units:
--	entity arithmetic_unit_seq_tb
--		function: check the accuracy of the sequential arithmetic unit
--	architecture tb_arch:
--		component: arithmetic_unit_seq
--		input: clk, reset, A, B, C, D, load
--		output: P, status
--		for statement implementation with clock and state machine handling
--	configuration arithmetic_unit_seq_tb_conf
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
--	Date: 12/2023
--	Comments: Sequential version testbench
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lib_rtl;

entity arithmetic_unit_seq_tb is
    generic(nb_g : natural := 2);
end arithmetic_unit_seq_tb;

architecture tb_arch of arithmetic_unit_seq_tb is
  component arithmetic_unit_seq
    generic(nb_g : natural := nb_g);
    port(
			clk, reset : in std_logic;
			A,B : in std_logic_vector(nb_g-1 downto 0);
			C : in natural;
			D : in std_logic_vector(nb_g*2-1 downto 0);
			load : in std_logic;
			P : out std_logic_vector(nb_g*2 downto 0);
			status : out std_logic
		);
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

	-- Clock and reset signals
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	
	-- Input signals
	signal A,B : std_logic_vector(nb_g-1 downto 0);
	signal C : natural;
	signal D : std_logic_vector(nb_g*2-1 downto 0);
	signal load : std_logic := '0';
	
	-- Output signals
	signal P : std_logic_vector(nb_g*2 downto 0);
	signal status : std_logic;
	
	-- Test control
	signal test_ok: boolean := true;
	signal test_done: boolean := false;
	signal timeout_done: boolean := false;
	
	-- Clock period
	constant CLK_PERIOD : time := 10 ns;

begin

	-- Clock generation
	clk_process: process
	begin
		while not (test_done or timeout_done) loop
			clk <= '0';
			wait for CLK_PERIOD/2;
			clk <= '1';
			wait for CLK_PERIOD/2;
		end loop;
		wait;
	end process;

	-- Test process
	test_process: process
	begin
		-- Initial reset
		reset <= '1';
		load <= '0';
		wait for CLK_PERIOD * 2;
		reset <= '0';
		wait for CLK_PERIOD;
		
		-- Test all combinations
		for i in test_data'range loop
			-- Set up inputs
			A <= test_data(i).A;
			B <= test_data(i).B;
			C <= test_data(i).C;
			D <= test_data(i).D;
			
			-- Debug output - show test details
			report "Test " & integer'image(i) & " starting" severity note;
			
			-- Trigger load (rising edge)
			load <= '0';
			wait for CLK_PERIOD;
			load <= '1';
			wait for CLK_PERIOD;
			load <= '0';
			
			-- Wait for computation to complete (status = '1')
			wait until status = '1' or timeout_done;
			
			-- Check result - wait longer to ensure stable output
			wait for CLK_PERIOD;
			
			-- Debug: show actual vs expected 
			report "Test " & integer'image(i) & " - A=" & integer'image(to_integer(signed(A))) & 
				   ", B=" & integer'image(to_integer(signed(B))) & 
				   ", C=" & integer'image(C) & 
				   ", D=" & integer'image(to_integer(signed(D))) severity note;
			report "Test " & integer'image(i) & " - Expected P=" & 
				   integer'image(to_integer(signed(test_data(i).P))) & 
				   ", Got P=" & integer'image(to_integer(signed(P))) severity note;
			
			if (P /= test_data(i).P) then
				test_ok <= false;
				report "Test " & integer'image(i) & " FAILED"
				severity error;
			else
				test_ok <= true;
				report "Test " & integer'image(i) & " PASSED"
				severity note;
			end if;

			assert (P = test_data(i).P)
			report "OUTPUT P WRONG for test " & integer'image(i)
			severity error;
			
			-- Wait for status to go low (return to IDLE)
			wait until status = '0' or timeout_done;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			
		end loop;
		
		report "All tests completed"
		severity note;
		
		test_done <= true;
		wait;
	end process;

	-- Timeout process to prevent infinite simulation
	timeout_process: process
	begin
		wait for 100 us; -- Adjust timeout as needed
		report "TIMEOUT: Test taking too long"
		severity failure;
		timeout_done <= true;
		wait;
	end process;

	-- Device Under Test instantiation
	DUT: arithmetic_unit_seq 
		generic map(nb_g => nb_g)
		port map(
			clk => clk,
			reset => reset,
			A => A,
			B => B,
			C => C,
			D => D,
			load => load,
			P => P,
			status => status
		);

end architecture tb_arch;

configuration arithmetic_unit_seq_tb_conf of arithmetic_unit_seq_tb is
  for tb_arch
    for all: arithmetic_unit_seq
      use entity lib_rtl.arithmetic_unit_seq(struct_arch);
    end for;
  end for;
end configuration arithmetic_unit_seq_tb_conf;