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

entity test_fibonacci is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_fibonacci;

architecture Behavioral of test_fibonacci is
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
signal rom: rom_type := ( 
B"000_100_100_100_110",   -- 0926  xor $4, $4, $4
B"001_100_101_0001010",   -- 328A  addi $5 $4, 10
B"001_100_001_0000001",   -- 3081  addi $1 $4, 1
B"001_100_010_0000001",   -- 3101  addi $2 $4, 1
B"000_001_010_011_0_000", -- 0530  addi $3 $1, 2
B"001_010_001_0000000",   -- 2880  addi $1 $2, 0
B"001_011_010_0000000",   -- 2D00  addi $2 $3, 0
B"001_100_100_0000001",   -- 3201  addi $4 $4, 1
B"100_100_101_0000001",   -- 9281  beq $4 $5, 1
B"111_0000000000100",     -- E004  j4
others => x"0000");
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
             if enable /= "00000" then
                	address <= address + 1;
		     end if;
		     an <= anode;
		     cat <= cathode;
		 end if;
end process p2_rom;

end Behavioral;
