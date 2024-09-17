----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2024 05:51:25 PM
-- Design Name: 
-- Module Name: mpg - Behavioral
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

entity mpg is
 Port (clk: in std_logic;
        btn: in std_logic;
        en: out std_logic );
end mpg;

architecture Behavioral of mpg is
signal counter: std_logic_vector(15 downto  0):=(others=>'0');
signal q1: std_logic;
signal q2: std_logic;
signal q3: std_logic;
begin

process(clk)
begin
if clk'event and clk='1' then
    counter<= counter +1;
end if;
end process;

process(clk)
begin
if clk'event and clk='1' then
    if counter="1111111111111111" then 
        q1<=btn;
    end if;
end if;
end process;

process(clk)
begin
if clk'event and clk='1' then
    q2<=q1;
    q3<=Q2;
end if;
end process;

en<=(not q3) and q2;

end Behavioral;
