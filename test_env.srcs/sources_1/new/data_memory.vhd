----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2019 05:02:24 PM
-- Design Name: 
-- Module Name: data_memory - Behavioral
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

entity data_memory is
         Port( clk: in std_logic;
               alu_res_in: in std_logic_vector(15 downto 0);
               read_data2: in std_logic_vector(15 downto 0);
               mem_write: in std_logic;
               mem_data: out std_logic_vector(15 downto 0);
               alu_res_out: out std_logic_vector(15 downto 0));
end data_memory;

architecture Behavioral of data_memory is

type ram_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal ram: ram_type := (others => x"0000");

begin
process(clk, alu_res_in, read_data2, mem_write)
begin
    if rising_edge(clk) then
        case mem_write is
            when '1' => ram(conv_integer(alu_res_in(3 downto 0))) <= read_data2;
            when others => null;
        end case;
    end if;
end process;

mem_data <= ram(conv_integer(alu_res_in));
alu_res_out <= alu_res_in;

end Behavioral;
