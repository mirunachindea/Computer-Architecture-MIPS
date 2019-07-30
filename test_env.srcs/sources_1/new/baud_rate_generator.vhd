----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2019 04:26:27 PM
-- Design Name: 
-- Module Name: baud_rate_generator - Behavioral
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
-- 
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

entity baud_rate_generator_tx is
    Port ( clk : in STD_LOGIC;
           baud_en : out STD_LOGIC);
end baud_rate_generator_tx;

architecture Behavioral of baud_rate_generator_tx is

signal counter: std_logic_vector(15 downto 0) := x"0000";
signal baud_en_s: std_logic;

begin
process(clk)
begin
    if rising_edge(clk) then
        counter <= counter + 1;
        if counter = "0010100010110000" then
            baud_en <= '1';
            counter <= x"0000";
        else baud_en <= '0';
        end if;
    end if;
end process;

--baud_en <= baud_en_s;

end Behavioral;
