----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2019 09:11:07 PM
-- Design Name: 
-- Module Name: mpg - Behavioral
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

entity mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           enable : out STD_LOGIC_VECTOR(4 downto 0));
end mpg;

architecture Behavioral of mpg is
signal counter : std_logic_vector(15 downto 0);
signal q1, q2, q3 : std_logic_vector(4 downto 0);
begin
enable <= q1 and (not q2) ;
    p1 : process (clk)
    begin
        if rising_edge(clk) then
        counter <= counter + 1;
        end if;
    end process p1;
    
    p2 : process(clk, btn)
    begin
        if rising_edge(clk) then
                if counter = x"FFFF" then
                  q1 <= btn;
                end if;
            end if;
    end process p2;
    
    p3 : process (clk)
    begin
        if rising_edge(clk) then
                q2 <= q1;
                q3 <= q2;            
        end if;
    end process p3; 
end Behavioral;
