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
-- TEST ENVIRONMENT FOR SINGLE CYCLE MIPS
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

-- MPG COMPONENT
component mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           enable : out STD_LOGIC_VECTOR(4 downto 0));
end component;

-- IF COMPONENT
component instruction_fetch is
    Port ( clk : in STD_LOGIC;
           branch_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jmp_addr : in STD_LOGIC_VECTOR (15 downto 0);
           jump : in STD_LOGIC;
           pc_src : in STD_LOGIC;
           en_btn: in std_logic;
           reset_btn: in std_logic;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pc_out: out std_logic_vector(15 downto 0));
end component;

-- SSD COMPONENT
component ssd is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

-- INSTRUCTION DECODE COMPONENT
component instruction_decode is
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
end component;

-- MAIN CONTROL UNIT COMPONENT
component main_control_unit is
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
end component;

-- INSTRUCTION EXECUTE COMPONENT
component instruction_execute is
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
end component;

-- DATA MEMORY COMPONENT
component data_memory is
         Port( clk: in std_logic;
               alu_res_in: in std_logic_vector(15 downto 0);
               read_data2: in std_logic_vector(15 downto 0);
               mem_write: in std_logic;
               mem_data: out std_logic_vector(15 downto 0);
               alu_res_out: out std_logic_vector(15 downto 0));
end component;

signal anode: std_logic_vector(3 downto 0);
signal cathode: std_logic_vector(6 downto 0);
signal enable_pc: std_logic_vector(4 downto 0);
signal result: std_logic_vector(15 downto 0):=x"0000";
signal pc: std_logic_vector(15 downto 0);
signal instruction: std_logic_vector(15 downto 0);

-- signals from control unit
signal reg_dst: STD_LOGIC;
signal ext_op: STD_LOGIC;
signal alu_src: STD_LOGIC;
signal branch: STD_LOGIC;
signal jmp: STD_LOGIC;
signal mem_write_ctrl: STD_LOGIC;
signal mem_to_reg: STD_LOGIC;
signal reg_write: STD_LOGIC;
signal alu_op: STD_LOGIC_VECTOR (2 downto 0);

-- signal from instruction decode
signal read_data1: std_logic_vector(15 downto 0);
signal read_data2: std_logic_vector(15 downto 0);
signal write_data: std_logic_vector(15 downto 0);
signal ext_imm: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;

-- signals from instruction execute
signal branch_address: std_logic_vector(15 downto 0);
signal alu_res: std_logic_vector(15 downto 0);
signal zero: std_logic;

--signals from instruction fetch
signal pc_src: std_logic;

--signals from data_memory;
signal alu_res_out: std_logic_vector(15 downto 0);
signal mem_data: std_logic_vector(15 downto 0);

signal jmp_addr: std_logic_vector(15 downto 0);
signal branch_addr: std_logic_vector(15 downto 0);
signal mem_write: std_logic;

begin

pc_src <= zero and branch;
write_data <= alu_res when mem_to_reg = '0' else mem_data;
jmp_addr <= pc(15 downto 13) & instruction(12 downto 0);
branch_addr <= pc + ext_imm;
mem_write <= enable_pc(2) and mem_write_ctrl;

G1: mpg port map(clk, btn, enable_pc);
G2: ssd port map(clk, result, cathode, anode);
G3: instruction_fetch port map(clk => clk, branch_addr => branch_addr, jmp_addr => jmp_addr, jump => jmp, pc_src => pc_src, en_btn => enable_pc(0), reset_btn => enable_pc(1), instruction => instruction, pc_out => pc);
G4: main_control_unit port map(instruction(15 downto 13), reg_dst, ext_op, alu_src, branch, jmp, mem_write_ctrl, mem_to_reg, reg_write, alu_op);
G5: instruction_decode port map(clk, instruction, reg_write, reg_dst, ext_op, write_data, read_data1, read_data2, ext_imm, func, sa);
G6: instruction_execute port map(pc, read_data1, read_data2, ext_imm, func, sa, alu_src, alu_op, branch_address, alu_res, zero);
G7: data_memory port map(clk => clk, alu_res_in => alu_res, read_data2 => read_data2, mem_write => mem_write, mem_data => mem_data, alu_res_out => alu_res_out); 

process(clk,sw)
begin
    if rising_edge(clk) then
        case sw(7 downto 5) is
            when "000" => result <= instruction; 
            when "001" => result <= pc;          
            when "010" => result <= read_data1;  
            when "011" => result <= read_data2;  
            when "100" => result <= ext_imm;  
            when "101" => result <= alu_res;   
            when "110" => result <= mem_data;
            when "111" => result <= write_data;
            when others => result <= x"0000";
        end case;
        led(10) <= reg_dst;
        led(9) <= ext_op;
        led(8) <= alu_src;
        led(7) <= branch;
        led(6) <= jmp;
        led(5 downto 3) <= alu_op;
        led(2) <= mem_write;
        led(1) <= reg_write;
        led(0) <= mem_to_reg;
        led(15 downto 11) <= "00000";
    end if;
end process;     
    an <= anode;
    cat <= cathode;
end Behavioral;
