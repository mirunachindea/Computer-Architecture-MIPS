----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2019 04:26:27 PM
-- Design Name: 
-- Module Name: tx_fsm - Behavioral
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

entity tx_fsm is
    Port ( clk: in std_logic;
           tx_data : in STD_LOGIC_VECTOR (7 downto 0);
           tx_en : in STD_LOGIC;
           rst : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           tx : out STD_LOGIC;
           tx_rdy : out STD_LOGIC);
end tx_fsm;

architecture Behavioral of tx_fsm is

type state_type is(idle, start, bits, stop);
signal state: state_type;
signal bit_cnt: std_logic_vector(2 downto 0) := "000";

begin
process(clk, rst, tx_en, baud_en, tx_data)
begin
    if rst = '1' then
        state <= idle;
    elsif rising_edge(clk) then
        if baud_en = '1' then
            case state is
                when idle => if tx_en = '1' then
                                state <= start;
                                bit_cnt <= "000";
                             else
                                state <= idle;
                             end if;
                when start => state <= bits;
                when bits => if bit_cnt < "111" then 
                                state <= bits;
                                bit_cnt <= bit_cnt + 1;
                             else
                                state <= stop;
                             end if;
                when stop => state <= idle;
            end case;
       end if;
  end if;
end process;                               
                                
process(state, tx_data, bit_cnt)
begin
    case state is
        when idle => tx <= '1';
                     tx_rdy <= '1';
        when start => tx <= '0';
                      tx_rdy <= '0';
        when bits => tx <= tx_data(conv_integer(bit_cnt));
                     tx_rdy <= '0';
        when stop => tx <= '1';
                     tx_rdy <= '0';
    end case;
end process;

end Behavioral;
