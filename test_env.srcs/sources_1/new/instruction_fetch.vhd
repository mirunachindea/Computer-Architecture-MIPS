----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 04:37:54 PM
-- Design Name: 
-- Module Name: instruction_fetch - Behavioral
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

entity instruction_fetch is
    Port ( clk : in STD_LOGIC;
           branch_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jmp_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jump : in STD_LOGIC;
           pc_src : in STD_LOGIC;
           en_btn: in std_logic;
           reset_btn: in std_logic;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pc_out: out std_logic_vector(15 downto 0));
end instruction_fetch;

architecture Behavioral of instruction_fetch is

signal pc_s: std_logic_vector(15 downto 0);
signal pc_plus: std_logic_vector(15 downto 0);
signal pc_out_s: std_logic_vector(15 downto 0);
signal mux: std_logic_vector(15 downto 0);
signal rom_addr: std_logic_vector(7 downto 0);
signal do: std_logic_vector(15 downto 0);

type rom_type is array (0 to 255) of std_logic_vector(15 downto 0);
signal rom: rom_type := ( 
B"000_001_010_011_0_000", -- add -0530
B"000_001_010_011_0_001", -- sub -0531
B"000_000_010_011_1_010", -- sll -013A
B"000_000_010_011_1_011", -- srl -013B
B"000_001_010_011_0_100", -- and -0534
B"000_001_010_011_0_101", -- or  -0535
B"000_001_010_011_0_110", -- xor -0536
B"000_000_010_011_1_111", -- sra -013f
B"001_001_010_0000100", -- addi
B"010_001_010_1100100", -- lw
B"011_001_011_1100100", -- sw
B"100_001_010_0000111", -- beq 8907
B"101_001_010_1100100", -- andi
B"110_001_010_1100100", -- xori
B"111_0000000001000", -- j

-- FIBONACCI
--B"000_001_001_001_0_110", -- xor 1, 1, 1 -- 0496
--B"000_010_010_010_0_110", -- xor 2, 2, 2 -- 0926
--B"000_011_011_011_0_110", -- xor 3, 3, 3 -- 0DB6
--B"000_100_100_100_0_110", -- xor 4, 4, 4 -- 1246
--B"000_101_101_101_0_110", -- xor 5, 5, 5 -- 16D6
--B"001_001_010_0001001",   -- addi 2, 1, 9 -- 2509
--B"001_001_011_0000001",   -- addi 3, 1, 1 -- 2581
--B"001_001_100_0000001",   -- addi 4, 1, 1 -- 2601
--B"000_000_000_000_0_000", -- no op -- 0000  
--B"000_000_000_000_0_000", -- no op -- 0000
--B"000_000_000_000_0_000", -- no op -- 0000
--B"000_011_100_101_0_000", -- add 5, 3, 4  -> beginning of loop -- 0E50
--B"001_100_011_0000000",   -- addi 3, 4, 0 -- 3180
--B"000_000_000_000_0_000", -- no op -- 0000
--B"000_000_000_000_0_000", -- no op -- 0000
--B"001_101_100_0000000",   -- addi 4, 5, 0 -- 3600
--B"001_001_001_0000001",   -- addi 1, 1, 1 -- 2481
--B"000_000_000_000_0_000", -- no op -- 0000
--B"000_000_000_000_0_000", -- no op -- 0000
--B"000_000_000_000_0_000", -- no op -- 0000
--B"100_001_010_0000001",   -- beq 1, 2, 1 -- 8501
--B"111_0000000001011",     -- j 11 -- E00B
others => x"0000");
begin
process(clk, reset_btn)
begin
    if reset_btn = '1' then
        pc_s <= x"0000";
    else
        if rising_edge(clk) then
            if en_btn = '1' then
                pc_s <= pc_out_s;
            end if;
        end if;
    end if;
end process;

pc_plus <= pc_s + 1;
pc_out <= pc_plus;
instruction <= rom(conv_integer(pc_s(7 downto 0)));

process(pc_src, branch_addr, pc_plus)
begin
    case pc_src is  
        when '0' => mux <= pc_plus;
        when '1' => mux <= branch_addr;
   end case;
end process;

process(jump, jmp_addr, mux)
begin
    case jump is
        when '0' => pc_out_s <= mux;
        when '1' => pc_out_s <= jmp_addr;
    end case;
end process;
end Behavioral;
