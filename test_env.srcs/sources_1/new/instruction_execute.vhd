----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2019 05:26:07 PM
-- Design Name: 
-- Module Name: instruction_execute - Behavioral
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

entity instruction_execute is
        Port (  pc: in std_logic_vector(15 downto 0);
                read_data1: in std_logic_vector(15 downto 0);
                read_data2: in std_logic_vector(15 downto 0);
                ext_imm: in std_logic_vector(15 downto 0);
                func: in std_logic_vector(2 downto 0);
                sa: in std_logic;
                alu_src: in std_logic;
                alu_op: in std_logic_vector(2 downto 0);
                branch_address: out std_logic_vector(15 downto 0);
                alu_res: out std_logic_vector(15 downto 0);
                zero: out std_logic);
end instruction_execute;

architecture Behavioral of instruction_execute is

signal alu_in: std_logic_vector(15 downto 0);
signal alu_control: std_logic_vector(2 downto 0);
signal alu_res_s: std_logic_vector(15 downto 0);

begin

process(alu_src, read_data2, ext_imm)
begin
    case alu_src is
        when '0' => alu_in <= read_data2;
        when '1' => alu_in <= ext_imm;
    end case;
end process;

process(alu_op, func)
begin
    case alu_op is
        when "000" => alu_control <= func; -- R type operations
        when "001" => alu_control <= "000"; -- addi, lw, sw
        when "010" => alu_control <= "001"; -- beq
        when "011" => alu_control <= "100"; -- andi
        when "100" => alu_control <= "110"; -- xori
        when "101" => alu_control <= "000"; -- jmp;
        when others => alu_control <= "000";
    end case;
end process;

process(read_data1, alu_in, alu_control, sa)
begin
    case alu_control is
        when "000" => alu_res_s <= read_data1 + alu_in; -- add
        when "001" => alu_res_s <= read_data1 - alu_in; -- sub
        when "010" => alu_res_s <= alu_in(14 downto 0) & '0'; -- sll
        when "011" => alu_res_s <= '0' & alu_in(15 downto 1); -- srl
        when "100" => alu_res_s <= read_data1 and alu_in; -- and
        when "101" => alu_res_s <= read_data1 or alu_in; -- or
        when "110" => alu_res_s <= read_data1 xor alu_in; -- xor
        when "111" => alu_res_s <= alu_in(15) & alu_in(15 downto 1); -- sra
   end case;
        if alu_res_s = x"0000" then
            zero <= '1';
        else zero <= '0';
        end if;
end process;

process(pc, ext_imm)
begin
    branch_address <= pc + ext_imm;
end process;

alu_res <= alu_res_s;

end Behavioral;
