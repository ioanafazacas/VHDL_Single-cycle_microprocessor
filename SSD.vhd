----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2024 04:21:43 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
  Port (clk:in std_logic;
  digit:in std_logic_vector(31 downto 0);
  an:out std_logic_vector(7 downto 0 );
  cat:out std_logic_vector(6 downto 0)
  );
end SSD;

architecture Behavioral of SSD is
signal counter:std_logic_vector(16 downto 0):=(others=>'0');
signal cifra:std_logic_vector(3 downto 0);
begin

process(clk)
begin
if clk'event and clk='1' then
    counter<= counter +1;
end if;
end process;

process(counter(16 downto 14))
begin
case counter(16 downto 14) is
    when "000" => an<="11111110";
    when "001" => an<="11111101";
    when "010" => an<="11111011";
    when "011" => an<="11110111";
    when "100" => an<="11101111";
    when "101" => an<="11011111";
    when "110" => an<="10111111";
    when others => an<="01111111";
end case;
end process;

process(counter(16 downto 14))
begin
case counter(16 downto 14) is
    when "000" => cifra<=digit(3 downto 0);
    when "001" => cifra<=digit(7 downto 4);
    when "010" => cifra<=digit(11 downto 8);
    when "011" => cifra<=digit(15 downto 12);
    when "100" => cifra<=digit(19 downto 16);
    when "101" => cifra<=digit(23 downto 20);
    when "110" => cifra<=digit(27 downto 24);
    when others => cifra<=digit(31 downto 28);
end case;
end process;

with cifra SELect
   cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

end Behavioral;
