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
-- TEST ENVIRONMENT FOR REGISTER FILE
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
component reg_file is
    Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (3 downto 0);
           ra2 : in STD_LOGIC_VECTOR (3 downto 0);
           wa : in STD_LOGIC_VECTOR (3 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal enable : std_logic_vector(4 downto 0);
signal cathode : std_logic_vector(6 downto 0);
signal anode : std_logic_vector(3 downto 0);

----------REG-----------
signal counter : std_logic_vector(3 downto 0);
signal wenable : std_logic;
signal result, rd_1, rd_2 : std_logic_vector(15 downto 0);
--------------------------------
begin

G2: mpg port map(clk, btn, enable);
G4: ssd port map(clk, result, cathode, anode); -- ssd  port map
G5: reg_file port map(clk, counter, counter, counter, result, wenable, rd_1, rd_2); -- reg file port map
wenable <= enable(1);
p1_reg: process(clk, btn)
begin
    if rising_edge(clk) then
        if enable = "00001" then -- centre button for the counter and the we
                counter <= counter + 1;
        elsif enable = "00100"then -- west button for reset
            counter <= x"0";
        end if;
        an <= anode;
        cat <= cathode;
    end if;
    result <= rd_1 + rd_2;
end process p1_reg;
end Behavioral;
