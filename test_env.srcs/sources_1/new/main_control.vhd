----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2019 07:22:15 PM
-- Design Name: 
-- Module Name: main_control_unit - Behavioral
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

entity main_control_unit is
    Port ( instruction : in STD_LOGIC_VECTOR (2 downto 0);
           reg_dst : out STD_LOGIC;
           ext_op : out STD_LOGIC;
           alu_src : out STD_LOGIC;
           branch : out STD_LOGIC;
           jmp : out STD_LOGIC;
           mem_write : out STD_LOGIC;
           mem_to_reg : out STD_LOGIC;
           reg_write : out STD_LOGIC;
           alu_op : out STD_LOGIC_VECTOR (2 downto 0));
end main_control_unit;

architecture Behavioral of main_control_unit is
begin
    process(instruction)
        begin
        case instruction is
        when "000" => -- R-type instructions
            reg_dst <= '1';
            ext_op <= '0';
            alu_src <= '0';
            branch <= '0';
            jmp <= '0';
            alu_op <= "000";
            mem_write <= '0';
            reg_write <= '1';
            mem_to_reg <= '0';
        when "001" => -- addi
            reg_dst <= '0';
            ext_op <= '1';
            alu_src <= '1';
            branch <= '0';
            jmp <= '0';
            alu_op <= "001";
            mem_write <= '0';
            reg_write <= '1';
            mem_to_reg <= '0';
           
        when "010" => -- lw
            reg_dst <= '0';
            ext_op <= '1';
            alu_src <= '1';
            branch <= '0';
            jmp <= '0';
            alu_op <= "001";
            mem_write <= '0';
            reg_write <= '1';
            mem_to_reg <= '1';
        when "011" => -- sw
            reg_dst <= 'X';
            ext_op <= '1';
            alu_src <= '1';
            branch <= '0';
            jmp <= '0';
            alu_op <= "001";
            mem_write <= '1';
            reg_write <= 'X';
            mem_to_reg <= 'X';
        when "100" => -- beq
            reg_dst <= 'X';
            ext_op <= '1';
            alu_src <= '0';
            branch <= '1';
            jmp <= '0';
            alu_op <= "010";
            mem_write <= '0';
            reg_write <= 'X';
            mem_to_reg <= '0';
        when "101" => -- andi
            reg_dst <= '0';
            ext_op <= '0';
            alu_src <= '1';
            branch <= '0';
            jmp <= '0';
            alu_op <= "011";
            mem_write <= '0';
            reg_write <= '1';
            mem_to_reg <= '0';
        when "110" => -- xori
            reg_dst <= '0';
            ext_op <= '0';
            alu_src <= '1';
            branch <= '0';
            jmp <= '0';
            alu_op <= "100";
            mem_write <= '0';
            reg_write <= '1';
            mem_to_reg <= '0';
        when "111" => -- jmp
            reg_dst <= 'X';
            ext_op <= 'X';
            alu_src <= 'X';
            branch <= '0';
            jmp <= '1';
            alu_op <= "101";
            mem_write <= '0';
            reg_write <= '0';
            mem_to_reg <= '0';
        end case;
    end process;
end Behavioral;
