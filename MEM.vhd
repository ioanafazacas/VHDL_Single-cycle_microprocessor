----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2024 05:10:35 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
Port ( 
clk:in std_logic;
MemWrite:in std_logic;
en:in std_logic;
ALUResin:in std_logic_vector(31 downto 0);
RD2:in std_logic_vector(31 downto 0);
ALUResout:out std_logic_vector(31 downto 0);
MemData:out std_logic_vector(31 downto 0);
rez:out std_logic_vector(31 downto 0)
);
end MEM;

architecture Behavioral of MEM is

signal addr:std_logic_vector(5 downto 0);
signal WriteData:std_logic_vector(31 downto 0);
signal ReadData:std_logic_vector(31 downto 0);

type ram_type is array(0 to 63)of std_logic_vector(31 downto 0);
signal ram:ram_type:=(
        0=>x"0000000c", --adresa sir de numere A
        4=>x"00000008", --dimensiune sir N
        8=>x"00000000", -- locatie stocare rezultat
        12=>x"0000000e", --14 A[1]
        13=>x"00000007", --7 A[2]
        14=>x"00000006", --6
        15=>x"00000014", --20
        16=>x"00000019", --25
        17=>x"0000000a", --10
        18=>x"00000012", --18
        19=>x"00000037", --55
        20=>x"00000028", --40
        21=>x"0000001E", --30
        22=>x"00000021", --33
        others=>x"00000000"
        );
--        0=>x"0000000c", --adresa sir de numere: A
--        4=>x"00000008", --dimensiune sir: N
--        8=>x"00000000", -- locatie stocare rezultat
--        12=>x"0000000e", --14 A[1]
--        16=>x"00000007", --7 A[2]
--        20=>x"00000006", --6
--        24=>x"00000014", --20
--        28=>x"00000019", --25
--        32=>x"0000000a", --10
--        36=>x"00000012", --18
--        40=>x"00000037", --55
--        44=>x"00000028", --40
--        48=>x"0000001E", --30
--        52=>x"00000021", --33
--        others=>x"00000000"
--        );
        
begin

addr<=ALUResin(5 downto 0); 
WriteData<=RD2;
ALUResout<=ALUResin;
MemData<=ReadData;

process(clk)
begin
if clk'event and clk='1' then
    if en='1' then 
        if MemWrite='1' then
            ram(conv_integer(addr))<=WriteData;
        end if;
    end if;
end if;
end process;

ReadData<=ram(conv_integer(addr));

rez<=ram(8);

end Behavioral;
