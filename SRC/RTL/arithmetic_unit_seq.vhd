--*****************************************
--
-- Author: Benjamin
--
-- File: arithmetic_unit_seq.vhd
--
-- Design units:
--	entity arithmetic_unit_seq
--		input: A,B,C,D
--		output: P
--	architecture struct_arch:
--		component: signed_nbit_adder, multiplier, my_shift_right, multiplier, my_shift,right
--		
--	configuration arithmetic_unit_seq_conf
--		function: specify entity & architecture
--
-- Library
-- 	ieee.std_logic_1164: to use std_logic_vector, natural
--	LIB_RTL.design_pack
--	ieee.numeric_std
--
-- Synthesis and verification:
-- 	Synthesis software: ModelSim SE-64 10.6d
-- 	Options/Script:..
--	Target technology: ..
--	Test bench: arithmetic_unit_seq_tb
--
-- Revision history
--	version: 1.1
--	Date: 11/2023
--	Comments: Original
--
--******************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_RTL;

entity arithmetic_unit_seq is
	generic (
		nb_g : natural := 8);
	port(
			clk, reset : in std_logic;
			A,B : in std_logic_vector(nb_g-1 downto 0);
			C : in natural;
			D : in std_logic_vector(nb_g*2-1 downto 0);
			load : in std_logic;
			P : out std_logic_vector(nb_g*2 downto 0);
			status : out std_logic
		);
end entity arithmetic_unit_seq;

architecture struct_arch of arithmetic_unit_seq is

	component signed_nbit_adder
		generic (
			nb_g : natural := nb_g*2);
		port (
			a_i, b_i : in std_logic_vector(nb_g-1 downto 0);
			s_o      : out std_logic_vector(nb_g downto 0));
	end component;

	component multiplier
		generic (
			nb_g : natural := nb_g);
		port(
				multiplicand : in std_logic_vector(nb_g-1 downto 0);
				multiplier_int : in std_logic_vector(nb_g-1 downto 0);
				S : out std_logic_vector(nb_g+nb_g-1 downto 0)
		);
	end component;

	component my_shift_right_seq
	generic (
		nb_g : natural := nb_g*2);
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

	type state_type is (IDLE, MULT_DONE, SHIFT_ACTIVE, COMPUTING);
	signal state_reg, state_next : state_type;
	
	signal AB_s, AB2C_s : std_logic_vector(nb_g*2-1 downto 0);
	signal shift_load, shift_status : std_logic;
	signal rst_n : std_logic;
	signal load_reg, load_next : std_logic;

begin

	rst_n <= not reset;

	-- State machine process
	process(clk, reset)
	begin
		if reset = '1' then
			state_reg <= IDLE;
			load_reg <= '0';
		elsif rising_edge(clk) then
			state_reg <= state_next;
			load_reg <= load_next;
		end if;
	end process;

	-- Next state logic
	process(state_reg, load, load_reg, shift_status)
	begin
		state_next <= state_reg;
		load_next <= load;
		shift_load <= '0';
		status <= '0';
		
		case state_reg is
			when IDLE =>
				if load = '1' and load_reg = '0' then  -- Rising edge of load
					state_next <= MULT_DONE;
				end if;
				
			when MULT_DONE =>
				shift_load <= '1';  -- Start shift operation
				state_next <= SHIFT_ACTIVE;
				
			when SHIFT_ACTIVE =>
				if shift_status = '1' then  -- Shift completed
					state_next <= COMPUTING;
				end if;
				
			when COMPUTING =>
				status <= '1';  -- Computation complete
				state_next <= IDLE;
		end case;
	end process;

	-- Data path components
	multiplier1: multiplier
		generic map (nb_g)
		port map(
			multiplicand => A,
			multiplier_int => B,
			S => AB_s
		);

	divider1: my_shift_right_seq
		generic map (nb_g*2)
		port map(
			clk => clk,
			rst_n => rst_n,
			a_i => AB_s,
			shift_i => C,
			load_i => shift_load,
			s_o => AB2C_s,
			status_o => shift_status
		);

	adder1: signed_nbit_adder
		generic map (nb_g*2)
		port map(
			a_i => AB2C_s,
			b_i => D,
			s_o => P
		);

end architecture struct_arch;

configuration arithmetic_unit_seq_conf of arithmetic_unit_seq is
	for struct_arch
		for all: multiplier
			use entity LIB_RTL.multiplier(booth_arch)
			generic map (nb_g => nb_g);
		end for;
		for all: signed_nbit_adder
			use entity LIB_RTL.signed_nbit_adder(struct_arch)
			generic map (nb_g => nb_g);
		end for;
		for all: my_shift_right_seq
			use entity LIB_RTL.my_shift_right_seq(seq_beh_arch)
			generic map (nb_g => nb_g);
		end for;
	end for;
end arithmetic_unit_seq_conf;