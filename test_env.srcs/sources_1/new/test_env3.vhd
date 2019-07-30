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
-- TEST ENVIRONMENT FOR ROM
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
component mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           enable : out STD_LOGIC_VECTOR(4 downto 0));
end component;
component ssd is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;
component ram_mem is
    Port ( clk : in std_logic;
           we : in std_logic;
           addr : in std_logic_vector(3 downto 0);
           di : in std_logic_vector(15 downto 0);
           do : out std_logic_vector(15 downto 0));
end component;
signal enable : std_logic_vector(4 downto 0);
signal cathode : std_logic_vector(6 downto 0);
signal anode : std_logic_vector(3 downto 0);
----------RAM-----------
signal counter : std_logic_vector(3 downto 0);
signal wenable : std_logic;
signal result, rd_1 : std_logic_vector(15 downto 0);
--------------------------------
begin
G2: mpg port map(clk, btn, enable);
G4: ssd port map(clk, result, cathode, anode); -- ssd  port map
G6: ram_mem port map(clk, wenable, counter, result, rd_1);  -- ram port map
wenable <= enable(1);
p1_reg: process(clk, btn)
begin
    if rising_edge(clk) then
        if enable = "00001" then -- centre button for the counter
            counter <= counter + 1;
        elsif enable = "00100"then -- west button for reset
            counter <= x"0";
        end if;
        an <= anode;
        cat <= cathode;
    end if;
    result <= rd_1(13 downto 0) & "00";
end process p1_reg;
end Behavioral;
