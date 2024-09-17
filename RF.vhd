----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2024 05:28:59 PM
-- Design Name: 
-- Module Name: RF - Behavioral
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

entity RF is
Port (
clk:in std_logic;
ra1:in std_logic_vector(4 downto 0);
ra2:in std_logic_vector(4 downto 0);
wa:in std_logic_vector(4 downto 0);
wd:in std_logic_vector(31 downto 0);
regwr: in std_logic;
rd1:out std_logic_vector(31 downto 0);
rd2:out std_logic_vector(31 downto 0)
 );
end RF;

architecture Behavioral of RF is
type reg_array is array(0 to 31)of std_logic_vector(31 downto 0);
signal reg_file:reg_array:=(others=>X"00000000");
begin

process(clk)
begin
if clk'event and clk='1' then
    if regwr='1' then
        reg_file(conv_integer(wa))<=wd;
    end if;
end if;
end process;

rd1<=reg_file(conv_integer(ra1));
rd2<=reg_file(conv_integer(ra2));

end Behavioral;
