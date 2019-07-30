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
-- TEST ENVIRONMENT FOR SERIAL COMMUNICATION TX
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
           RX: in std_logic;
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           TX: out std_logic);
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
component  instruction_decode2 is
    Port ( clk: in std_logic;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           reg_write : in STD_LOGIC;
           ext_op : in STD_LOGIC;
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           write_addr: in std_logic_vector(2 downto 0);
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
component instruction_execute2 is
        Port (  pc: in std_logic_vector(15 downto 0);
                read_data1: in std_logic_vector(15 downto 0);
                read_data2: in std_logic_vector(15 downto 0);
                ext_imm: in std_logic_vector(15 downto 0);
                func: in std_logic_vector(2 downto 0);
                sa: in std_logic;
                alu_src: in std_logic;
                alu_op: in std_logic_vector(2 downto 0);
                reg_dst: in std_logic;
                dest_reg_in1: in std_logic_vector(2 downto 0);
                dest_reg_in2: in std_logic_vector(2 downto 0);
                branch_address: out std_logic_vector(15 downto 0);
                alu_res: out std_logic_vector(15 downto 0);
                zero: out std_logic;
                dest_reg_out: out std_logic_vector(2 downto 0));
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

-- TX FSM COMPONENT
component tx_fsm is
    Port ( clk: in std_logic;
           tx_data : in STD_LOGIC_VECTOR (7 downto 0);
           tx_en : in STD_LOGIC;
           rst : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           tx : out STD_LOGIC;
           tx_rdy : out STD_LOGIC);
end component;

-- BAUD RATE GENERATOR COMPONENT
component baud_rate_generator_tx is
    Port ( clk : in STD_LOGIC;
           baud_en : out STD_LOGIC);
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
signal write_addr: std_logic_vector(2 downto 0);
signal ext_imm: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;

-- signals from instruction execute
signal branch_address: std_logic_vector(15 downto 0);
signal alu_res: std_logic_vector(15 downto 0);
signal zero: std_logic;
signal dest_reg: std_logic_vector(2 downto 0);

--signals from instruction fetch
signal pc_src: std_logic;

--signals from data_memory;
signal alu_res_out: std_logic_vector(15 downto 0);
signal mem_data: std_logic_vector(15 downto 0);

signal jmp_addr: std_logic_vector(15 downto 0);
signal mem_write: std_logic;

-- signals for pipeline registers
signal RegIF_ID: std_logic_vector(31 downto 0);
signal RegID_EX: std_logic_vector(81 downto 0);
signal RegEX_MEM: std_logic_vector(55 downto 0);
signal RegMEM_WB: std_logic_vector(36 downto 0);

-- signals for tx_fsm
signal tx_en: std_logic;
signal tx_rdy: std_logic;
signal btn_tx_en: std_logic;
signal btn_tx_rst: std_logic;

-- signnals for baud_rate_generator
signal baud_en: std_logic;

begin

pc_src <= RegEX_MEM(35) and RegEX_MEM(52); -- zero and branch
jmp_addr <= RegIF_ID(31 downto 29) & RegIF_ID(12 downto 0); -- pc(15 downto 13) & instruction(12 downto 0)
mem_write <= enable_pc(2) and mem_write_ctrl;
write_data <= RegMEM_WB(34 downto 19) when mem_to_reg = '1' else RegMEM_WB(18 downto 3);
write_addr <= RegMEM_WB(2 downto 0);

btn_tx_rst <= enable_pc(1); -- north btn
btn_tx_en <= enable_pc(2); -- west btn

G1: mpg port map(clk, btn, enable_pc);
G2: ssd port map(clk, result, cathode, anode);
G3: instruction_fetch port map(clk => clk, branch_addr => RegEX_MEM(51 downto 36), jmp_addr => jmp_addr, jump => jmp, pc_src => pc_src, en_btn => enable_pc(0), reset_btn => enable_pc(1), instruction => instruction, pc_out => pc);
G4: main_control_unit port map(RegIF_ID(15 downto 13), reg_dst, ext_op, alu_src, branch, jmp, mem_write_ctrl, mem_to_reg, reg_write, alu_op);
G5: instruction_decode2 port map(clk => clk, instruction => RegIF_ID(15 downto 0), reg_write => RegMEM_WB(35), ext_op => ext_op, write_data => write_data, write_addr => write_addr, read_data1 => read_data1, read_data2 => read_data2, ext_imm => ext_imm, func => func, sa => sa);
G6: instruction_execute2 port map(pc => pc, read_data1 => RegID_EX(56 downto 41), read_data2 => RegID_EX(40 downto 25), ext_imm => RegID_EX(24 downto 9), func => RegID_EX(8 downto 6), sa => sa, alu_src => RegID_EX(74), alu_op =>  RegID_EX(77 downto 75), reg_dst => RegID_EX(73), dest_reg_in1 => RegID_EX(5 downto 3), dest_reg_in2 => RegID_EX(2 downto 0), branch_address => branch_address, alu_res => alu_res, zero => zero, dest_reg_out => dest_reg);
G7: data_memory port map(clk => clk, alu_res_in => RegEX_MEM(34 downto 19), read_data2 => RegEX_MEM(18 downto 3), mem_write => RegEX_MEM(53), mem_data => mem_data, alu_res_out => alu_res_out); 
G8: baud_rate_generator_tx port map(clk => clk, baud_en => baud_en);
G9: tx_fsm port map(clk => clk, tx_data => alu_res(7 downto 0), tx_en => tx_en , rst => btn_tx_rst , baud_en => baud_en , tx => TX, tx_rdy => tx_rdy);

process(clk,sw)
begin
    if rising_edge(clk) then
        if btn(0) = '1' then
        RegIF_ID(31 downto 16) <= pc;
        RegIF_ID(15 downto 0) <= instruction;
        
        RegID_EX(81) <= mem_to_reg;
        RegID_EX(80) <= reg_write;
        RegID_EX(79) <= mem_write;
        RegID_EX(78) <= branch;
        RegID_EX(77 downto 75) <= alu_op;
        RegID_EX(74) <= alu_src;
        RegID_EX(73) <= reg_dst;
        RegID_EX(72 downto 57) <= RegIF_ID(15 downto 0);
        RegID_EX(56 downto 41) <= read_data1;
        RegID_EX(40 downto 25) <= read_data2;
        RegID_EX(24 downto 9) <= ext_imm;
        RegID_EX(8 downto 6) <= RegIF_ID(2 downto 0); -- func
        RegID_EX(5 downto 3) <= RegIF_ID(9 downto 7); -- rt
        RegID_EX(2 downto 0) <= RegIF_ID(6 downto 4); -- rd
        
        RegEX_MEM(55 downto 52) <= RegID_EX(81 downto 78);
        RegEX_MEM(51 downto 36) <= branch_address;
        RegEX_MEM(35) <= zero;
        RegEX_MEM(34 downto 19) <= alu_res;
        RegEX_MEM(18 downto 3) <= RegID_EX(40 downto 25);  -- rd2
        RegEX_MEM(2 downto 0) <= dest_reg;
        
        RegMEM_WB(36 downto 35) <= RegEX_MEM(55 downto 54);
        RegMEM_WB(34 downto 19) <= mem_data;
        RegMEM_WB(18 downto 3) <= alu_res_out;
        RegMEM_WB(2 downto 0) <= RegEX_MEM(2 downto 0);
       end if;
    end if;
end process;   

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
            when "110" => result <= "0000000000000" & write_addr;
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

process(clk, baud_en, btn_tx_en)
begin
-- baud_en = R
-- btn_tx_en = S
    if rising_edge(clk) then
        if btn_tx_en = '1' then
            tx_en <= '1';
        elsif baud_en = '1' then
            tx_en <= '0';
        end if;
    end if;
end process;  

--    an <= anode;
--    cat <= cathode;
end Behavioral;
