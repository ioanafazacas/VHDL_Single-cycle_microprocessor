----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 04:23:46 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
Port ( 
clk:in std_logic;
RegWrite:in std_logic;
Instr:in std_logic_vector(25 downto 0);
RegDst:in std_logic;
ExtOp:in std_logic;
WD:in std_logic_vector(31 downto 0);
RD1:out std_logic_vector(31 downto 0);
RD2:out std_logic_vector(31 downto 0);
Ext_Imm:out std_logic_vector(31 downto 0);
func:out std_logic_vector(5 downto 0);
sa:out std_logic_vector(4 downto 0)
);
end ID;

architecture Behavioral of ID is

signal wa:std_logic_vector(4 downto 0);

component RF
port
(clk:in std_logic;
ra1:in std_logic_vector(4 downto 0);
ra2:in std_logic_vector(4 downto 0);
wa:in std_logic_vector(4 downto 0);
wd:in std_logic_vector(31 downto 0);
regwr: in std_logic;
rd1:out std_logic_vector(31 downto 0);
rd2:out std_logic_vector(31 downto 0)
);
end component;




begin

Register_file: RF port map
(
clk=>clk,
ra1=>Instr(25 downto 21),
ra2=>Instr(20 downto 16),
wa=>wa,
wd=>WD,
regwr=>RegWrite,
rd1=>RD1,
rd2=>RD2
);

--multiplexor care alege registrul destinatie
wa<=Instr(20 downto 16) when RegDst='0' else Instr(15 downto 11);

--extindere imediat
Ext_Imm(15 downto 0)<=Instr(15 downto 0);
Ext_Imm(31 downto 16)<=(others=>Instr(15)) when ExtOp='1' else (others =>'0');

sa<= Instr(10 downto 6);
func<=Instr(5 downto 0);

end Behavioral;
