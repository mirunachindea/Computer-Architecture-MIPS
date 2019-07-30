----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2019 08:05:11 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- TEST ENVIRONMENT FOR INSTRUCTION FETCH UNIT
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
-- MPG COMPONENT
component mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           enable : out STD_LOGIC_VECTOR(4 downto 0));
end component;
-- IF COMPONENT
component instruction_fetch is
    Port ( clk : in STD_LOGIC;
           branch_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jmp_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jump : in STD_LOGIC;
           branch : in STD_LOGIC;
           en_btn: in std_logic;
           reset_btn: in std_logic;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pc_out: out std_logic_vector(15 downto 0));
end component;
-- SSD COMPONENT
component ssd is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal anode: std_logic_vector(3 downto 0);
signal cathode: std_logic_vector(6 downto 0);
signal enable_pc: std_logic_vector(4 downto 0);
signal result: std_logic_vector(15 downto 0):=x"0000";
signal pc: std_logic_vector(15 downto 0);
signal instruction: std_logic_vector(15 downto 0);
begin
G1: mpg port map(clk, btn, enable_pc);
G2: ssd port map(clk, result, cathode, anode);
G3: instruction_fetch port map(clk => clk, branch_addr => x"0005", jmp_addr => x"0000",jump => sw(0), branch => sw(1), en_btn => enable_pc(0), reset_btn => enable_pc(1), instruction => instruction, pc_out => pc);
process(clk,sw)
begin
    if rising_edge(clk) then
        if sw(7) = '0' then
            result <= instruction;
        elsif sw(7) = '1' then
            result <= pc;
        end if;
    end if;
end process;     
    an <= anode;
    cat <= cathode;
    led <= x"0000";
end Behavioral;
