----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 05:19:46 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
Port (
Instr:in std_logic_vector(5 downto 0);
RegDst:out std_logic;
ExtOp:out std_logic;
ALUSrc:out std_logic;
Branch:out std_logic;
BraGTZ:out std_logic;
Jump:out std_logic;
ALUOp:out std_logic_vector(1 downto 0);
MemWrite:out std_logic;
MemtoReg:out std_logic;
RegWrite:out std_logic
 );
end UC;

architecture Behavioral of UC is

begin

process(Instr)
begin
   RegDst<='0'; ExtOp<='0'; ALUSrc<='0'; Branch<='0';
   BraGTZ<='0'; Jump<='0'; ALUOp<="00"; 
   MemWrite<='0'; MemtoReg<='0'; RegWrite<='0';
 case Instr is
   when "000000" => RegDst<='1'; RegWrite<='1'; ALUOp<="10"; --R
   when "001000" => ExtOp<='1'; ALUSrc<='1'; RegWrite<='1';--ADDI
   when "100010" => ExtOp<='1'; ALUSrc<='1'; MemtoReg<='1'; RegWrite<='1';  --LW
   when "100011" => ExtOp<='1'; ALUSrc<='1'; MemWrite<='1'; --SW
   when "000100" => ExtOp<='1'; Branch<='1'; ALUOp<="01"; --BEQ
   when "000111" => ExtOp<='1'; BraGTZ<='1'; ALUOp<="01"; --BGTZ
   when "001010" => ExtOp<='1'; ALUSrc<='1'; RegWrite<='1'; ALUOp<="11"; --SLTI
   when "000010" => Jump<='1'; ALUOp<="00"; --JUMP
   when others => ALUOp<="00"; --punem ceva ce nu folosim
 end case;
end process;


end Behavioral;
