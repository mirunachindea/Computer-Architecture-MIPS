----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2019 04:09:00 PM
-- Design Name: 
-- Module Name: rx_fsm - Behavioral
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

entity rx_fsm is
    Port ( clk : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx : in STD_LOGIC;
           rx_data : out STD_LOGIC_VECTOR (7 downto 0);
           rx_rdy : out STD_LOGIC);
end rx_fsm;

architecture Behavioral of rx_fsm is

type state_type is(idle, start, bits, stop, waits);
signal state: state_type;
signal bit_cnt: std_logic_vector(2 downto 0) := "000";
signal baud_cnt: std_logic_vector(3 downto 0) := x"0";
signal rx_data_s: std_logic_vector(7 downto 0);

begin
process(clk, rst, rx, baud_en)
begin
    if rst = '1' then
        state <= idle;
    elsif rising_edge(clk) then
        if baud_en = '1' then
            baud_cnt <= baud_cnt + 1;
            case state is
                when idle => if rx = '0' then
                                state <= start;
                             end if;
                             bit_cnt <= "000";
                when start => if baud_cnt < "111" then
                                state <= start;
                              elsif rx = '1' then
                                state <= idle;
                              elsif rx = '0' and baud_cnt = "111" then
                                state <= bits;
                              end if;
                when bits => if bit_cnt < "111" then
                                state <= bits;
                                bit_cnt <= bit_cnt + 1;
                             elsif bit_cnt = "111" and baud_cnt = "1111" then
                                state <= stop;
                             end if;
                when stop => if baud_cnt < "1111" then
                                state <= stop;
                             elsif baud_cnt = "1111" then
                                state <= waits;
                             end if;
                when waits => if baud_cnt < "111" then
                                state <= waits;
                              elsif baud_cnt = "111" then
                                state <= idle;
                              end if;
           end case;
        end if;
     end if;
end process;
  
process(state) 
begin
    case state is
        when idle => rx_rdy <= '0';
        when start => rx_rdy <= '0';
        when bits => rx_rdy <= '0';
                     rx_data_s <= rx_data_s(6 downto 0) & rx;
        when stop => rx_rdy <= '0';
        when waits => rx_rdy <= '1';
    end case;
end process;

rx_data <= rx_data_s;

end Behavioral;
