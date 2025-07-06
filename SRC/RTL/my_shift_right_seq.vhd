--*****************************************
--
-- Author: Benjamin
--
-- File: my_shift_right_seq.vhd
--
-- Design units:
--	entity my_shift_right_seq
--		input: clk, rst_n, a_i, shift_i, load_i
--		output: s_o, status_o
--	architecture seq_beh_arch:
--		sequential implementation using clock
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic_vector, natural
--	ieee.numeric_std
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: my_shift_right_seq_tb
--
-- Revision history
--	version: 2.0
--	Date: 11/2023
--	Comments: Sequential version - load triggers operation
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity my_shift_right_seq is
	generic (
		nb_g : natural := 8);
	port(
		clk : in std_logic;
		rst_n : in std_logic;
		a_i : in std_logic_vector(nb_g-1 downto 0);
		shift_i : in natural;
		load_i : in std_logic;
		s_o : out std_logic_vector(nb_g-1 downto 0);
		status_o : out std_logic
	);
end entity my_shift_right_seq;

architecture seq_beh_arch of my_shift_right_seq is

	type state_type is (IDLE, SHIFTING);
	signal state_reg, state_next : state_type;
	
	signal shift_reg, shift_next : std_logic_vector(nb_g-1 downto 0);
	signal counter_reg, counter_next : natural range 0 to nb_g;
	signal shift_amount_reg, shift_amount_next : natural range 0 to nb_g;
	signal load_reg, load_next : std_logic;

begin

	-- State and data registers
	process(clk, rst_n)
	begin
		if rst_n = '0' then
			state_reg <= IDLE;
			shift_reg <= (others => '0');
			counter_reg <= 0;
			shift_amount_reg <= 0;
			load_reg <= '0';
		elsif rising_edge(clk) then
			state_reg <= state_next;
			shift_reg <= shift_next;
			counter_reg <= counter_next;
			shift_amount_reg <= shift_amount_next;
			load_reg <= load_next;
		end if;
	end process;

	process(state_reg, shift_reg, counter_reg, shift_amount_reg, load_reg, a_i, shift_i, load_i)
	begin
		-- Default assignments
		state_next <= state_reg;
		shift_next <= shift_reg;
		counter_next <= counter_reg;
		shift_amount_next <= shift_amount_reg;
		load_next <= load_i;
		
		case state_reg is
			when IDLE =>
				if load_i = '1' and load_reg = '0' then -- Rising edge detection
					-- Always go to SHIFTING state, even for shift_i = 0
					state_next <= SHIFTING;
					shift_next <= a_i;
					counter_next <= 0;
					-- Limit shift amount to maximum possible
					if shift_i < nb_g then
						shift_amount_next <= shift_i;
					else
						shift_amount_next <= nb_g;
					end if;
				end if;
				
			when SHIFTING =>
				if counter_reg < shift_amount_reg then
					-- Perform one bit arithmetic shift right (preserve sign bit)
					shift_next <= shift_reg(nb_g-1) & shift_reg(nb_g-1 downto 1);
					counter_next <= counter_reg + 1;
				else
					-- Shifting complete, go back to IDLE
					state_next <= IDLE;
				end if;
		end case;
	end process;

	-- Output assignments
	s_o <= shift_reg;
	
	-- Status is high when operation is complete (in SHIFTING state and done)
	status_o <= '1' when (state_reg = SHIFTING and counter_reg = shift_amount_reg) else '0';

end architecture seq_beh_arch;