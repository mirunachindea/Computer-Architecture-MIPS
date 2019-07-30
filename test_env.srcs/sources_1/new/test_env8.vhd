----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2019 04:35:58 PM
-- Design Name: 
-- Module Name: test_env8 - Behavioral
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
-- -- TEST ENVIRONMENT FOR SERIAL COMMUNICATION RX
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
           RX: in std_logic;
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           TX: out std_logic);
end test_env;

architecture Behavioral of test_env is

-- MPG COMPONENT
component mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           enable : out STD_LOGIC_VECTOR(4 downto 0));
end component;

-- SSD COMPONENT
component ssd is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

-- BAUD RATE GENERATOR COMPONENT
component baud_rate_generator_rx is
    Port ( clk : in STD_LOGIC;
           baud_en : out STD_LOGIC);
end component;

-- RX FSM COMPONENT
component rx_fsm is
    Port ( clk : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx : in STD_LOGIC;
           rx_data : out STD_LOGIC_VECTOR (7 downto 0);
           rx_rdy : out STD_LOGIC);
end component;

signal anode: std_logic_vector(3 downto 0);
signal cathode: std_logic_vector(6 downto 0);
signal enable_pc: std_logic_vector(4 downto 0);
signal result: std_logic_vector(15 downto 0):=x"0000";

-- signals for rx_fsm
signal rx_rdy: std_logic;

-- signals for baud_rate_generator
signal baud_en: std_logic;

begin

result(15 downto 8) <= x"00";

G1: mpg port map(clk, btn, enable_pc);
G2: ssd port map(clk, result, cathode, anode);
G3: baud_rate_generator_rx port map(clk => clk, baud_en => baud_en);
G4: rx_fsm port map(clk => clk, baud_en => baud_en, rst => '0', rx => RX, rx_data => result(7 downto 0), rx_rdy => rx_rdy); 


an <= anode;
cat <= cathode;

end Behavioral;