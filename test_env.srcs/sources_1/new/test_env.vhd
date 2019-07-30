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
signal enable : std_logic_vector(4 downto 0);
signal cathode : std_logic_vector(6 downto 0);
signal anode : std_logic_vector(3 downto 0);
----------ROM----------------
signal address : std_logic_vector(7 downto 0);
signal do : std_logic_vector(15 downto 0);
type rom_type is array (0 to 255) of std_logic_vector(15 downto 0);
signal rom: rom_type := ( x"0000", x"0001", x"0002", x"0003", x"0004", x"0005", x"0006", x"0007", 
                          x"0008", x"0009", x"000A", x"000B", x"000C", x"000D", x"000E", x"000F", others => x"0000");
--------------------------------
begin
G2: mpg port map(clk, btn, enable);
G3: ssd port map(clk, do, cathode, anode); 
p1_rom: process(address)
begin
      do <= rom(conv_integer(address));
end process p1_rom;

p2_rom: process(clk, btn)
begin
         if rising_edge(clk) then
             if enable /= "0000" then
                	address <= address + 1;
		     end if;
		     an <= anode;
		     cat <= cathode;
		 end if;
end process p2_rom;

end Behavioral;
