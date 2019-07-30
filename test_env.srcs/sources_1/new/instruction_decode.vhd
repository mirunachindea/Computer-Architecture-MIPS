----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 05:03:06 PM
-- Design Name: 
-- Module Name: instruction_decode - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_decode is
    Port ( clk: in std_logic;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           reg_write : in STD_LOGIC;
           reg_dst : in STD_LOGIC;
           ext_op : in STD_LOGIC;
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           read_data1 : out STD_LOGIC_VECTOR (15 downto 0);
           read_data2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end instruction_decode;

architecture Behavioral of instruction_decode is
component reg_file is
    Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           reg_write : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;
signal reg_dst_out: std_logic_vector(2 downto 0);
signal ext_op_out: std_logic_vector(15 downto 0);
begin
G1: reg_file port map(clk => clk, ra1 => instruction(12 downto 10), ra2 => instruction(9 downto 7), wa => reg_dst_out, wd => write_data, reg_write => reg_write, rd1 => read_data1, rd2 => read_data2);
process(instruction, reg_dst)
begin
    case reg_dst is
        when '0' => reg_dst_out <= instruction(9 downto 7); -- rt
        when '1' => reg_dst_out <= instruction(6 downto 4); -- rd
        when others => reg_dst_out <= "000";
    end case;
end process;

process(instruction, ext_op)
begin
    case ext_op is
        when '0' => ext_op_out <= "000000000" & instruction(6 downto 0);
        when '1' => case instruction(6) is
                        when '0' => ext_op_out <= "000000000" & instruction(6 downto 0);
                        when '1' => ext_op_out <= "111111111" & instruction(6 downto 0);
                        when others => ext_op_out <= x"0000";
                        end case;
        when others => ext_op_out <= x"0000";
        end case;
end process;
                    
ext_imm <= ext_op_out;
func <= instruction(2 downto 0);
sa <= instruction(3);
end Behavioral;
